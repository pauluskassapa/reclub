import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ConfirmationButton extends StatelessWidget {
  const ConfirmationButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.check_circle_outline),
        label: const Text('Konfirmasi pendaftaran'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          elevation: 0,
        ),
      ),
    );
  }
}
