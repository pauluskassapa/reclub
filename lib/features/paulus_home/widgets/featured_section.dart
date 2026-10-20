import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'activity_card.dart';
import 'activity_time_filter.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.selectedTime,
  });

  final String searchQuery;
  final String selectedCategory;
  final String selectedTime;

  @override
  Widget build(BuildContext context) {
    const activities = [
      ActivityCard(
        title: 'Fun Futsal Bareng',
        category: 'Sepak bola',
        location: 'Jakarta Selatan',
        schedule: 'Minggu, 08.00',
        imagePath: 'assets/images/futsal.jpg',
        timeGroup: ActivityTimeFilter.weekend,
        participants: 8,
        capacity: 12,
      ),
      ActivityCard(
        title: 'Badminton Santai',
        category: 'Badminton',
        location: 'Jakarta Pusat',
        schedule: 'Sabtu, 16.00',
        imagePath: 'assets/images/badminton.jpg',
        timeGroup: ActivityTimeFilter.weekend,
        participants: 5,
        capacity: 8,
      ),
      ActivityCard(
        title: 'Basket Sore',
        category: 'Basket',
        location: 'Jakarta Selatan',
        schedule: 'Jumat, 17.00',
        imagePath: 'assets/images/basket.jpg',
        timeGroup: ActivityTimeFilter.weekday,
        participants: 10,
        capacity: 12,
      ),
      ActivityCard(
        title: 'Lari Pagi Bareng',
        category: 'Lari',
        location: 'GBK, Jakarta',
        schedule: 'Minggu, 06.00',
        imagePath: 'assets/images/home_hero.jpg',
        timeGroup: ActivityTimeFilter.weekend,
        participants: 6,
        capacity: 15,
      ),
    ];

    final query = searchQuery.trim().toLowerCase();
    final filteredActivities = activities.where((activity) {
      final searchableText =
          '${activity.title} ${activity.category} ${activity.location}'
              .toLowerCase();
      final matchesCategory =
          selectedCategory == 'Semua' ||
          activity.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchesTime =
          selectedTime == ActivityTimeFilter.all ||
          activity.timeGroup == selectedTime;

      return matchesCategory && matchesTime && searchableText.contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Text(
            'Kegiatan dekat kamu',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (filteredActivities.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Kegiatan tidak ditemukan.',
              style: TextStyle(color: AppColors.mutedText),
            ),
          )
        else
          ...filteredActivities,
      ],
    );
  }
}
