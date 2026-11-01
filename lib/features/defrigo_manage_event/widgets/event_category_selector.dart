import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class EventCategorySelector extends StatelessWidget {
  const EventCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  static const _categories = [
    'Sepak bola',
    'Basket',
    'Badminton',
    'Lari',
    'Voli',
    'Tenis',
    'Sepeda',
    'Renang',
    'Yoga',
    'Pingpong',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori Olahraga',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((category) {
            final isSelected = selectedCategory == category;

            return ChoiceChip(
              label: Text(category),
              selected: isSelected,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.text,
                fontWeight: FontWeight.w600,
              ),
              onSelected: (_) {
                onCategorySelected(category);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}