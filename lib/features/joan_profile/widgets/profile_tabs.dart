import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({super.key, required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: const Color(0xFFE9F0ED), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          _TabButton(label: 'Aktivitas', selected: selectedIndex == 0, onTap: () => onSelected(0)),
          _TabButton(label: 'Riwayat', selected: selectedIndex == 1, onTap: () => onSelected(1)),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: selected ? AppColors.surface : Colors.transparent, borderRadius: BorderRadius.circular(12)),
            child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: selected ? AppColors.primary : AppColors.mutedText, fontWeight: FontWeight.bold)),
          ),
        ),
      );
}
