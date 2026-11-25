import 'dart:convert';
import 'dart:io';

class RegistrationRepository {
  const RegistrationRepository();

  static const _projectUrl = 'https://akrxninlgfzxqanmlkfp.supabase.co';
  static const _publishableKey =
      'sb_publishable_BX1q8duJP9b0jcbw_sSC4g_nQkd1is0';
  static const _tableName = 'activity_participants';

  Future<void> saveRegistration({
    required String activityTitle,
    required String category,
    required String participantName,
  }) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 8);

    try {
      final uri = Uri.https(
        Uri.parse(_projectUrl).host,
        '/rest/v1/$_tableName',
        {'on_conflict': 'activity_title,participant_name'},
      );
      final request = await client.postUrl(uri).timeout(
        const Duration(seconds: 8),
      );
      request.headers.set('apikey', _publishableKey);
      request.headers.set('Authorization', 'Bearer $_publishableKey');
      request.headers.contentType = ContentType.json;
      request.headers.set(
        'Prefer',
        'resolution=merge-duplicates,return=representation',
      );
      request.write(
        jsonEncode({
          'activity_title': activityTitle.trim(),
          'category': category.trim(),
          'participant_name': participantName.trim(),
          'position': 'Peserta',
          'is_host': false,
        }),
      );

      final response = await request.close().timeout(
        const Duration(seconds: 8),
      );
      await response.drain<void>().timeout(const Duration(seconds: 8));
      if (response.statusCode != HttpStatus.ok &&
          response.statusCode != HttpStatus.created) {
        throw const RegistrationSaveException();
      }
    } catch (_) {
      throw const RegistrationSaveException();
    } finally {
      client.close(force: true);
    }
  }
}

class RegistrationSaveException implements Exception {
  const RegistrationSaveException();
}
