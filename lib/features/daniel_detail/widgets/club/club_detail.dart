import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../models/club.dart';
import 'header.dart';
import 'join_botton.dart';
import 'proflie.dart';
import 'stats_row.dart';

class ClubDetailPage extends StatefulWidget {
  const ClubDetailPage({
    super.key,
    required this.club,
  });

  final Club club;
  factory ClubDetailPage.fromClubName(String clubName, {Key? key}) {
    return ClubDetailPage(
      key: key,
      club: Club.findByName(clubName),
    );
  }

  @override
  State<ClubDetailPage> createState() => _ClubDetailPageState();
}

class _ClubDetailPageState extends State<ClubDetailPage> {
  bool _isBookmarked = false;
  bool _isMember = false;

  void _toggleMembership() {
    setState(() {
      _isMember = !_isMember;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _isMember
                ? 'Selamat datang! Kamu resmi bergabung di ${widget.club.name}.'
                : 'Keanggotaan di ${widget.club.name} telah dibatalkan.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final club = widget.club;
    final currentMembers = club.memberCount + (_isMember ? 1 : 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: ClubJoinBottomBar(
        clubName: club.name,
        isMember: _isMember,
        accentColor: club.accentColor,
        sportIcon: club.sportIcon,
        onToggleMembership: _toggleMembership,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            ClubBannerHeader(
              club: club,
              isBookmarked: _isBookmarked,
              onBackTap: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              },
              onBookmarkTap: () {
                setState(() => _isBookmarked = !_isBookmarked);
              },
            ),
            ClubStatsRow(
              memberCount: currentMembers,
              rating: club.rating,
              weeklySessions: club.weeklySessions,
              accentColor: club.accentColor,
            ),
            ClubProfileSection(club: club),
          ],
        ),
      ),
    );
  }
}