import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HomePromoCard extends StatefulWidget {
  const HomePromoCard({super.key, required this.onDiscoverTap});

  final VoidCallback onDiscoverTap;

  @override
  State<HomePromoCard> createState() => _HomePromoCardState();
}

class _HomePromoCardState extends State<HomePromoCard> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 18),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2FF),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 48, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.logoBlue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'BARU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cari teman satu lapangan',
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Temukan kegiatan seru di dekatmu dan mulai main bareng.',
                    style: TextStyle(color: AppColors.mutedText, height: 1.25),
                  ),
                  TextButton.icon(
                    onPressed: widget.onDiscoverTap,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.logoBlue,
                      padding: const EdgeInsets.only(left: 0, top: 8),
                    ),
                    icon: const Text(
                      'Jelajahi kegiatan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    label: const Icon(Icons.arrow_forward, size: 16),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                tooltip: 'Tutup info',
                onPressed: () => setState(() => _isVisible = false),
                icon: const Icon(Icons.close, color: AppColors.mutedText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
