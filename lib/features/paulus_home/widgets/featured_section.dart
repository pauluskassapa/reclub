import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/sample_activities.dart';
import '../models/activity.dart';
import 'activity_card.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.selectedTime,
    required this.selectedLocation,
  });

  final String searchQuery;
  final String selectedCategory;
  final ActivityTimeGroup? selectedTime;
  final String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    final query = searchQuery.trim().toLowerCase();
    final locationQuery = selectedLocation?.toLowerCase();
    final filteredActivities = sampleActivities.where((activity) {
      final searchableText =
          '${activity.title} ${activity.category} ${activity.location}'
              .toLowerCase();
      final matchesCategory =
          selectedCategory == 'Semua' ||
          activity.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchesTime =
          selectedTime == null || activity.timeGroup == selectedTime;
      final matchesLocation =
          locationQuery == null ||
          activity.location.toLowerCase().contains(locationQuery);

      return matchesCategory &&
          matchesTime &&
          matchesLocation &&
          searchableText.contains(query);
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
          ...filteredActivities.map(
            (activity) => ActivityCard(activity: activity),
          ),
      ],
    );
  }
}
