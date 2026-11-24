import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/profile_activity.dart';

class ActivityHistoryCard extends StatelessWidget {
  const ActivityHistoryCard({super.key, required this.activity});

  final ProfileActivity activity;

  @override
  Widget build(BuildContext context) {
    final upcoming = activity.upcoming;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: AppColors.text.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(15)), child: Icon(activity.icon, color: AppColors.primary)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(activity.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(activity.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.mutedText, fontSize: 13)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      activity.sport,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activity.date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.mutedText, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ]),
          ),
          const SizedBox(width: 6),
          Icon(upcoming ? Icons.arrow_forward_ios_rounded : Icons.check_circle_rounded, size: upcoming ? 15 : 20, color: upcoming ? AppColors.mutedText : AppColors.primary),
        ],
      ),
    );
  }
}
