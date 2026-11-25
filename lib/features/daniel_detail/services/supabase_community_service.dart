import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Model pesan untuk fitur Ruang Diskusi Komunitas (Club & Match Chat).
class CommunityChatMessage {
  const CommunityChatMessage({
    required this.id,
    required this.activityTitle,
    required this.senderName,
    required this.senderRole,
    required this.messageText,
    required this.createdAt,
    this.isHost = false,
  });

  final String id;
  final String activityTitle;
  final String senderName;
  final String senderRole;
  final String messageText;
  final DateTime createdAt;
  final bool isHost;

  factory CommunityChatMessage.fromJson(Map<String, dynamic> json) {
    final role = (json['sender_role'] ?? 'Member').toString();
    return CommunityChatMessage(
      id: (json['id'] ?? DateTime.now().millisecondsSinceEpoch).toString(),
      activityTitle: (json['activity_title'] ?? '').toString(),
      senderName: (json['sender_name'] ?? 'Member').toString(),
      senderRole: role,
      messageText: (json['message_text'] ?? '').toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())?.toLocal() ??
              DateTime.now()
          : DateTime.now(),
      isHost: role.toLowerCase().contains('host') ||
          (json['sender_name'] ?? '').toString().contains('Paulus'),
    );
  }
}

/// Service penghubung aplikasi dengan Supabase PostgreSQL REST API
/// untuk komunikasi komunitas real-time dan sinkronisasi pesan.
class SupabaseCommunityService {
  SupabaseCommunityService._();

  static final SupabaseCommunityService instance =
      SupabaseCommunityService._();

  /// Kredensial Project Supabase RECLUB
  static const String supabaseUrl = 'https://akrxninlgfzxqanmlkfp.supabase.co';
  static const String supabasePublishableKey =
      'sb_publishable_BX1q8duJP9b0jcbw_sSC4g_nQkd1is0';

  static const String _tableName = 'community_messages';

  /// Menyimpan cache pesan lokal per kegiatan agar tetap responsif
  /// meskipun tabel Supabase belum dibuat atau sedang offline.
  final Map<String, List<CommunityChatMessage>> _localMessagesByActivity = {};

  bool _isCloudConnected = false;
  bool get isCloudConnected => _isCloudConnected;

  Map<String, String> get _headers => {
        'apikey': supabasePublishableKey,
        'Authorization': 'Bearer $supabasePublishableKey',
        'Content-Type': 'application/json; charset=UTF-8',
        'Prefer': 'return=representation',
      };

  /// Pesan status cepat khas komunitas olahraga (Quick Status Chips)
  static const List<String> quickStatusMessages = [
    '🏃 Sedang OTW ke lapangan!',
    '📍 Sudah sampai di lokasi, kumpul di mana?',
    '⏰ Maaf telat 10 menit ya teman-teman',
    '⚽ Aku bawa bola & rompi cadangan',
    '💧 Jangan lupa bawa air minum & sepatu indoor ya!',
  ];

  List<CommunityChatMessage> _getInitialSeedMessages(String activityTitle) {
    final now = DateTime.now();
    final isBasket = activityTitle.toLowerCase().contains('basket');

    if (isBasket) {
      return [
        CommunityChatMessage(
          id: 'seed-b1',
          activityTitle: activityTitle,
          senderName: 'Paulus Kassapa',
          senderRole: 'Host • Point Guard (PG)',
          messageText:
              'Halo teman-teman South Jakarta Hoops! Jumat sore kita main di Lapangan Kayu Indoor GOR Bulungan ya. Jangan lupa pakai sepatu basket non-marking 🏀',
          createdAt: now.subtract(const Duration(minutes: 45)),
          isHost: true,
        ),
        CommunityChatMessage(
          id: 'seed-b2',
          activityTitle: activityTitle,
          senderName: 'Defrigo Pratama',
          senderRole: 'Center (C)',
          messageText:
              'Siap kak Paulus! Aku isi posisi Center ya, bola Molten GG7X sudah aku bawa juga.',
          createdAt: now.subtract(const Duration(minutes: 28)),
        ),
        CommunityChatMessage(
          id: 'seed-b3',
          activityTitle: activityTitle,
          senderName: 'Alex Wijaya',
          senderRole: 'Shooting Guard (SG)',
          messageText:
              'Mantap! Parkiran motor di GOR Bulungan sore ini masih aman kan guys?',
          createdAt: now.subtract(const Duration(minutes: 12)),
        ),
      ];
    }

    return [
      CommunityChatMessage(
        id: 'seed-f1',
        activityTitle: activityTitle,
        senderName: 'Paulus Kassapa',
        senderRole: 'Host • Pivot',
        messageText:
            'Halo rekan-rekan Jakarta Futsal Club! Minggu pagi kita main di Lapangan 2 (Vinyl Indoor) Cilandak Sport Center ya. Bola & rompi sudah disiapkan ⚽🔥',
        createdAt: now.subtract(const Duration(minutes: 50)),
        isHost: true,
      ),
      CommunityChatMessage(
        id: 'seed-f2',
        activityTitle: activityTitle,
        senderName: 'Rizky Ramadhan',
        senderRole: 'Kiper',
        messageText:
            'Siap komandan! Posisi Kiper aman, aku datang 15 menit lebih awal buat pemanasan.',
        createdAt: now.subtract(const Duration(minutes: 32)),
      ),
      CommunityChatMessage(
        id: 'seed-f3',
        activityTitle: activityTitle,
        senderName: 'Joan Natasya',
        senderRole: 'Flank Kiri',
        messageText:
            'Asik! Teman-teman yang baru gabung jangan lupa pilih posisi mainnya dulu ya biar pembagian timnya pas 🙌',
        createdAt: now.subtract(const Duration(minutes: 14)),
      ),
    ];
  }

  /// Mengambil daftar pesan komunitas dari tabel `community_messages` di Supabase.
  /// Kompleksitas Waktu: O(n) untuk parsing n pesan dari JSON.
  Future<List<CommunityChatMessage>> fetchMessages(String activityTitle) async {
    final localList = _localMessagesByActivity.putIfAbsent(
      activityTitle,
      () => _getInitialSeedMessages(activityTitle),
    );

    try {
      final encodedTitle = Uri.encodeQueryComponent(activityTitle);
      final uri = Uri.parse(
        '$supabaseUrl/rest/v1/$_tableName'
        '?activity_title=eq.$encodedTitle'
        '&order=created_at.asc',
      );

      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        _isCloudConnected = true;
        final List<dynamic> decoded =
            jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;

        final cloudMessages = decoded
            .whereType<Map<String, dynamic>>()
            .map(CommunityChatMessage.fromJson)
            .toList();

        if (cloudMessages.isNotEmpty) {
          _localMessagesByActivity[activityTitle] = cloudMessages;
          return cloudMessages;
        } else {
          // Jika tabel di Supabase sudah dibuat namun masih kosong, tampilkan pesan awal
          return List<CommunityChatMessage>.from(localList);
        }
      }
    } catch (_) {
      _isCloudConnected = false;
    }

    return List<CommunityChatMessage>.from(localList);
  }

  /// Mengirim pesan baru ke Supabase (`INSERT INTO community_messages`)
  /// sekaligus memperbarui state lokal secara instan (Optimistic UI Update).
  Future<CommunityChatMessage> sendMessage({
    required String activityTitle,
    required String senderName,
    required String senderRole,
    required String messageText,
  }) async {
    final trimmed = messageText.trim();
    final newMessage = CommunityChatMessage(
      id: 'local-${DateTime.now().millisecondsSinceEpoch}',
      activityTitle: activityTitle,
      senderName: senderName,
      senderRole: senderRole,
      messageText: trimmed,
      createdAt: DateTime.now(),
    );

    final localList = _localMessagesByActivity.putIfAbsent(
      activityTitle,
      () => _getInitialSeedMessages(activityTitle),
    );
    localList.add(newMessage);

    try {
      final uri = Uri.parse('$supabaseUrl/rest/v1/$_tableName');
      final body = jsonEncode({
        'activity_title': activityTitle,
        'sender_name': senderName,
        'sender_role': senderRole,
        'message_text': trimmed,
      });

      final response = await http
          .post(uri, headers: _headers, body: body)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 201 || response.statusCode == 200) {
        _isCloudConnected = true;
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is List && decoded.isNotEmpty) {
          final saved = CommunityChatMessage.fromJson(
            decoded.first as Map<String, dynamic>,
          );
          localList[localList.length - 1] = saved;
          return saved;
        }
      }
    } catch (_) {
      _isCloudConnected = false;
    }

    return newMessage;
  }
}
