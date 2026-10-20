import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PopularClubsSection extends StatelessWidget {
  const PopularClubsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Text(
            'Klub populer',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        _ClubCard(
          name: 'Jakarta Futsal Club',
          sport: 'Sepak bola · 128 anggota',
        ),
        _ClubCard(
          name: 'Badminton Weekend',
          sport: 'Badminton · 86 anggota',
        ),
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