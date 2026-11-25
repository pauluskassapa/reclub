import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../paulus_home/models/activity.dart';
import 'widgets/detail_position_selector.dart';
import 'widgets/detail_activity_info.dart';
import 'widgets/detail_category_chips.dart';
import 'widgets/detail_community_chat.dart';
import 'widgets/detail_image_header.dart';
import 'widgets/detail_join_button.dart';
import 'widgets/detail_participant_list.dart';
import 'widgets/teamGenerator.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    this.activity,
  });

  final Activity? activity;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<FutsalParticipant>? _participantsList;

  bool _isFavorite = false;
  bool _isJoined = false;
  String _selectedRole = 'All-Rounder';

  _SportDetailConfig get _config {
    final activity = widget.activity;
    if (activity == null || activity.title == 'Fun Futsal Bareng') {
      return _SportDetailConfig.futsal();
    }
    if (activity.title == 'Basket Sore') {
      return _SportDetailConfig.basket();
    }

    final roles = DetailPositionSelectorSheet.rolesForCategory(
      activity.category,
    );
    final preset = _presetForCategory(activity.category);

    return _SportDetailConfig(
      title: activity.title,
      clubName: 'Komunitas ${activity.category} Reclub',
      imagePath: activity.imagePath,
      category: activity.category,
      sportIcon: _iconForCategory(activity.category),
      timeGroup: activity.timeGroup == ActivityTimeGroup.weekend
          ? 'Weekend'
          : 'Weekday',
      skillLevel: 'Semua Level',
      courtType: preset.courtType,
      schedule: '${activity.schedule} WIB',
      location: activity.location,
      venueAddress: activity.location,
      fee: preset.fee,
      feeNote: preset.feeNote,
      quotaTitle: 'Kuota Peserta ${activity.category}',
      joinLabel: 'Ikut ${activity.category}',
      capacity: activity.capacity > 0 ? activity.capacity : preset.capacity,
      description: preset.description,
      initialParticipants: _initialParticipantsForCategory(
        activity.category,
        roles,
        targetCount: activity.participants,
      ),
      roles: roles,
    );
  }

  _SportCategoryPreset _presetForCategory(String category) {
    return switch (category.trim().toLowerCase()) {
      'sepak bola' || 'futsal' => const _SportCategoryPreset(
        courtType: 'Lapangan Vinyl Indoor',
        fee: 'Rp45.000 / orang',
        feeNote: 'Termasuk sewa lapangan, bola & rompi',
        capacity: 12,
        description:
            'Sesi fun futsal & sepak bola terbuka untuk semua level pemain. '
            'Rotasi tim dilakukan secara berkala agar semua peserta mendapat '
            'waktu bermain yang adil.',
      ),
      'basket' => const _SportCategoryPreset(
        courtType: 'Lapangan Basket Indoor / Outdoor',
        fee: 'Rp50.000 / orang',
        feeNote: 'Termasuk sewa lapangan, bola & rompi',
        capacity: 12,
        description:
            'Sesi pick-up game basket seru untuk semua level! Sistem rotasi '
            'per game agar semua pemain bisa tampil maksimal dan tetap fun.',
      ),
      'badminton' || 'bulutangkis' => const _SportCategoryPreset(
        courtType: 'Lapangan Karpet Indoor',
        fee: 'Rp35.000 / orang',
        feeNote: 'Termasuk sewa lapangan & shuttlecock patungan',
        capacity: 8,
        description:
            'Sesi mabar badminton santai hingga kompetitif untuk semua level. '
            'Pasangan main bisa dirotasi setiap set agar semua peserta saling '
            'bertemu di lapangan.',
      ),
      'voli' || 'volleyball' => const _SportCategoryPreset(
        courtType: 'Lapangan Voli Indoor',
        fee: 'Rp30.000 / orang',
        feeNote: 'Termasuk sewa lapangan & bola voli',
        capacity: 12,
        description:
            'Sesi latihan dan fun match voli bareng komunitas! Terbuka untuk '
            'pemula maupun pemain berpengalaman dengan rotasi posisi yang rapi.',
      ),
      'tenis' || 'tennis' => const _SportCategoryPreset(
        courtType: 'Hard Court Outdoor',
        fee: 'Rp65.000 / orang',
        feeNote: 'Termasuk sewa lapangan & bola tenis',
        capacity: 6,
        description:
            'Sesi sparring dan rallying tenis santai bareng komunitas. '
            'Bawa raket pribadi dan siap bermain single maupun double.',
      ),
      'pingpong' || 'tenis meja' => const _SportCategoryPreset(
        courtType: 'Meja Indoor Standar ITTF',
        fee: 'Rp25.000 / orang',
        feeNote: 'Termasuk sewa meja & bola pingpong',
        capacity: 8,
        description:
            'Sesi fun match pingpong dengan format rotasi cepat single dan '
            'double. Cocok untuk mengasah refleks dan bersantai sepulang kerja.',
      ),
      'lari' || 'running' => const _SportCategoryPreset(
        courtType: 'Lintasan Outdoor / Taman Kota',
        fee: 'Gratis',
        feeNote: 'Bawa botol minum & sepatu lari nyaman',
        capacity: 15,
        description:
            'Sesi lari bareng komunitas dengan pembagian kelompok pace dari '
            'pemula hingga pelari cepat. Dilengkapi pemanasan dan pendinginan '
            'bersama.',
      ),
      'sepeda' || 'gowes' || 'cycling' => const _SportCategoryPreset(
        courtType: 'Rute Jalan Kota / Car Free Day',
        fee: 'Gratis',
        feeNote: 'Wajib helm, lampu sepeda & botol minum',
        capacity: 15,
        description:
            'Gowes bareng keliling kota dengan rute ramah semua jenis sepeda. '
            'Dipandu Road Captain dan Sweeper agar rombongan tetap aman.',
      ),
      'renang' || 'swimming' => const _SportCategoryPreset(
        courtType: 'Kolam Renang Standar 50m',
        fee: 'Rp40.000 / orang',
        feeNote: 'Tiket masuk kolam renang',
        capacity: 8,
        description:
            'Sesi latihan renang pagi bareng untuk memperbaiki teknik napas, '
            'stamina, dan gaya renang favoritmu bersama teman sekomunitas.',
      ),
      'yoga' => const _SportCategoryPreset(
        courtType: 'Area Taman / Studio Matras',
        fee: 'Rp35.000 / orang',
        feeNote: 'Disarankan membawa matras yoga pribadi',
        capacity: 10,
        description:
            'Sesi yoga untuk peregangan, kelenturan tubuh, dan relaksasi '
            'pikiran. Cocok untuk pemula maupun praktisi rutin.',
      ),
      _ => _SportCategoryPreset(
        courtType: 'Area $category',
        fee: 'Gratis / Patungan',
        feeNote: 'Info biaya dikonfirmasi di ruang chat komunitas',
        capacity: 12,
        description:
            'Sesi $category bareng komunitas RECLUB. Terbuka untuk semua '
            'level peserta yang ingin berolahraga dan menambah relasi baru.',
      ),
    };
  }

  List<FutsalParticipant> _initialParticipantsForCategory(
    String category,
    List<FutsalRoleOption> roles, {
    required int targetCount,
  }) {
    String roleFor(int index) {
      if (roles.isEmpty) return index == 0 ? 'Host' : 'Peserta';
      return roles[index % roles.length].name;
    }

    if (targetCount <= 0) {
      return [
        FutsalParticipant(
          name: 'Host Komunitas',
          position: roleFor(0),
          isHost: true,
        ),
      ];
    }

    const sampleNames = [
      'Paulus Kassapa',
      'Defrigo Pratama',
      'Alex Wijaya',
      'Joan Natasya',
      'Rizky Ramadhan',
      'Bagas Saputra',
      'Kevin Sanjaya',
      'Dimas Aditya',
      'Nadia Putri',
      'Fajar Pratama',
    ];

    final count = targetCount.clamp(1, sampleNames.length);
    return List<FutsalParticipant>.generate(count, (index) {
      return FutsalParticipant(
        name: sampleNames[index],
        position: roleFor(index),
        isHost: index == 0,
      );
    });
  }

  IconData _iconForCategory(String category) {
    return switch (category.toLowerCase()) {
      'sepak bola' || 'futsal' => Icons.sports_soccer_rounded,
      'basket' => Icons.sports_basketball_rounded,
      'voli' => Icons.sports_volleyball_rounded,
      'badminton' || 'tenis' || 'pingpong' => Icons.sports_tennis_rounded,
      'lari' => Icons.directions_run_rounded,
      'sepeda' => Icons.directions_bike_rounded,
      'renang' => Icons.pool_rounded,
      'yoga' => Icons.self_improvement_rounded,
      _ => Icons.sports_rounded,
    };
  }

  List<FutsalParticipant> get _participants =>
      _participantsList ??= List<FutsalParticipant>.from(
        _config.initialParticipants,
      );

  Future<void> _toggleJoinActivity() async {
    if (_isJoined) {
      setState(() {
        _participants.removeWhere((p) => p.name == 'Daniel (Kamu)');
        _isJoined = false;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Keikutsertaan ${_config.title} dibatalkan.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    if (_participants.length >= _config.capacity) return;

    if (_config.roles.isEmpty) {
      setState(() {
        _participants.add(
          const FutsalParticipant(
            name: 'Daniel (Kamu)',
            position: 'Peserta',
          ),
        );
        _selectedRole = 'Peserta';
        _isJoined = true;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Kamu bergabung ke ${_config.title}!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    final selectedPosition = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DetailPositionSelectorSheet(
        participants: _participants,
        roleOptions: _config.roles,
        activityTitle: _config.title,
        headerIcon: _config.sportIcon,
      ),
    );

    if (selectedPosition == null || !mounted) return;

    setState(() {
      _participants.add(
        FutsalParticipant(
          name: 'Daniel (Kamu)',
          position: selectedPosition,
        ),
      );
      _selectedRole = selectedPosition;
      _isJoined = true;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Kamu bergabung ke ${_config.title} sebagai $selectedPosition!',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;
    final participants = _participants;
    final bool isBasket = config.category.toLowerCase() == 'basket';
    final int remainingSlots =
        (config.capacity - participants.length).clamp(0, config.capacity);

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: DetailJoinButton(
        fee: config.fee,
        isJoined: _isJoined,
        isFull: remainingSlots <= 0,
        joinLabel: config.joinLabel,
        joinIcon: config.sportIcon,
        onPressed: _toggleJoinActivity,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            DetailImageHeader(
              imagePath: config.imagePath,
              title: config.title,
              clubName: config.clubName,
              remainingSlots: remainingSlots,
              isFavorite: _isFavorite,
              onBackTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              onFavoriteTap: () {
                setState(() => _isFavorite = !_isFavorite);
              },
            ),
            DetailCategoryChips(
              category: config.category,
              categoryIcon: config.sportIcon,
              timeGroup: config.timeGroup,
              skillLevel: config.skillLevel,
              courtType: config.courtType,
            ),
            DetailActivityInfo(
              schedule: config.schedule,
              location: config.location,
              venueAddress: config.venueAddress,
              fee: config.fee,
              feeNote: config.feeNote,
              quotaTitle: config.quotaTitle,
              participantCount: participants.length,
              capacity: config.capacity,
              description: config.description,
            ),
            if (isBasket)
              TeamGenerator(
                participantNames:
                    participants.map((player) => player.name).toList(),
                defaultTeamCount: 2,
                defaultPlayersPerTeam: 5,
              ),
            DetailCommunityChatCard(
              activityTitle: config.title,
              clubName: config.clubName,
              currentUserRole: _selectedRole,
              isJoined: _isJoined,
            ),
            DetailParticipantList(
              participants: participants,
              capacity: config.capacity,
            ),
          ],
        ),
      ),
    );
  }
}

class _SportDetailConfig {
  const _SportDetailConfig({
    required this.title,
    required this.clubName,
    required this.imagePath,
    required this.category,
    required this.sportIcon,
    required this.timeGroup,
    required this.skillLevel,
    required this.courtType,
    required this.schedule,
    required this.location,
    required this.venueAddress,
    required this.fee,
    required this.feeNote,
    required this.quotaTitle,
    required this.joinLabel,
    required this.capacity,
    required this.description,
    required this.initialParticipants,
    required this.roles,
  });

  final String title;
  final String clubName;
  final String imagePath;
  final String category;
  final IconData sportIcon;
  final String timeGroup;
  final String skillLevel;
  final String courtType;
  final String schedule;
  final String location;
  final String venueAddress;
  final String fee;
  final String feeNote;
  final String quotaTitle;
  final String joinLabel;
  final int capacity;
  final String description;
  final List<FutsalParticipant> initialParticipants;
  final List<FutsalRoleOption> roles;

  factory _SportDetailConfig.futsal() {
    return const _SportDetailConfig(
      title: 'Fun Futsal Bareng',
      clubName: 'Jakarta Futsal Club',
      imagePath: 'assets/images/futsal.jpg',
      category: 'Sepak bola',
      sportIcon: Icons.sports_soccer_rounded,
      timeGroup: 'Weekend',
      skillLevel: 'Semua Level',
      courtType: 'Lapangan Vinyl Indoor',
      schedule: 'Minggu, 08.00 - 10.00 WIB',
      location: 'Jakarta Selatan',
      venueAddress: 'Cilandak Sport Center, Jl. TB Simatupang No. 45',
      fee: 'Rp45.000 / orang',
      feeNote: 'Termasuk sewa lapangan, bola & rompi',
      quotaTitle: 'Kuota Pemain Futsal',
      joinLabel: 'Ikut Futsal',
      capacity: 12,
      description:
          'Sesi fun futsal rutin akhir pekan bersama Jakarta Futsal Club! '
          'Terbuka untuk semua level pemain. Sistem rotasi tim setiap '
          '10 menit agar semua peserta mendapat waktu bermain yang adil. '
          'Bola, rompi tim, dan air mineral sudah disediakan.',
      roles: DetailPositionSelectorSheet.futsalRoles,
      initialParticipants: [
        FutsalParticipant(
          name: 'Paulus Kassapa',
          position: 'Pivot',
          isHost: true,
        ),
        FutsalParticipant(name: 'Defrigo Pratama', position: 'Anchor'),
        FutsalParticipant(name: 'Alex Wijaya', position: 'Flank Kanan'),
        FutsalParticipant(name: 'Joan Natasya', position: 'Flank Kiri'),
        FutsalParticipant(name: 'Rizky Ramadhan', position: 'Kiper'),
        FutsalParticipant(name: 'Bagas Saputra', position: 'Anchor'),
        FutsalParticipant(name: 'Kevin Sanjaya', position: 'Flank Kanan'),
        FutsalParticipant(name: 'Dimas Aditya', position: 'Pivot'),
      ],
    );
  }

  factory _SportDetailConfig.basket() {
    return const _SportDetailConfig(
      title: 'Basket Sore',
      clubName: 'South Jakarta Hoops Club',
      imagePath: 'assets/images/basket.jpg',
      category: 'Basket',
      sportIcon: Icons.sports_basketball_rounded,
      timeGroup: 'Weekday',
      skillLevel: 'Semua Level',
      courtType: 'Lapangan Kayu Indoor (Full Court)',
      schedule: 'Jumat, 17.00 - 19.00 WIB',
      location: 'Jakarta Selatan',
      venueAddress: 'GOR Bulungan Blok M, Jl. Bulungan No. 1, Kebayoran Baru',
      fee: 'Rp50.000 / orang',
      feeNote: 'Termasuk sewa lapangan kayu indoor, bola & rompi',
      quotaTitle: 'Kuota Pemain Basket',
      joinLabel: 'Ikut Basket',
      capacity: 12,
      description:
          'Sesi pick-up game 5v5 Basket Sore bareng South Jakarta Hoops Club! '
          'Cocok untuk melepas penat sepulang kuliah atau kerja. Menggunakan '
          'sistem game 12 menit per sesi agar semua tim kebagian main. '
          'Bola Molten GG7X, rompi tim, dan air mineral sudah disediakan.',
      roles: DetailPositionSelectorSheet.basketRoles,
      initialParticipants: [
        FutsalParticipant(
          name: 'Paulus Kassapa',
          position: 'Point Guard (PG)',
          isHost: true,
        ),
        FutsalParticipant(
          name: 'Defrigo Pratama',
          position: 'Center (C)',
        ),
        FutsalParticipant(
          name: 'Alex Wijaya',
          position: 'Shooting Guard (SG)',
        ),
        FutsalParticipant(
          name: 'Joan Natasya',
          position: 'Small Forward (SF)',
        ),
        FutsalParticipant(
          name: 'Brandon Jawato',
          position: 'Power Forward (PF)',
        ),
        FutsalParticipant(
          name: 'Andakara Prastawa',
          position: 'Point Guard (PG)',
        ),
        FutsalParticipant(
          name: 'Abraham Damar',
          position: 'Shooting Guard (SG)',
        ),
        FutsalParticipant(
          name: 'Vincent Kosasih',
          position: 'Center (C)',
        ),
        FutsalParticipant(
          name: 'Arki Wisnu',
          position: 'Small Forward (SF)',
        ),
        FutsalParticipant(
          name: 'Kaleb Ramot',
          position: 'Power Forward (PF)',
        ),
      ],
    );
  }
}

class _SportCategoryPreset {
  const _SportCategoryPreset({
    required this.courtType,
    required this.fee,
    required this.feeNote,
    required this.capacity,
    required this.description,
  });

  final String courtType;
  final String fee;
  final String feeNote;
  final int capacity;
  final String description;
}
