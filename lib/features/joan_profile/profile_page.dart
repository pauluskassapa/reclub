import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'models/profile_activity.dart';
import 'widgets/activity_history_card.dart';
import 'widgets/profile_edit_dialog.dart';
import 'widgets/profile_edit_menu.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_tabs.dart';

class JoanProfilePage extends StatefulWidget {
  const JoanProfilePage({super.key});

  @override
  State<JoanProfilePage> createState() => _JoanProfilePageState();
}

class _JoanProfilePageState extends State<JoanProfilePage> {
  String _name = 'Joan Pratama';
  String _bio = 'Pecinta olahraga dan kenalan baru';
  int _selectedTab = 0;

  static final _activities = [
    ProfileActivity(
      title: 'Futsal Santai Minggu Pagi',
      location: 'Lapangan Rawa Badak',
      date: DateTime.now().add(const Duration(days: 11)),
      sport: 'Futsal',
      icon: Icons.sports_soccer_rounded,
    ),
    ProfileActivity(
      title: 'Badminton Bareng',
      location: 'GOR Sunter',
      date: DateTime.now().add(const Duration(days: 17)),
      sport: 'Badminton',
      icon: Icons.sports_tennis_rounded,
    ),
    ProfileActivity(
      title: 'Basket 3x3',
      location: 'Taman Impian Jaya Ancol',
      date: DateTime.now().subtract(const Duration(days: 31)),
      sport: 'Basket',
      icon: Icons.sports_basketball_rounded,
    ),
  ];

  int get _upcomingActivityCount =>
      _activities.where((activity) => activity.isUpcoming).length;

  int get _completedActivityCount =>
      _activities.where((activity) => !activity.isUpcoming).length;

  int get _sportCount =>
      _activities.map((activity) => activity.sport).toSet().length;

  Future<void> _editProfile() async {
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (_) => ProfileEditDialog(name: _name, bio: _bio),
    );
    if (result != null && result.$1.isNotEmpty && mounted) {
      setState(() {
        _name = result.$1;
        _bio = result.$2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final showingUpcoming = _selectedTab == 0;
    final activities = showingUpcoming
        ? _activities.where((activity) => activity.isUpcoming).toList()
        : _activities.where((activity) => !activity.isUpcoming).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          ProfileInfoCard(
            name: _name,
            bio: _bio,
            upcomingCount: _upcomingActivityCount,
            completedCount: _completedActivityCount,
            sportCount: _sportCount,
          ),
          const SizedBox(height: 16),
          ProfileEditMenu(onEdit: _editProfile),
          const SizedBox(height: 26),
          ProfileTabs(
            selectedIndex: _selectedTab,
            onSelected: (index) => setState(() => _selectedTab = index),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              showingUpcoming
                  ? 'Kegiatan mendatang'
                  : 'Kegiatan yang sudah diikuti',
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (activities.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Icon(
                    Icons.event_note_rounded,
                    size: 40,
                    color: AppColors.mutedText,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Belum ada riwayat kegiatan.',
                    style: TextStyle(color: AppColors.mutedText),
                  ),
                ],
              ),
            )
          else
            for (final activity in activities)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ActivityHistoryCard(activity: activity),
              ),
        ],
      ),
    );
  }
}
