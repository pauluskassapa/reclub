import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/registration_option.dart';
import 'registration_section_card.dart';

class ScheduleSelector extends StatelessWidget {
  const ScheduleSelector({
    super.key,
    required this.schedules,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<RegistrationSchedule> schedules;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return RegistrationSectionCard(
      title: 'Pilih jadwal',
      child: Column(
        children: [
          for (var index = 0; index < schedules.length; index++) ...[
            if (index > 0) const SizedBox(height: 8),
            _OptionTile(
              title: schedules[index].title,
              subtitle: schedules[index].label,
              icon: Icons.calendar_month_outlined,
              selected: index == selectedIndex,
              onTap: () => onSelected(index),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.primary : const Color(0xFFE8EEEB);
    return Material(
      color: selected ? AppColors.primary.withValues(alpha: 0.06) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(subtitle, style: const TextStyle(color: AppColors.mutedText, fontSize: 12)),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? AppColors.primary : AppColors.mutedText,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
