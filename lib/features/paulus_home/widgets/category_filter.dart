import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class CategoryFilter extends StatefulWidget {
  const CategoryFilter({super.key, this.onCategorySelected});

  final ValueChanged<String>? onCategorySelected;

  @override
  State<CategoryFilter> createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  final List<String> _categories = [
    'Semua',
    'Sepak bola',
    'Basket',
    'Badminton',
    'Lari',
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;

          return ChoiceChip(
            label: Text(_categories[index]),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.text,
            ),
            onSelected: (_) {
              setState(() {
                _selectedIndex = index;
              });
              widget.onCategorySelected?.call(_categories[index]);
            },
          );
        },
      ),
    );
  }
}
