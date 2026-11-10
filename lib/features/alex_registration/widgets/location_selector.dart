import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/registration_option.dart';
import 'registration_section_card.dart';

class LocationSelector extends StatelessWidget {
  const LocationSelector({
    super.key,
    required this.locations,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<RegistrationLocation> locations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return RegistrationSectionCard(
      title: 'Pilih lokasi',
      child: Column(
        children: [
          for (var index = 0; index < locations.length; index++) ...[
            if (index > 0) const SizedBox(height: 8),
            _LocationTile(
              location: locations[index],
              selected: index == selectedIndex,
              onTap: () => onSelected(index),
            ),
          ],
        ],
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    required this.location,
    required this.selected,
    required this.onTap,
  });

  final RegistrationLocation location;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xFFE8EEEB),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 3),
                    Text(location.address, style: const TextStyle(color: AppColors.mutedText, fontSize: 12)),
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
