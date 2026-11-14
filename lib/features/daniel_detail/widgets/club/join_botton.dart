import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ClubJoinBottomBar extends StatelessWidget {
  const ClubJoinBottomBar({
    super.key,
    required this.clubName,
    required this.isMember,
    required this.accentColor,
    required this.sportIcon,
    required this.onToggleMembership,
  });

  final String clubName;
  final bool isMember;
  final Color accentColor;
  final IconData sportIcon;
  final VoidCallback onToggleMembership;

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    isMember ? 'Status Keanggotaan' : 'Keanggotaan Komunitas',
                    style: const TextStyle(
                      color: AppColors.mutedText,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isMember ? 'Anggota Aktif ✓' : 'Gratis · Terbuka Umum',
                    style: TextStyle(
                      color: isMember ? accentColor : AppColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: onToggleMembership,
              style: FilledButton.styleFrom(
                backgroundColor:
                    isMember ? const Color(0xFFE5E7EB) : AppColors.primary,
                foregroundColor: isMember ? AppColors.text : Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: Icon(
                isMember ? Icons.check_circle_outline_rounded : sportIcon,
                size: 19,
              ),
              label: Text(
                isMember ? 'Terdaftar' : 'Gabung Klub',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}