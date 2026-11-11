import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../data/nearby_locations.dart';

class PopularClubsSection extends StatelessWidget {
  const PopularClubsSection({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.selectedLocation,
    required this.radiusKm,
    required this.onClearFilters,
  });

  final String searchQuery;
  final String selectedCategory;
  final String? selectedLocation;
  final double radiusKm;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    const clubs = [
      _ClubCard(
        name: 'Jakarta Futsal Club',
        category: 'Sepak bola',
        sport: 'Sepak bola · 128 anggota',
        latitude: -6.2615,
        longitude: 106.8106,
      ),
      _ClubCard(
        name: 'Badminton Weekend',
        category: 'Badminton',
        sport: 'Badminton · 86 anggota',
        latitude: -6.1865,
        longitude: 106.8342,
      ),
      _ClubCard(
        name: 'Basket Sore Jakarta',
        category: 'Basket',
        sport: 'Basket · 64 anggota',
        latitude: -6.244,
        longitude: 106.800,
      ),
      _ClubCard(
        name: 'Jakarta Morning Runners',
        category: 'Lari',
        sport: 'Lari · 92 anggota',
        latitude: -6.218,
        longitude: 106.802,
      ),
      _ClubCard(
        name: 'Voli Seru Jakarta Barat',
        category: 'Voli',
        sport: 'Voli · 48 anggota',
        latitude: -6.168,
        longitude: 106.758,
      ),
      _ClubCard(
        name: 'Jaksel Tennis Crew',
        category: 'Tenis',
        sport: 'Tenis · 35 anggota',
        latitude: -6.275,
        longitude: 106.817,
      ),
      _ClubCard(
        name: 'Gowes Bareng Timur',
        category: 'Sepeda',
        sport: 'Sepeda · 57 anggota',
        latitude: -6.219,
        longitude: 106.900,
      ),
      _ClubCard(
        name: 'Swim Buddies Jakarta',
        category: 'Renang',
        sport: 'Renang · 41 anggota',
        latitude: -6.128,
        longitude: 106.856,
      ),
      _ClubCard(
        name: 'Yoga Pagi Pusat',
        category: 'Yoga',
        sport: 'Yoga · 62 anggota',
        latitude: -6.1865,
        longitude: 106.8342,
      ),
      _ClubCard(
        name: 'Pingpong Fun Club',
        category: 'Pingpong',
        sport: 'Pingpong · 29 anggota',
        latitude: -6.251,
        longitude: 106.823,
      ),
    ];

    final query = searchQuery.trim().toLowerCase();
    NearbyLocation? location;
    for (final item in nearbyLocations) {
      if (item.name == selectedLocation) {
        location = item;
        break;
      }
    }
    final filteredClubs = clubs.where((club) {
      final matchesCategory =
          selectedCategory == 'Semua' ||
          club.category.toLowerCase() == selectedCategory.toLowerCase();
      final matchesLocation =
          location == null ||
          distanceInKm(
                fromLatitude: location.latitude,
                fromLongitude: location.longitude,
                toLatitude: club.latitude,
                toLongitude: club.longitude,
              ) <=
              radiusKm;
      return matchesCategory &&
          matchesLocation &&
          '${club.name} ${club.sport}'.toLowerCase().contains(query);
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  const Text(
                    'Klub tidak ditemukan',
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Coba ubah olahraga, daerah, atau kata kunci.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.mutedText),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: onClearFilters,
                    icon: const Icon(Icons.filter_alt_off_outlined),
                    label: const Text('Hapus semua filter'),
                  ),
                ],
              ),
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
    required this.category,
    required this.sport,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String category;
  final String sport;
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Card(
        color: AppColors.surface,
        child: ListTile(
          leading: _ClubLogo(category: category, name: name),
          title: Text(name),
          subtitle: Text(sport),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

class _ClubLogo extends StatelessWidget {
  const _ClubLogo({required this.category, required this.name});

  final String category;
  final String name;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (category) {
      'Sepak bola' => (const Color(0xFF146B4A), Icons.sports_soccer_rounded),
      'Badminton' => (const Color(0xFF6847C7), Icons.sports_tennis_rounded),
      'Basket' => (const Color(0xFFDB6B22), Icons.sports_basketball_rounded),
      'Lari' => (const Color(0xFF087F8C), Icons.directions_run_rounded),
      'Voli' => (const Color(0xFF2455A6), Icons.sports_volleyball_rounded),
      'Tenis' => (const Color(0xFF638C27), Icons.sports_tennis_rounded),
      'Sepeda' => (const Color(0xFFB24C19), Icons.directions_bike_rounded),
      'Renang' => (const Color(0xFF087DAB), Icons.pool_rounded),
      'Yoga' => (const Color(0xFFAC3978), Icons.self_improvement_rounded),
      'Pingpong' => (const Color(0xFF62552B), Icons.sports_tennis_rounded),
      _ => (const Color(0xFF43556E), Icons.groups_rounded),
    };
    final initials = name
        .split(' ')
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0])
        .join()
        .toUpperCase();

    return Semantics(
      image: true,
      label: 'Logo $name',
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, Color.lerp(color, Colors.black, 0.38)!],
          ),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 4,
              right: 5,
              child: Icon(
                icon,
                size: 19,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 21, color: Colors.white),
                Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
