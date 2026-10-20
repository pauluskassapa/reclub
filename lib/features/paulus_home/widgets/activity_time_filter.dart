import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ActivityTimeFilter extends StatelessWidget {
  const ActivityTimeFilter({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  static const all = 'Semua waktu';
  static const weekday = 'Hari kerja';
  static const weekend = 'Akhir pekan';

  static const _options = [all, weekday, weekend];

  final String selectedTime;
  final ValueChanged<String> onTimeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 14, 20, 6),
          child: Text(
            'Waktu kegiatan',
            style: TextStyle(
              color: AppColors.mutedText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 42,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _options.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final option = _options[index];
              final isSelected = option == selectedTime;

              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                selectedColor: AppColors.secondary,
                backgroundColor: AppColors.surface,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.text,
                ),
                onSelected: (_) => onTimeSelected(option),
              );
            },
          ),
        ),
      ],
    );
  }
}
