import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../daniel_detail/detail_page.dart';
import '../models/activity.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity, this.distanceKm});

  final Activity activity;
  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    final bool hasDetail =
        activity.title == 'Fun Futsal Bareng' ||
        activity.title == 'Basket Sore' ||
        activity.category.toLowerCase() == 'basket';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: hasDetail
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => DetailPage(activity: activity),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    activity.imagePath,
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.title,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        activity.category,
                        style: const TextStyle(color: AppColors.mutedText),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${activity.location} · ${activity.schedule}',
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      if (activity.capacity > 0)
                        Row(
                          children: [
                            const Icon(
                              Icons.people_alt_outlined,
                              color: AppColors.primary,
                              size: 15,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${activity.participants}/${activity.capacity} peserta · ${activity.capacity - activity.participants} slot',
                              style: const TextStyle(
                                color: AppColors.mutedText,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      if (distanceKm != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          '${distanceKm!.toStringAsFixed(1)} km dari area pilihan',
                          style: const TextStyle(
                            color: AppColors.mutedText,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (hasDetail)
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
