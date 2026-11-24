import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';


class TeamShuffleResult {
  const TeamShuffleResult({
    required this.teams,
    required this.reserves,
    required this.playersPerTeam,
  });

  final List<List<String>> teams;
  final List<String> reserves;
  final int playersPerTeam;
}

class TeamGenerator extends StatefulWidget {
  const TeamGenerator({
    super.key,
    required this.participantNames,
    this.defaultTeamCount = 2,
    this.defaultPlayersPerTeam = 5,
    this.random,
  });

  final List<String> participantNames;
  final int defaultTeamCount;
  final int defaultPlayersPerTeam;
  final Random? random;

  /// Mengacak [names] dengan Fisher-Yates Shuffle lalu membaginya secara merata
  /// (round-robin) ke [teamCount] tim dengan batas maksimal [playersPerTeam] per tim.
  ///
  /// Kompleksitas Waktu: O(n), Kompleksitas Ruang: O(n) untuk n peserta.
  static TeamShuffleResult generateTeams({
    required List<String> names,
    required int teamCount,
    required int playersPerTeam,
    Random? random,
  }) {
    final shuffled = List<String>.from(names)..shuffle(random ?? Random());
    final maxAssigned = teamCount * playersPerTeam;
    final assignedCount =
        shuffled.length < maxAssigned ? shuffled.length : maxAssigned;

    final teams = List<List<String>>.generate(teamCount, (_) => <String>[]);
    for (var i = 0; i < assignedCount; i++) {
      teams[i % teamCount].add(shuffled[i]);
    }

    final reserves = shuffled.length > assignedCount
        ? shuffled.sublist(assignedCount)
        : <String>[];

    return TeamShuffleResult(
      teams: teams,
      reserves: reserves,
      playersPerTeam: playersPerTeam,
    );
  }

  @override
  State<TeamGenerator> createState() =>
      _TeamGeneratorState();
}

class _TeamGeneratorState extends State<TeamGenerator> {
  static const int _minTeams = 2;
  static const int _maxTeams = 6;
  static const int _minPlayersPerTeam = 1;
  static const int _maxPlayersPerTeam = 10;

  static const List<Color> _teamColors = [
    Color(0xFF146B4A), // Hijau
    Color(0xFFEA580C), // Oranye
    Color(0xFF2563EB), // Biru
    Color(0xFF7C3AED), // Ungu
    Color(0xFF0891B2), // Teal
    Color(0xFFDC2626), // Merah
  ];

  static const List<String> _teamLabels = [
    'TIM A',
    'TIM B',
    'TIM C',
    'TIM D',
    'TIM E',
    'TIM F',
  ];

  late final TextEditingController _teamCountController;
  late final TextEditingController _playersPerTeamController;

  late int _teamCount;
  late int _playersPerTeam;
  TeamShuffleResult? _result;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _teamCount = widget.defaultTeamCount.clamp(_minTeams, _maxTeams);
    _playersPerTeam = widget.defaultPlayersPerTeam.clamp(
      _minPlayersPerTeam,
      _maxPlayersPerTeam,
    );
    _teamCountController = TextEditingController(text: '$_teamCount');
    _playersPerTeamController = TextEditingController(text: '$_playersPerTeam');
  }

  @override
  void didUpdateWidget(covariant TeamGenerator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_result != null &&
        oldWidget.participantNames.length != widget.participantNames.length) {
      _shuffleTeams();
    }
  }

  @override
  void dispose() {
    _teamCountController.dispose();
    _playersPerTeamController.dispose();
    super.dispose();
  }

  void _updateTeamCount(int value) {
    final clamped = value.clamp(_minTeams, _maxTeams);
    setState(() {
      _teamCount = clamped;
      _teamCountController.text = '$clamped';
      _validationError = null;
    });
  }

  void _updatePlayersPerTeam(int value) {
    final clamped = value.clamp(_minPlayersPerTeam, _maxPlayersPerTeam);
    setState(() {
      _playersPerTeam = clamped;
      _playersPerTeamController.text = '$clamped';
      _validationError = null;
    });
  }

  void _onTeamCountTextChanged(String raw) {
    final parsed = int.tryParse(raw.trim());
    setState(() {
      if (parsed == null) {
        _validationError = 'Masukkan angka jumlah tim ($_minTeams–$_maxTeams).';
      } else if (parsed < _minTeams || parsed > _maxTeams) {
        _validationError = 'Jumlah tim harus antara $_minTeams sampai $_maxTeams.';
      } else {
        _teamCount = parsed;
        _validationError = null;
      }
    });
  }

  void _onPlayersPerTeamTextChanged(String raw) {
    final parsed = int.tryParse(raw.trim());
    setState(() {
      if (parsed == null) {
        _validationError =
            'Masukkan angka pemain per tim ($_minPlayersPerTeam–$_maxPlayersPerTeam).';
      } else if (parsed < _minPlayersPerTeam || parsed > _maxPlayersPerTeam) {
        _validationError =
            'Jumlah pemain per tim harus antara $_minPlayersPerTeam sampai $_maxPlayersPerTeam.';
      } else {
        _playersPerTeam = parsed;
        _validationError = null;
      }
    });
  }

  void _shuffleTeams() {
    final parsedTeams = int.tryParse(_teamCountController.text.trim());
    final parsedPlayers = int.tryParse(_playersPerTeamController.text.trim());

    if (parsedTeams == null ||
        parsedTeams < _minTeams ||
        parsedTeams > _maxTeams) {
      setState(() {
        _validationError = 'Jumlah tim harus antara $_minTeams sampai $_maxTeams.';
      });
      return;
    }

    if (parsedPlayers == null ||
        parsedPlayers < _minPlayersPerTeam ||
        parsedPlayers > _maxPlayersPerTeam) {
      setState(() {
        _validationError =
            'Jumlah pemain per tim harus antara $_minPlayersPerTeam sampai $_maxPlayersPerTeam.';
      });
      return;
    }

    if (widget.participantNames.length < 2) {
      setState(() {
        _validationError = 'Minimal 2 peserta terdaftar untuk mengacak tim.';
      });
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _teamCount = parsedTeams;
      _playersPerTeam = parsedPlayers;
      _validationError = null;
      _result = TeamGenerator.generateTeams(
        names: widget.participantNames,
        teamCount: _teamCount,
        playersPerTeam: _playersPerTeam,
        random: widget.random,
      );
    });
  }

  String _initialsOf(String name) {
    final parts = name
        .replaceAll('(Kamu)', '')
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String _buildCapacityHint() {
    final totalParticipants = widget.participantNames.length;
    final totalNeeded = _teamCount * _playersPerTeam;
    if (totalParticipants == totalNeeded) {
      return 'Pas! $totalParticipants peserta terbagi rata ke $_teamCount tim ($_playersPerTeam orang/tim).';
    }
    if (totalParticipants > totalNeeded) {
      final reserveCount = totalParticipants - totalNeeded;
      return 'Total $_teamCount tim × $_playersPerTeam orang = $totalNeeded pemain ($reserveCount peserta masuk cadangan).';
    }
    final emptySlots = totalNeeded - totalParticipants;
    return 'Butuh $totalNeeded pemain, tersedia $totalParticipants peserta ($emptySlots slot masih kosong).';
  }

  @override
  Widget build(BuildContext context) {
    final totalParticipants = widget.participantNames.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.shuffle_rounded,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pembagian Tim Otomatis',
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$totalParticipants peserta terdaftar • Acak nama tim Basket',
                        style: const TextStyle(
                          color: AppColors.mutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Input Jumlah Tim & Pemain per Tim
            Row(
              children: [
                Expanded(
                  child: _NumberStepperField(
                    key: const ValueKey('team_count_stepper'),
                    label: 'Mau Berapa Tim',
                    unit: 'Tim',
                    controller: _teamCountController,
                    value: _teamCount,
                    min: _minTeams,
                    max: _maxTeams,
                    onDecrement: () => _updateTeamCount(_teamCount - 1),
                    onIncrement: () => _updateTeamCount(_teamCount + 1),
                    onChanged: _onTeamCountTextChanged,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _NumberStepperField(
                    key: const ValueKey('players_per_team_stepper'),
                    label: '1 Tim Berapa Orang',
                    unit: 'Orang',
                    controller: _playersPerTeamController,
                    value: _playersPerTeam,
                    min: _minPlayersPerTeam,
                    max: _maxPlayersPerTeam,
                    onDecrement: () =>
                        _updatePlayersPerTeam(_playersPerTeam - 1),
                    onIncrement: () =>
                        _updatePlayersPerTeam(_playersPerTeam + 1),
                    onChanged: _onPlayersPerTeamTextChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Info kapasitas atau pesan validasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: _validationError != null
                    ? const Color(0xFFFEF2F2)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _validationError != null
                      ? const Color(0xFFFCA5A5)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _validationError != null
                        ? Icons.error_outline_rounded
                        : Icons.info_outline_rounded,
                    size: 16,
                    color: _validationError != null
                        ? const Color(0xFFDC2626)
                        : AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _validationError ?? _buildCapacityHint(),
                      style: TextStyle(
                        color: _validationError != null
                            ? const Color(0xFFDC2626)
                            : AppColors.mutedText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tombol Acak Tim
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: const ValueKey('shuffle_teams_button'),
                onPressed: _shuffleTeams,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                icon: Icon(
                  _result == null ? Icons.casino_rounded : Icons.refresh_rounded,
                  size: 19,
                ),
                label: Text(
                  _result == null ? 'Acak Tim Sekarang' : 'Acak Ulang Tim',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            // Hasil Acakan Tim
            if (_result == null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Atur jumlah tim dan jumlah orang per tim di atas (misal 2 tim × 5 orang untuk 5v5 atau 3 tim × 3 orang untuk 3x3), lalu tekan "Acak Tim Sekarang".',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 14),
              ...List.generate(_result!.teams.length, (index) {
                final teamMembers = _result!.teams[index];
                final color = _teamColors[index % _teamColors.length];
                final label = index < _teamLabels.length
                    ? _teamLabels[index]
                    : 'TIM ${index + 1}';

                return _TeamResultCard(
                  teamLabel: label,
                  color: color,
                  members: teamMembers,
                  targetSize: _result!.playersPerTeam,
                  initialsOf: _initialsOf,
                );
              }),
              if (_result!.reserves.isNotEmpty) ...[
                const SizedBox(height: 4),
                _ReservePlayersCard(
                  reserves: _result!.reserves,
                  initialsOf: _initialsOf,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _NumberStepperField extends StatelessWidget {
  const _NumberStepperField({
    super.key,
    required this.label,
    required this.unit,
    required this.controller,
    required this.value,
    required this.min,
    required this.max,
    required this.onDecrement,
    required this.onIncrement,
    required this.onChanged,
  });

  final String label;
  final String unit;
  final TextEditingController controller;
  final int value;
  final int min;
  final int max;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.mutedText,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _StepperIconButton(
                icon: Icons.remove_rounded,
                enabled: value > min,
                onTap: onDecrement,
              ),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      child: TextField(
                        controller: controller,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        onChanged: onChanged,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 2),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      unit,
                      style: const TextStyle(
                        color: AppColors.mutedText,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _StepperIconButton(
                icon: Icons.add_rounded,
                enabled: value < max,
                onTap: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepperIconButton extends StatelessWidget {
  const _StepperIconButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.surface
              : AppColors.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: enabled ? 0.2 : 0.08),
          ),
        ),
        child: Icon(
          icon,
          size: 17,
          color: enabled
              ? AppColors.primary
              : AppColors.mutedText.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _TeamResultCard extends StatelessWidget {
  const _TeamResultCard({
    required this.teamLabel,
    required this.color,
    required this.members,
    required this.targetSize,
    required this.initialsOf,
  });

  final String teamLabel;
  final Color color;
  final List<String> members;
  final int targetSize;
  final String Function(String) initialsOf;

  @override
  Widget build(BuildContext context) {
    final emptySlots = (targetSize - members.length).clamp(0, targetSize);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.32), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  teamLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                '${members.length}/$targetSize orang',
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(members.length, (idx) {
            final name = members[idx];
            final isCurrentUser = name.contains('(Kamu)');

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: color,
                    child: Text(
                      initialsOf(name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      '${idx + 1}. $name',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 14,
                        fontWeight:
                            isCurrentUser ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isCurrentUser)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'KAMU',
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
          if (emptySlots > 0)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '+ $emptySlots slot kosong tersisa',
                style: const TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReservePlayersCard extends StatelessWidget {
  const _ReservePlayersCard({
    required this.reserves,
    required this.initialsOf,
  });

  final List<String> reserves;
  final String Function(String) initialsOf;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.mutedText.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cadangan / Rotasi Berikutnya',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${reserves.length} orang',
                style: const TextStyle(
                  color: AppColors.mutedText,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: reserves.map((name) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.mutedText.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: AppColors.mutedText.withValues(
                        alpha: 0.2,
                      ),
                      child: Text(
                        initialsOf(name),
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
