import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ActivityLocationFilter extends StatelessWidget {
  const ActivityLocationFilter({
    super.key,
    required this.selectedLocation,
    required this.onLocationSelected,
  });

  static const _locations = <String?>[
    null,
    'Jakarta Pusat',
    'Jakarta Selatan',
    'GBK',
  ];

  final String? selectedLocation;
  final ValueChanged<String?> onLocationSelected;

  String _labelFor(String? location) => location ?? 'Semua';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 6),
          child: Text(
            'Lokasi',
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
            itemCount: _locations.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final location = _locations[index];
              final isSelected = location == selectedLocation;

              return ChoiceChip(
                label: Text(_labelFor(location)),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.text,
                ),
                onSelected: (_) => onLocationSelected(location),
              );
            },
          ),
        ),
      ],
    );
  }
}
