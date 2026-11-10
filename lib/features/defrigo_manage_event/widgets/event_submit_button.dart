import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class EventSubmitButton extends StatelessWidget {
  const EventSubmitButton({
    super.key,
    required this.onPressed,
    this.isEditing = false,
  });

  final VoidCallback onPressed;
  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          isEditing ? Icons.save_outlined : Icons.add_circle_outline,
        ),
        label: Text(
          isEditing ? 'Simpan Perubahan' : 'Buat Kegiatan',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}