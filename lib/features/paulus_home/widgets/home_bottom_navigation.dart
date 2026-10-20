import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
    required this.onDestinationSelected,
    required this.onSearchPressed,
  });

  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onSearchPressed;

  static const _destinations = [
    (label: 'Home', icon: Icons.home_outlined),
    (label: 'Feed', icon: Icons.campaign_outlined),
    (label: 'Inbox', icon: Icons.chat_bubble_outline_rounded),
    (label: 'Menu', icon: Icons.keyboard_double_arrow_up_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 62,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.text.withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  for (var index = 0; index < _destinations.length; index++)
                    Expanded(
                      child: _NavigationButton(
                        label: _destinations[index].label,
                        icon: _destinations[index].icon,
                        isSelected: index == 0,
                        onTap: () => onDestinationSelected(index),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: AppColors.surface,
            elevation: 4,
            shape: const CircleBorder(),
            child: IconButton(
              tooltip: 'Cari kegiatan',
              onPressed: onSearchPressed,
              icon: const Icon(Icons.search, size: 25),
              color: AppColors.text,
              iconSize: 25,
              padding: const EdgeInsets.all(17),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(child: Icon(icon, color: AppColors.text, size: 25)),
        ),
      ),
    );
  }
}
