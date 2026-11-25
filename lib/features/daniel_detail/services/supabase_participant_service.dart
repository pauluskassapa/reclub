import 'dart:convert';

import 'package:http/http.dart' as http;

import '../widgets/detail_participant_list.dart';
import 'supabase_community_service.dart';

/// Service untuk menyimpan dan mengambil daftar peserta kegiatan ("Ikut Kegiatan")
/// ke tabel `activity_participants` di Supabase PostgreSQL REST API.
class SupabaseParticipantService {
  SupabaseParticipantService._();

  static final SupabaseParticipantService instance =
      SupabaseParticipantService._();

  static const String _tableName = 'activity_participants';

  /// Cache lokal per kegiatan agar tetap responsif saat offline
  /// atau jika tabel belum dibuat di Supabase.
  final Map<String, List<FutsalParticipant>> _localByActivity = {};

  bool _isCloudConnected = false;
  bool get isCloudConnected => _isCloudConnected;

  String get _baseUrl => SupabaseCommunityService.supabaseUrl;
  String get _apiKey => SupabaseCommunityService.supabasePublishableKey;

  Map<String, String> get _headers => {
        'apikey': _apiKey,
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json; charset=UTF-8',
        'Prefer': 'return=representation',
      };

  /// Mengambil daftar peserta dari Supabase lalu menggabungkannya dengan
  /// peserta bawaan (seed) tanpa duplikasi nama.
  Future<List<FutsalParticipant>> fetchParticipants({
    required String activityTitle,
    required List<FutsalParticipant> seedParticipants,
  }) async {
    final fallback = _localByActivity.putIfAbsent(
      activityTitle,
      () => List<FutsalParticipant>.from(seedParticipants),
    );

    try {
      final encodedTitle = Uri.encodeQueryComponent(activityTitle);
      final uri = Uri.parse(
        '$_baseUrl/rest/v1/$_tableName'
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

        final cloudParticipants = decoded
            .whereType<Map<String, dynamic>>()
            .map(
              (json) => FutsalParticipant(
                name: (json['participant_name'] ?? 'Peserta').toString(),
                position: (json['position'] ?? 'Peserta').toString(),
                isHost: json['is_host'] == true,
              ),
            )
            .toList();

        final merged = _mergeParticipants(seedParticipants, cloudParticipants);
        _localByActivity[activityTitle] = merged;
        return List<FutsalParticipant>.from(merged);
      }
    } catch (_) {
      _isCloudConnected = false;
    }

    return List<FutsalParticipant>.from(fallback);
  }

  /// Menyimpan peserta baru yang klik "Ikut Kegiatan" ke Supabase.
  /// Mengembalikan `true` jika berhasil tersimpan di Supabase cloud.
  Future<bool> joinActivity({
    required String activityTitle,
    required String category,
    required String participantName,
    required String position,
  }) async {
    final participant = FutsalParticipant(
      name: participantName,
      position: position,
    );

    final localList = _localByActivity.putIfAbsent(activityTitle, () => []);
    final existingIndex = localList.indexWhere(
      (p) => p.name.toLowerCase() == participantName.toLowerCase(),
    );
    if (existingIndex >= 0) {
      localList[existingIndex] = participant;
    } else {
      localList.add(participant);
    }

    try {
      final uri = Uri.parse(
        '$_baseUrl/rest/v1/$_tableName?on_conflict=activity_title,participant_name',
      );
      final headers = {
        ..._headers,
        'Prefer': 'resolution=merge-duplicates,return=representation',
      };
      final body = jsonEncode({
        'activity_title': activityTitle,
        'category': category,
        'participant_name': participantName,
        'position': position,
        'is_host': false,
      });

      final response = await http
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200 || response.statusCode == 201) {
        _isCloudConnected = true;
        return true;
      }
    } catch (_) {
      _isCloudConnected = false;
    }

    return false;
  }

  /// Menghapus peserta dari kegiatan saat klik "Batal Ikut" di Supabase.
  /// Mengembalikan `true` jika berhasil terhapus di Supabase cloud.
  Future<bool> leaveActivity({
    required String activityTitle,
    required String participantName,
  }) async {
    final localList = _localByActivity[activityTitle];
    localList?.removeWhere(
      (p) => p.name.toLowerCase() == participantName.toLowerCase(),
    );

    try {
      final encodedTitle = Uri.encodeQueryComponent(activityTitle);
      final encodedName = Uri.encodeQueryComponent(participantName);
      final uri = Uri.parse(
        '$_baseUrl/rest/v1/$_tableName'
        '?activity_title=eq.$encodedTitle'
        '&participant_name=eq.$encodedName',
      );

      final response = await http
          .delete(uri, headers: _headers)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200 || response.statusCode == 204) {
        _isCloudConnected = true;
        return true;
      }
    } catch (_) {
      _isCloudConnected = false;
    }

    return false;
  }

  List<FutsalParticipant> _mergeParticipants(
    List<FutsalParticipant> seed,
    List<FutsalParticipant> cloud,
  ) {
    final merged = List<FutsalParticipant>.from(seed);
    for (final player in cloud) {
      final index = merged.indexWhere(
        (existing) => existing.name.toLowerCase() == player.name.toLowerCase(),
      );
      if (index >= 0) {
        merged[index] = player;
      } else {
        merged.add(player);
      }
    }
    return merged;
  }
}
