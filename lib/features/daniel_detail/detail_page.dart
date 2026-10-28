import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'widgets/detail_activity_info.dart';
import 'widgets/detail_category_chips.dart';
import 'widgets/detail_image_header.dart';
import 'widgets/detail_join_button.dart';
import 'widgets/detail_participant_list.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  static const int _capacity = 12;

  final List<FutsalParticipant> _participants = [
    const FutsalParticipant(
      name: 'Paulus Kassapa',
      position: 'Pivot',
      isHost: true,
    ),
    const FutsalParticipant(name: 'Defrigo Pratama', position: 'Anchor'),
    const FutsalParticipant(name: 'Alex Wijaya', position: 'Flank Kanan'),
    const FutsalParticipant(name: 'Joan Natasya', position: 'Flank Kiri'),
    const FutsalParticipant(name: 'Rizky Ramadhan', position: 'Kiper'),
    const FutsalParticipant(name: 'Bagas Saputra', position: 'Anchor'),
    const FutsalParticipant(name: 'Kevin Sanjaya', position: 'Flank'),
    const FutsalParticipant(name: 'Dimas Aditya', position: 'Pivot'),
  ];

  bool _isFavorite = false;
  bool _isJoined = false;

  void _toggleJoinFutsal() {
    setState(() {
      if (_isJoined) {
        _participants.removeWhere((p) => p.name == 'Daniel (Kamu)');
        _isJoined = false;
      } else if (_participants.length < _capacity) {
        _participants.add(
          const FutsalParticipant(
            name: 'Daniel (Kamu)',
            position: 'All-Rounder',
          ),
        );
        _isJoined = true;
      }
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _isJoined
                ? 'Kamu berhasil bergabung ke Fun Futsal Bareng!'
                : 'Keikutsertaan Fun Futsal Bareng dibatalkan.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final int remainingSlots =
        (_capacity - _participants.length).clamp(0, _capacity);

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: DetailJoinButton(
        fee: 'Rp45.000 / orang',
        isJoined: _isJoined,
        isFull: remainingSlots <= 0,
        onPressed: _toggleJoinFutsal,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            DetailImageHeader(
              imagePath: 'assets/images/futsal.jpg',
              title: 'Fun Futsal Bareng',
              clubName: 'Jakarta Futsal Club',
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
            const DetailCategoryChips(
              category: 'Sepak bola',
              timeGroup: 'Weekend',
              skillLevel: 'Semua Level',
              courtType: 'Lapangan Vinyl Indoor',
            ),
            DetailActivityInfo(
              schedule: 'Minggu, 08.00 - 10.00 WIB',
              location: 'Jakarta Selatan',
              venueAddress: 'Cilandak Sport Center, Jl. TB Simatupang No. 45',
              fee: 'Rp45.000 / orang',
              participantCount: _participants.length,
              capacity: _capacity,
              description:
                  'Sesi fun futsal rutin akhir pekan bersama Jakarta Futsal Club! '
                  'Terbuka untuk semua level pemain. Sistem rotasi tim setiap '
                  '10 menit agar semua peserta mendapat waktu bermain yang adil. '
                  'Bola, rompi tim, dan air mineral sudah disediakan.',
            ),
            DetailParticipantList(
              participants: _participants,
              capacity: _capacity,
            ),
          ],
        ),
      ),
    );
  }
}
