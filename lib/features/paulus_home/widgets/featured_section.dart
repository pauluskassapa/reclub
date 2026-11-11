import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/nearby_locations.dart';
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
    required this.radiusKm,
    required this.onClearFilters,
    this.additionalActivities = const [],
    required this.onCreateActivity,
  });

  final String searchQuery;
  final String selectedCategory;
  final ActivityTimeGroup? selectedTime;
  final String? selectedLocation;
  final double radiusKm;
  final VoidCallback onClearFilters;
  final List<Activity> additionalActivities;
  final VoidCallback onCreateActivity;

  @override
  Widget build(BuildContext context) {
    final query = searchQuery.trim().toLowerCase();
    NearbyLocation? location;
    for (final item in nearbyLocations) {
      if (item.name == selectedLocation) {
        location = item;
        break;
      }
    }
    final allActivities = [...sampleActivities, ...additionalActivities];
    final filteredActivities = allActivities.where((activity) {
      final searchableText =
          '${activity.title} ${activity.category} ${activity.location}'
              .toLowerCase();
      final matchesCategory =
          selectedCategory == 'Semua' ||
          activity.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchesTime =
          selectedTime == null || activity.timeGroup == selectedTime;
      final matchesLocation =
          location == null ||
          (activity.latitude != null &&
              activity.longitude != null &&
              distanceInKm(
                    fromLatitude: location.latitude,
                    fromLongitude: location.longitude,
                    toLatitude: activity.latitude!,
                    toLongitude: activity.longitude!,
                  ) <=
                  radiusKm);

      return matchesCategory &&
          matchesTime &&
          matchesLocation &&
          searchableText.contains(query);
    }).toList();

    if (location != null) {
      filteredActivities.sort((first, second) {
        final firstDistance = _distanceFrom(location!, first);
        final secondDistance = _distanceFrom(location, second);
        if (firstDistance == null) return secondDistance == null ? 0 : 1;
        if (secondDistance == null) return -1;
        return firstDistance.compareTo(secondDistance);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Kegiatan dekat kamu',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onCreateActivity,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Buat'),
              ),
            ],
          ),
        ),
        if (filteredActivities.isEmpty)
          _EmptyResults(onClearFilters: onClearFilters)
        else
          ...filteredActivities.map((activity) {
            final distance = location == null
                ? null
                : _distanceFrom(location, activity);
            return ActivityCard(activity: activity, distanceKm: distance);
          }),
      ],
    );
  }
}

double? _distanceFrom(NearbyLocation location, Activity activity) {
  final latitude = activity.latitude;
  final longitude = activity.longitude;
  if (latitude == null || longitude == null) return null;
  return distanceInKm(
    fromLatitude: location.latitude,
    fromLongitude: location.longitude,
    toLatitude: latitude,
    toLongitude: longitude,
  );
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onClearFilters});

  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 34,
              color: AppColors.primary,
            ),
            const SizedBox(height: 8),
            const Text(
              'Belum ada kegiatan yang cocok',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Coba ubah kata kunci atau filter pencarianmu.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedText),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onClearFilters,
              icon: const Icon(Icons.filter_alt_off_outlined),
              label: const Text('Hapus semua filter'),
            ),
          ],
        ),
      ),
    );
  }
}
