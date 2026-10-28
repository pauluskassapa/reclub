import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class DetailActivityInfo extends StatelessWidget {
  const DetailActivityInfo({
    super.key,
    required this.schedule,
    required this.location,
    required this.venueAddress,
    required this.fee,
    required this.participantCount,
    required this.capacity,
    required this.description,
  });

  final String schedule;
  final String location;
  final String venueAddress;
  final String fee;
  final int participantCount;
  final int capacity;
  final String description;

  @override
  Widget build(BuildContext context) {
    final double progress =
        capacity > 0 ? (participantCount / capacity).clamp(0.0, 1.0) : 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.access_time_filled_rounded,
                  title: 'Jadwal Main',
                  subtitle: schedule,
                ),
                const Divider(height: 22),
                _InfoRow(
                  icon: Icons.location_on_rounded,
                  title: location,
                  subtitle: venueAddress,
                ),
                const Divider(height: 22),
                _InfoRow(
                  icon: Icons.payments_rounded,
                  title: 'Patungan Lapangan',
                  subtitle: '$fee (Termasuk sewa lapangan, bola & rompi)',
                ),
                const Divider(height: 22),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kuota Pemain Futsal',
                          style: TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '$participantCount/$capacity peserta',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        color: AppColors.primary,
                        backgroundColor: const Color(0xFFE2ECE8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Deskripsi Kegiatan',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              description,
              style: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
