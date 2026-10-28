import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class DetailJoinButton extends StatelessWidget {
  const DetailJoinButton({
    super.key,
    required this.fee,
    required this.isJoined,
    required this.isFull,
    required this.onPressed,
  });

  final String fee;
  final bool isJoined;
  final bool isFull;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final bool disabled = !isJoined && isFull;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Biaya Patungan',
                    style: TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    fee,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: disabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isJoined ? const Color(0xFFEF4444) : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              icon: Icon(
                isJoined
                    ? Icons.close_rounded
                    : Icons.sports_soccer_rounded,
                size: 18,
              ),
              label: Text(
                isJoined
                    ? 'Batalkan Ikut'
                    : (disabled ? 'Slot Penuh' : 'Ikut Futsal'),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
