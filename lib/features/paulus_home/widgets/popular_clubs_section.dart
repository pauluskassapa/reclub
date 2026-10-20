import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PopularClubsSection extends StatelessWidget {
  const PopularClubsSection({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    const clubs = [
      _ClubCard(
        name: 'Jakarta Futsal Club',
        sport: 'Sepak bola · 128 anggota',
      ),
      _ClubCard(
        name: 'Badminton Weekend',
        sport: 'Badminton · 86 anggota',
      ),
    ];

    final query = searchQuery.trim().toLowerCase();
    final filteredClubs = clubs.where((club) {
      return '${club.name} ${club.sport}'.toLowerCase().contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Text(
            'Klub populer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        if (filteredClubs.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Text(
              'Klub tidak ditemukan.',
              style: TextStyle(color: AppColors.mutedText),
            ),
          )
        else
          ...filteredClubs,
      ],
    );
  }
}

class _ClubCard extends StatelessWidget {
  const _ClubCard({required this.name, required this.sport});

  final String name;
  final String sport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        color: AppColors.surface,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: AppColors.accent,
            child: Icon(Icons.groups, color: AppColors.text),
          ),
          title: Text(name),
          subtitle: Text(sport),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
