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
}
