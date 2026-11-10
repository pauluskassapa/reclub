import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../paulus_home/models/activity.dart';
import 'widgets/Position.dart';
import 'widgets/detail_activity_info.dart';
import 'widgets/ai_chatbot.dart';
import 'widgets/detail_category_chips.dart';
import 'widgets/detail_image_header.dart';
import 'widgets/detail_join_button.dart';
import 'widgets/detail_participant_list.dart';

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

  _SportDetailConfig get _config {
    final isBasket = widget.activity?.category.toLowerCase() == 'basket' ||
        widget.activity?.title == 'Basket Sore';
    return isBasket
        ? _SportDetailConfig.basket()
        : _SportDetailConfig.futsal();
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
            const DetailAiChatbotCard(),
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
