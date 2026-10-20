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
        imagePath: 'assets/images/futsal.jpg',
      ),
      _ClubCard(
        name: 'Badminton Weekend',
        sport: 'Badminton · 86 anggota',
        imagePath: 'assets/images/badminton.jpg',
      ),
      _ClubCard(
        name: 'Basket Sore Jakarta',
        sport: 'Basket · 64 anggota',
        imagePath: 'assets/images/basket.jpg',
      ),
      _ClubCard(
        name: 'Jakarta Morning Runners',
        sport: 'Lari · 92 anggota',
        imagePath: 'assets/images/home_hero.jpg',
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
  const _ClubCard({
    required this.name,
    required this.sport,
    required this.imagePath,
  });

  final String name;
  final String sport;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        color: AppColors.surface,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              semanticLabel: name,
            ),
          ),
          title: Text(name),
          subtitle: Text(sport),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
