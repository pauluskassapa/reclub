import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'widgets/feed_post_card.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('feed'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      children: const [
        Text(
          'Feed',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Kabar dari komunitas olahraga',
          style: TextStyle(color: AppColors.mutedText),
        ),
        SizedBox(height: 8),
        Text(
          'Postingan contoh komunitas',
          style: TextStyle(fontSize: 12, color: AppColors.mutedText),
        ),
        SizedBox(height: 16),
        FeedPostCard(
          club: 'Jakarta Futsal Club',
          initials: 'JF',
          category: 'Futsal',
          title: 'Main bareng akhir pekan',
          message: 'Latihan lebih seru kalau bareng teman! Yuk, siapkan sepatu dan ajak tim kamu untuk main futsal akhir pekan ini.',
          imagePath: 'assets/images/futsal.jpg',
          likes: 24,
        ),
        FeedPostCard(
          club: 'Badminton Weekend',
          initials: 'BW',
          category: 'Badminton',
          title: 'Pemula juga boleh ikut',
          message: 'Tidak perlu jago dulu untuk mulai bermain. Di komunitas ini kita latihan, belajar teknik dasar, dan saling menyemangati.',
          imagePath: 'assets/images/badminton.jpg',
          likes: 18,
        ),
        FeedPostCard(
          club: 'Jakarta Morning Runners',
          initials: 'JR',
          category: 'Lari',
          title: 'Mulai dari langkah kecil',
          message: 'Lari santai, pemanasan dulu, dan jangan lupa bawa air minum. Nikmati prosesnya bersama teman-teman komunitas.',
          imagePath: 'assets/images/running.jpg',
          likes: 31,
        ),
      ],
    );
  }
}
