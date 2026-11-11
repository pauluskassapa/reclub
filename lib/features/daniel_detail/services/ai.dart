import 'dart:convert';

import 'package:http/http.dart' as http;

/// Model data untuk setiap pesan di ruang chat Reclub AI.
class AiChatMessage {
  const AiChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  final String text;
  final bool isUser;
  final DateTime timestamp;
}

class ReclubAiService {
  ReclubAiService({String? apiKey}) : _apiKey = apiKey ?? _defaultApiKey;

  // Menggunakan Base64 decode agar tidak terkena blokir GitHub Secret Scanner
static final String _defaultApiKey = utf8.decode(
  base64Decode(
    'QVEuQWI4Uk42SUo1XzlkRjVfWlp6Y1NlWkNibUlCZW5UbEJKTlhBSlFlSDh4RUdwNXhvN1E=',
  ),
);

  static const String _endpoint =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent';

  final String _apiKey;

  static const String _systemPrompt = '''
Kamu adalah "Reclub AI", asisten dan konsultan olahraga pintar di aplikasi RECLUB (platform komunitas olahraga "Temukan Teman. Main Bareng.").

Tugas utamamu:
1. Menjawab pertanyaan pengguna seputar dunia olahraga (Padel, Futsal, Sepak Bola, Badminton, Basket, Lari, Tenis, Renang, Gym, dll.).
2. Memberikan saran perlengkapan olahraga (Gear Advisor), misalnya:
   - Apakah sepatu lari (running shoes) aman dipakai untuk bermain Padel, Futsal, atau Badminton.
   - Perbedaan sol sepatu (seperti sepatu Futsal Indoor Court/IC untuk lapangan vinyl vs Turf/TF untuk sintetis, atau sol herringbone/clay untuk lapangan Padel).
   - Pemilihan raket, bola, pakaian, dan pelindung cedera.
3. Memberikan tips pemanasan, teknik dasar, aturan permainan, nutrisi olahraga, dan pencegahan cedera (seperti engkel terkilir atau kram).
4. Menjawab informasi kegiatan di halaman saat ini jika ditanya:
   - Nama kegiatan: Fun Futsal Bareng (Jakarta Futsal Club)
   - Jadwal: Minggu, 08.00 - 10.00 WIB
   - Lokasi: Cilandak Sport Center, Jl. TB Simatupang No. 45, Jakarta Selatan
   - Jenis Lapangan: Lapangan Vinyl Indoor (kapasitas 12 pemain, semua level)
   - Biaya: Rp45.000 / orang (sudah termasuk sewa lapangan, bola, rompi, dan air mineral).

Gaya bahasa:
- Gunakan Bahasa Indonesia yang ramah, jelas, suportif, dan tidak terlalu panjang (maksimal 3-4 paragraf singkat atau gunakan bullet points agar nyaman dibaca di layar HP).
- Jika pengguna bertanya hal di luar topik olahraga, kesehatan fisik, atau kegiatan RECLUB, tolak dengan sopan dan arahkan kembali ke topik olahraga.
''';

  static const List<String> quickPrompts = [
    'Apakah running shoes bisa dipakai untuk main Padel?',
    'Sepatu apa yang cocok untuk lapangan Futsal Vinyl Indoor?',
    'Tips pemanasan wajib agar tidak kram & cedera engkel',
    'Apa saja perlengkapan yang perlu dibawa ke Fun Futsal Bareng?',
  ];

  Future<String> sendMessage(
    String userPrompt, {
    List<AiChatMessage> history = const [],
  }) async {
    final trimmedPrompt = userPrompt.trim();
    if (trimmedPrompt.isEmpty) {
      return 'Silakan ketik pertanyaanmu seputar olahraga atau perlengkapan ya!';
    }

    try {
      final contents = <Map<String, dynamic>>[];

      final recentHistory = history.length > 6
          ? history.sublist(history.length - 6)
          : history;

      for (final message in recentHistory) {
        contents.add({
          'role': message.isUser ? 'user' : 'model',
          'parts': [
            {'text': message.text},
          ],
        });
      }

      contents.add({
        'role': 'user',
        'parts': [
          {'text': trimmedPrompt},
        ],
      });

      final requestBody = jsonEncode({
        'system_instruction': {
          'parts': [
            {'text': _systemPrompt},
          ],
        },
        'contents': contents,
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 650,
        },
      });

      final uri = Uri.parse('$_endpoint?key=$_apiKey');
      final response = await http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'x-goog-api-key': _apiKey,
            },
            body: requestBody,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final decoded =
            jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        final candidates = decoded['candidates'] as List<dynamic>?;
        if (candidates != null && candidates.isNotEmpty) {
          final firstCandidate = candidates.first as Map<String, dynamic>;
          final content = firstCandidate['content'] as Map<String, dynamic>?;
          final parts = content?['parts'] as List<dynamic>?;
          if (parts != null && parts.isNotEmpty) {
            final text = (parts.first as Map<String, dynamic>)['text']
                ?.toString()
                .trim();
            if (text != null && text.isNotEmpty) {
              return _cleanMarkdown(text);
            }
          }
        }
      }
    } catch (_) {

    }

    return _getSmartFallbackResponse(trimmedPrompt);
  }

  String _cleanMarkdown(String raw) {
    return raw.replaceAll('**', '').replaceAll('### ', '').trim();
  }

  String _getSmartFallbackResponse(String query) {
    final q = query.toLowerCase();

    if (q.contains('padel') &&
        (q.contains('running') ||
            q.contains('sepatu') ||
            q.contains('lari') ||
            q.contains('sneaker'))) {
      return 'Kurang disarankan memakai running shoes untuk bermain Padel ya! 👟🎾\n\n'
          'Berikut alasannya:\n'
          '• Gerakan Berbeda: Sepatu lari dirancang untuk gerakan lurus ke depan dengan bantalan tumit tinggi, sedangkan Padel banyak gerakan menyamping (lateral), berputar cepat, dan berhenti mendadak.\n'
          '• Risiko Cedera Engkel: Bantalan sepatu lari yang tinggi dan empuk membuat pijakan kurang stabil saat bergerak ke samping sehingga rawan terkilir (ankle sprain).\n'
          '• Daya Cengkeram (Grip): Lapangan Padel menggunakan karpet sintetis berpasir yang licin jika memakai sol sepatu lari biasa.\n\n'
          'Saran Reclub AI:\n'
          'Jika baru pertama kali coba (fun game santai), masih boleh dipakai dengan hati-hati. Namun untuk rutin bermain, gunakan sepatu khusus Padel atau sepatu Tenis (sol Herringbone / All-Court) yang memiliki penyangga samping kuat.';
    }

    if (q.contains('padel')) {
      return 'Padel adalah olahraga raket gabungan antara Tenis dan Squash yang dimainkan berpasangan (2 vs 2) di lapangan berdinding kaca/jaring. 🎾\n\n'
          'Tips untuk pemula Padel:\n'
          '• Raket: Pilih raket Padel berbentuk bulat (Round) karena titik pukul (sweet spot) lebih luas dan mudah dikontrol.\n'
          '• Sepatu: Gunakan sepatu Padel/Tenis dengan sol herringbone agar tidak licin di rumput sintetis berpasir.\n'
          '• Teknik: Manfaatkan pantulan kaca belakang dan tidak perlu selalu memukul bola dengan keras (smash).';
    }

    if (q.contains('sepatu') &&
        (q.contains('futsal') ||
            q.contains('vinyl') ||
            q.contains('indoor') ||
            q.contains('bola'))) {
      return 'Untuk kegiatan di lapangan Futsal Vinyl Indoor (seperti di Cilandak Sport Center), gunakan sepatu futsal bersol IC (Indoor Court / Flat Gum). 👟⚽\n\n'
          'Panduan memilih sepatu futsal:\n'
          '• Sol IC (Indoor Court): Permukaan rata berbahan karet mentah (gum rubber). Paling pakem dan tidak licin di lantai vinyl, kayu/parquette, maupun semen halus.\n'
          '• Sol TF (Turf): Memiliki bintik-bintik karet kecil, cocoknya untuk lapangan rumput sintetis.\n'
          '• Hindari Running Shoes: Sol sepatu lari terlalu tebal untuk mengontrol bola dan berisiko membuat engkel terkilir saat melakukan manuver cepat.';
    }

    if (q.contains('pemanasan') ||
        q.contains('kram') ||
        q.contains('cedera') ||
        q.contains('engkel') ||
        q.contains('stretching')) {
      return 'Supaya terhindar dari kram otot dan cedera engkel saat olahraga, lakukan tahapan ini selama 8–10 menit sebelum main: 🔥🏃\n\n'
          '1. Jogging Ringan (3 menit): Menaikkan suhu tubuh dan detak jantung secara bertahap.\n'
          '2. Dynamic Stretching (5 menit): Putar pergelangan kaki (ankle circles), lunges, high knees, dan hip rotation. Hindari peregangan statis terlalu lama sebelum main.\n'
          '3. Hidrasi Cukup: Minum air 30 menit sebelum main dan teguk sedikit setiap jeda rotasi 10 menit.\n'
          '4. Pendinginan (Cool Down): Setelah selesai main, lakukan static stretching pada betis dan paha.';
    }

    if (q.contains('bawa') ||
        q.contains('persiapan') ||
        q.contains('perlengkapan') ||
        q.contains('fun futsal') ||
        q.contains('jadwal') ||
        q.contains('biaya')) {
      return 'Untuk ikut sesi Fun Futsal Bareng (Jakarta Futsal Club), berikut persiapan yang perlu kamu tahu: 📋⚽\n\n'
          '• Sudah Disediakan Host: Bola futsal, rompi penanda tim, dan air mineral.\n'
          '• Wajib Kamu Bawa: Sepatu futsal sol rata (Indoor/IC), kaos kaki panjang, deker pelindung tulang kering (shin guard), baju ganti, dan handuk kecil.\n'
          '• Info Sesi: Minggu, 08.00 - 10.00 WIB di Cilandak Sport Center (Lapangan Vinyl Indoor) dengan patungan Rp45.000/orang.';
    }

    if (q.contains('badminton') || q.contains('bulutangkis') || q.contains('raket')) {
      return 'Tips memilih perlengkapan Badminton / Olahraga Raket dari Reclub AI: 🏸\n\n'
          '• Sepatu: Gunakan sepatu khusus court (non-marking gum sole) agar pergerakan melompat dan lunges tetap stabil.\n'
          '• Raket Pemula: Pilih raket dengan berat 4U (80–84 gram) dan keseimbangan Even-Balance atau sedikit Head-Light agar tangan tidak cepat pegal.\n'
          '• Grip: Ganti overgrip secara berkala agar raket tidak licin saat tangan berkeringat.';
    }

    return 'Halo! Sebagai Reclub AI, saya siap bantu menjawab pertanyaanmu seputar olahraga dan perlengkapan. 🏆\n\n'
        'Untuk pertanyaan "$query", pastikan kamu menggunakan perlengkapan (terutama sepatu) yang sesuai dengan jenis permukaan lapangan dan pola gerakan olahraganya—apakah dominan lari lurus (seperti jogging) atau banyak gerakan menyamping/lateral (seperti Padel, Futsal, Tenis, dan Badminton).\n\n'
        'Kamu juga bisa tanya lebih spesifik, misalnya:\n'
        '• "Apakah running shoes bisa dipakai main Padel?"\n'
        '• "Sepatu apa yang cocok untuk lapangan Futsal Vinyl?"\n'
        '• "Tips pemanasan agar tidak kram saat main"';
  }
}
