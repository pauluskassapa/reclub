import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SportShortcutSection extends StatelessWidget {
  const SportShortcutSection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  static const _shortcuts = [
    _SportShortcut('Semua', 'Semua', null, Icons.grid_view_rounded),
    _SportShortcut(
      'Futsal',
      'Sepak bola',
      'assets/images/futsal.jpg',
      Icons.sports_soccer,
    ),
    _SportShortcut(
      'Badminton',
      'Badminton',
      'assets/images/badminton.jpg',
      Icons.sports_tennis,
    ),
    _SportShortcut(
      'Basket',
      'Basket',
      'assets/images/basket.jpg',
      Icons.sports_basketball,
    ),
    _SportShortcut('Voli', 'Voli', null, Icons.sports_volleyball),
    _SportShortcut('Tenis', 'Tenis', null, Icons.sports_tennis),
    _SportShortcut('Sepeda', 'Sepeda', null, Icons.directions_bike),
    _SportShortcut('Renang', 'Renang', null, Icons.pool),
    _SportShortcut('Lari', 'Lari', null, Icons.sports),
    _SportShortcut('Yoga', 'Yoga', null, Icons.self_improvement),
    _SportShortcut('Pingpong', 'Pingpong', null, Icons.sports_tennis),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            'Pilih olahraga',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 104,
          child: ScrollConfiguration(
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: Scrollbar(
              child: ListView.separated(
                primary: false,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _shortcuts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final shortcut = _shortcuts[index];
                  final isSelected = shortcut.category == selectedCategory;

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => onCategorySelected(shortcut.category),
                    child: SizedBox(
                      width: 76,
                      child: Column(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: shortcut.imagePath == null
                                  ? (isSelected
                                        ? AppColors.primary
                                        : AppColors.accent)
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: isSelected
                                  ? Border.all(
                                      color: AppColors.primary,
                                      width: 2,
                                    )
                                  : null,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: shortcut.imagePath == null
                                ? Icon(
                                    shortcut.icon,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.text,
                                    size: 28,
                                  )
                                : Image.asset(
                                    shortcut.imagePath!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            shortcut.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.text,
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SportShortcut {
  const _SportShortcut(this.label, this.category, this.imagePath, this.icon);

  final String label;
  final String category;
  final String? imagePath;
  final IconData icon;
}
