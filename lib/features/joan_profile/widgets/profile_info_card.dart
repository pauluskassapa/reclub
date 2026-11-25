import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'profile_avatar.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    super.key,
    required this.name,
    required this.bio,
    required this.upcomingCount,
    required this.completedCount,
    required this.sportCount,
  });

  final String name;
  final String bio;
  final int upcomingCount;
  final int completedCount;
  final int sportCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.text.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileAvatar(name: name),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            bio.isEmpty ? 'Belum ada deskripsi' : bio,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedText, fontSize: 15),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ProfileStat(value: '$upcomingCount', label: 'Mendatang'),
              SizedBox(
                height: 32,
                child: VerticalDivider(width: 42, color: Color(0xFFE7ECE9)),
              ),
              _ProfileStat(value: '$completedCount', label: 'Selesai'),
              SizedBox(
                height: 32,
                child: VerticalDivider(width: 42, color: Color(0xFFE7ECE9)),
              ),
              _ProfileStat(value: '$sportCount', label: 'Olahraga'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: const TextStyle(color: AppColors.mutedText, fontSize: 13),
      ),
    ],
  );
}
