import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProfileEditMenu extends StatelessWidget {
  const ProfileEditMenu({super.key, required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(width: 42, height: 42, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.edit_outlined, color: AppColors.primary)),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Edit profil', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 16)), Text('Perbarui nama dan informasi kamu', style: TextStyle(color: AppColors.mutedText, fontSize: 13))])),
              const Icon(Icons.chevron_right_rounded, color: AppColors.mutedText),
            ],
          ),
        ),
      ),
    );
  }
}
