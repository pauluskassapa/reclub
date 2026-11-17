import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class EventDescriptionField extends StatelessWidget {
  const EventDescriptionField({
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
          'Deskripsi Kegiatan',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 4,
          minLines: 3,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Jelaskan kegiatan yang akan dilakukan...',
            alignLabelWithHint: true,
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Deskripsi kegiatan wajib diisi.';
            }

            if (value.trim().length < 10) {
              return 'Deskripsi minimal 10 karakter.';
            }

            return null;
          },
        ),
      ],
    );
  }
}