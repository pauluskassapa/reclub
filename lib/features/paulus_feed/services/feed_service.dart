import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../daniel_detail/services/supabase_community_service.dart';
import '../models/feed_post.dart';

class FeedService {
  const FeedService();

  Future<List<FeedPost>> fetchPosts() async {
    final uri =
        Uri.parse('${SupabaseCommunityService.supabaseUrl}/rest/v1/feed_posts')
            .replace(
              queryParameters: {
                'select':
                    'id,club,initials,category,title,message,image_path,likes',
                'order': 'created_at.desc,id.asc',
                'limit': '100',
              },
            );
    final response = await http
        .get(
          uri,
          headers: {
            'apikey': SupabaseCommunityService.supabasePublishableKey,
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw Exception('Feed request failed: ${response.statusCode}');
    }
    final rows = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return rows
        .map((row) => FeedPost.fromJson(row as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<void> submitPost({
    required String club,
    required String category,
    required String title,
    required String message,
    required String imagePath,
  }) async {
    if (club.trim().isEmpty ||
        club.length > 80 ||
        title.trim().isEmpty ||
        title.length > 120 ||
        message.trim().isEmpty ||
        message.length > 2000) {
      throw ArgumentError('Invalid post');
    }
    final initials = club
        .trim()
        .split(RegExp(r'\s+'))
        .take(2)
        .map((word) => String.fromCharCode(word.runes.first))
        .join()
        .toUpperCase();
    final response = await http
        .post(
          Uri.parse(
            '${SupabaseCommunityService.supabaseUrl}/rest/v1/feed_posts',
          ),
          headers: {
            'apikey': SupabaseCommunityService.supabasePublishableKey,
            'Content-Type': 'application/json; charset=UTF-8',
            'Prefer': 'return=minimal',
          },
          body: jsonEncode({
            'club': club.trim(),
            'initials': initials,
            'category': category,
            'title': title.trim(),
            'message': message.trim(),
            'image_path': imagePath,
            'is_published': false,
          }),
        )
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 201) {
      throw Exception('Post submission failed: ${response.statusCode}');
    }
  }
}
