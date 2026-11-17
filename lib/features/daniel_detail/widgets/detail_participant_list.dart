import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class FutsalParticipant {
  const FutsalParticipant({
    required this.name,
    required this.position,
    this.isHost = false,
  });

  final String name;
  final String position;
  final bool isHost;
}

class DetailParticipantList extends StatelessWidget {
  const DetailParticipantList({
    super.key,
    required this.participants,
    required this.capacity,
  });

  final List<FutsalParticipant> participants;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    final int remaining = (capacity - participants.length).clamp(0, capacity);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daftar Peserta (${participants.length}/$capacity)',
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$remaining slot kosong',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: participants
                  .map(
                    (player) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: player.isHost
                            ? AppColors.primary
                            : AppColors.secondary.withValues(alpha: 0.2),
                        child: Text(
                          player.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: player.isHost
                                ? Colors.white
                                : AppColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      title: Row(
                        children: [
                          Text(
                            player.name,
                            style: const TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (player.isHost) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'HOST',
                                style: TextStyle(
                                  color: Color(0xFF9A6B00),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Text(
                        'Posisi: ${player.position}',
                        style: const TextStyle(
                          color: AppColors.mutedText,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
