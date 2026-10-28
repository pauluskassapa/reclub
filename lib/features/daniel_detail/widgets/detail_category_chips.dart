import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class DetailCategoryChips extends StatelessWidget {
  const DetailCategoryChips({
    super.key,
    required this.category,
    required this.timeGroup,
    required this.skillLevel,
    required this.courtType,
  });

  final String category;
  final String timeGroup;
  final String skillLevel;
  final String courtType;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          _ChipItem(
            icon: Icons.sports_soccer_rounded,
            label: category,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          _ChipItem(
            icon: Icons.calendar_today_rounded,
            label: timeGroup,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 8),
          _ChipItem(
            icon: Icons.bolt_rounded,
            label: skillLevel,
            color: AppColors.logoBlue,
          ),
          const SizedBox(width: 8),
          _ChipItem(
            icon: Icons.stadium_outlined,
            label: courtType,
            color: const Color(0xFFB47800),
          ),
        ],
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  const _ChipItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
