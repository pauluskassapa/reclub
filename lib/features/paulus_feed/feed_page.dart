import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'models/feed_post.dart';
import 'services/feed_service.dart';
import 'widgets/feed_post_card.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, this.service = const FeedService()});

  final FeedService service;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<FeedPost> _posts = [];
  bool _loading = true;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final posts = await widget.service.fetchPosts();
      if (!mounted) return;
      setState(() {
        _posts = posts;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _failed = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (!_loading) await _loadPosts();
      },
      child: ListView(
        key: const PageStorageKey('feed'),
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        children: [
          const Text(
            'Feed',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Kabar dari komunitas olahraga',
            style: TextStyle(color: AppColors.mutedText),
          ),
          const SizedBox(height: 16),
          if (_loading) const LinearProgressIndicator(),
          if (_failed)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_off_outlined,
                    color: AppColors.mutedText,
                  ),
                  const SizedBox(height: 8),
                  const Text('Feed belum bisa dimuat. Coba lagi sebentar.'),
                  TextButton(
                    onPressed: _loadPosts,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          if (!_loading && !_failed && _posts.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Belum ada kabar komunitas. Tarik ke bawah untuk memperbarui.',
                textAlign: TextAlign.center,
              ),
            ),
          ..._posts.map(
            (post) => FeedPostCard(
              key: ValueKey(post.id),
              club: post.club,
              initials: post.initials,
              category: post.category,
              title: post.title,
              message: post.message,
              imagePath: post.imagePath,
              likes: post.likes,
            ),
          ),
        ],
      ),
    );
  }
}
