import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'activity_card.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    const activities = [
      ActivityCard(
        title: 'Fun Futsal Bareng',
        category: 'Sepak bola',
        location: 'Jakarta Selatan',
        schedule: 'Minggu, 08.00',
      ),
      ActivityCard(
        title: 'Badminton Santai',
        category: 'Badminton',
        location: 'Jakarta Pusat',
        schedule: 'Sabtu, 16.00',
      ),
    ];

    final query = searchQuery.trim().toLowerCase();
    final filteredActivities = activities.where((activity) {
      final searchableText =
          '${activity.title} ${activity.category} ${activity.location}'
              .toLowerCase();
      return searchableText.contains(query);
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
