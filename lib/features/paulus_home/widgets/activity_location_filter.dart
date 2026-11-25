import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/nearby_locations.dart';

class ActivityLocationFilter extends StatelessWidget {
  const ActivityLocationFilter({
    super.key,
    required this.selectedLocation,
    required this.onLocationSelected,
    required this.radiusKm,
    required this.onRadiusChanged,
    required this.isUsingDeviceLocation,
    required this.isLocating,
    required this.onUseDeviceLocation,
  });

  final String? selectedLocation;
  final ValueChanged<String?> onLocationSelected;
  final double radiusKm;
  final ValueChanged<double> onRadiusChanged;
  final bool isUsingDeviceLocation;
  final bool isLocating;
  final VoidCallback onUseDeviceLocation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cari di sekitar',
            style: TextStyle(
              color: AppColors.mutedText,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          OutlinedButton.icon(
            onPressed: isLocating ? null : onUseDeviceLocation,
            icon: isLocating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    isUsingDeviceLocation
                        ? Icons.my_location
                        : Icons.my_location_outlined,
                  ),
            label: Text(
              isLocating
                  ? 'Mencari lokasi...'
                  : isUsingDeviceLocation
                  ? 'Memakai lokasi saya'
                  : 'Gunakan lokasi saya',
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String?>(
            key: ValueKey(selectedLocation),
            initialValue: selectedLocation,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_on_outlined),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            hint: const Text('Pilih daerah'),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Semua daerah'),
              ),
              ...nearbyLocations.map(
                (location) => DropdownMenuItem<String?>(
                  value: location.name,
                  child: Text(location.name),
                ),
              ),
            ],
            onChanged: (location) {
              onLocationSelected(location);
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.radar, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              const Text(
                'Radius',
                style: TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${radiusKm.round()} km',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: radiusKm,
            min: 1,
            max: 20,
            divisions: 19,
            label: '${radiusKm.round()} km',
            activeColor: AppColors.primary,
            onChanged: onRadiusChanged,
          ),
        ],
      ),
    );
  }
}
