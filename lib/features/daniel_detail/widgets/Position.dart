import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'detail_participant_list.dart';

class FutsalRoleOption {
  const FutsalRoleOption({
    required this.name,
    required this.icon,
  });

  final String name;
  final IconData icon;
}

class DetailPositionSelectorSheet extends StatefulWidget {
  const DetailPositionSelectorSheet({
    super.key,
    required this.participants,
    this.roleOptions = futsalRoles,
    this.activityTitle = 'Fun Futsal Bareng',
    this.headerIcon = Icons.sports_soccer_rounded,
  });

  final List<FutsalParticipant> participants;
  final List<FutsalRoleOption> roleOptions;
  final String activityTitle;
  final IconData headerIcon;

  // Alias agar kompatibel dengan pemanggilan lama
  static const List<FutsalRoleOption> roles = futsalRoles;

  // Buat role pemain futsal
  static const List<FutsalRoleOption> futsalRoles = [
    FutsalRoleOption(
      name: 'Kiper',
      icon: Icons.pan_tool_rounded,
    ),
    FutsalRoleOption(
      name: 'Anchor',
      icon: Icons.shield_rounded,
    ),
    FutsalRoleOption(
      name: 'Flank Kanan',
      icon: Icons.bolt_rounded,
    ),
    FutsalRoleOption(
      name: 'Flank Kiri',
      icon: Icons.bolt_rounded,
    ),
    FutsalRoleOption(
      name: 'Pivot',
      icon: Icons.sports_soccer_rounded,
    ),
    FutsalRoleOption(
      name: 'All-Rounder',
      icon: Icons.autorenew_rounded,
    ),
  ];

  // Buat role pemain basket (5 posisi utama + All-Rounder)
  static const List<FutsalRoleOption> basketRoles = [
    FutsalRoleOption(
      name: 'Point Guard (PG)',
      icon: Icons.sports_basketball_rounded,
    ),
    FutsalRoleOption(
      name: 'Shooting Guard (SG)',
      icon: Icons.gps_fixed_rounded,
    ),
    FutsalRoleOption(
      name: 'Small Forward (SF)',
      icon: Icons.bolt_rounded,
    ),
    FutsalRoleOption(
      name: 'Power Forward (PF)',
      icon: Icons.fitness_center_rounded,
    ),
    FutsalRoleOption(
      name: 'Center (C)',
      icon: Icons.shield_rounded,
    ),
    FutsalRoleOption(
      name: 'All-Rounder',
      icon: Icons.autorenew_rounded,
    ),
  ];

  @override
  State<DetailPositionSelectorSheet> createState() =>
      _DetailPositionSelectorSheetState();
}

class _DetailPositionSelectorSheetState
    extends State<DetailPositionSelectorSheet> {
  String? _selectedRole;

  String get _currentRole => _selectedRole ?? widget.roleOptions.last.name;

  Map<String, int> _buildPositionCounts() {
    final counts = <String, int>{};
    for (final participant in widget.participants) {
      counts[participant.position] = (counts[participant.position] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    final positionCounts = _buildPositionCounts();
    final selectedRole = _currentRole;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.82,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.mutedText.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.headerIcon,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pilih Posisi Bermain',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Tentukan role kamu di sesi ${widget.activityTitle}',
                          style: const TextStyle(
                            color: AppColors.mutedText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
                itemCount: widget.roleOptions.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final role = widget.roleOptions[index];
                  final isSelected = selectedRole == role.name;
                  final count = positionCounts[role.name] ?? 0;

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => setState(() => _selectedRole = role.name),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 1.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              role.icon,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        role.name,
                                        style: const TextStyle(
                                          color: AppColors.text,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: count > 0
                                            ? AppColors.secondary
                                                .withValues(alpha: 0.15)
                                            : AppColors.accent
                                                .withValues(alpha: 0.25),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        count > 0
                                            ? 'Terisi $count pemain'
                                            : 'Belum ada pemain',
                                        style: TextStyle(
                                          color: count > 0
                                              ? AppColors.secondary
                                              : const Color(0xFF9A6B00),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.mutedText.withValues(alpha: 0.5),
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(color: AppColors.surface),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(selectedRole),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.check_rounded, size: 20),
                  label: Text(
                    'Konfirmasi Posisi: $selectedRole',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
