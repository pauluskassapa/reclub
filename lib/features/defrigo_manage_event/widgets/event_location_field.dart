import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class EventLocationField extends StatelessWidget {
  const EventLocationField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lokasi Kegiatan',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Contoh: Gelora Bung Karno, Jakarta',
            prefixIcon: const Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
            ),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Lokasi kegiatan wajib diisi.';
            }

            if (value.trim().length < 3) {
              return 'Lokasi minimal 3 karakter.';
            }

            return null;
          },
        ),
      ],
    );
  }
}