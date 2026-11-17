import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ClubStatsRow extends StatelessWidget {
  const ClubStatsRow({
    super.key,
    required this.memberCount,
    required this.rating,
    required this.weeklySessions,
    required this.accentColor,
  });

  final int memberCount;
  final double rating;
  final String weeklySessions;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _StatColumn(
                  icon: Icons.groups_rounded,
                  iconColor: accentColor,
                  value: '$memberCount',
                  label: 'Total Anggota',
                ),
              ),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: Color(0xFFE5E7EB),
              ),
              Expanded(
                child: _StatColumn(
                  icon: Icons.star_rounded,
                  iconColor: AppColors.accent,
                  value: rating.toStringAsFixed(1),
                  label: 'Rating Klub',
                ),
              ),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color: Color(0xFFE5E7EB),
              ),
              Expanded(
                child: _StatColumn(
                  icon: Icons.event_repeat_rounded,
                  iconColor: AppColors.primary,
                  value: weeklySessions,
                  label: 'Jadwal Rutin',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.mutedText,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}