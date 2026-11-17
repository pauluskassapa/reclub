import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class EventFormHeader extends StatelessWidget {
  const EventFormHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'KELOLA KEGIATAN',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Buat Kegiatan Baru',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Ajak teman baru dan buat pengalaman olahraga '
            'yang menyenangkan bersama RECLUB.',
            style: TextStyle(
              color: AppColors.mutedText,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}