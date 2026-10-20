import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/activity.dart';

class ActivityTimeFilter extends StatelessWidget {
  const ActivityTimeFilter({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  static const _options = [
    _TimeFilterOption('Semua waktu', null),
    _TimeFilterOption('Hari kerja', ActivityTimeGroup.weekday),
    _TimeFilterOption('Akhir pekan', ActivityTimeGroup.weekend),
  ];

  final ActivityTimeGroup? selectedTime;
  final ValueChanged<ActivityTimeGroup?> onTimeSelected;

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
              final isSelected = option.value == selectedTime;

              return ChoiceChip(
                label: Text(option.label),
                selected: isSelected,
                selectedColor: AppColors.secondary,
                backgroundColor: AppColors.surface,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.text,
                ),
                onSelected: (_) => onTimeSelected(option.value),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TimeFilterOption {
  const _TimeFilterOption(this.label, this.value);

  final String label;
  final ActivityTimeGroup? value;
}
