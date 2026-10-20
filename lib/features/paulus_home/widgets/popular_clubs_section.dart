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
  });

  final String searchQuery;
  final String selectedCategory;
  final String? selectedLocation;
  final double radiusKm;

  @override
  Widget build(BuildContext context) {
    const clubs = [
      _ClubCard(
        name: 'Jakarta Futsal Club',
        category: 'Sepak bola',
        sport: 'Sepak bola · 128 anggota',
        imagePath: 'assets/images/futsal.jpg',
        latitude: -6.2615,
        longitude: 106.8106,
      ),
      _ClubCard(
        name: 'Badminton Weekend',
        category: 'Badminton',
        sport: 'Badminton · 86 anggota',
        imagePath: 'assets/images/badminton.jpg',
        latitude: -6.1865,
        longitude: 106.8342,
      ),
      _ClubCard(
        name: 'Basket Sore Jakarta',
        category: 'Basket',
        sport: 'Basket · 64 anggota',
        imagePath: 'assets/images/basket.jpg',
        latitude: -6.244,
        longitude: 106.800,
      ),
      _ClubCard(
        name: 'Jakarta Morning Runners',
        category: 'Lari',
        sport: 'Lari · 92 anggota',
        imagePath: 'assets/images/home_hero.jpg',
        latitude: -6.218,
        longitude: 106.802,
      ),
      _ClubCard(
        name: 'Voli Seru Jakarta Barat',
        category: 'Voli',
        sport: 'Voli · 48 anggota',
        imagePath: 'assets/images/futsal.jpg',
        latitude: -6.168,
        longitude: 106.758,
      ),
      _ClubCard(
        name: 'Jaksel Tennis Crew',
        category: 'Tenis',
        sport: 'Tenis · 35 anggota',
        imagePath: 'assets/images/home_hero.jpg',
        latitude: -6.275,
        longitude: 106.817,
      ),
      _ClubCard(
        name: 'Gowes Bareng Timur',
        category: 'Sepeda',
        sport: 'Sepeda · 57 anggota',
        imagePath: 'assets/images/home_hero.jpg',
        latitude: -6.219,
        longitude: 106.900,
      ),
      _ClubCard(
        name: 'Swim Buddies Jakarta',
        category: 'Renang',
        sport: 'Renang · 41 anggota',
        imagePath: 'assets/images/badminton.jpg',
        latitude: -6.128,
        longitude: 106.856,
      ),
      _ClubCard(
        name: 'Yoga Pagi Pusat',
        category: 'Yoga',
        sport: 'Yoga · 62 anggota',
        imagePath: 'assets/images/home_hero.jpg',
        latitude: -6.1865,
        longitude: 106.8342,
      ),
      _ClubCard(
        name: 'Pingpong Fun Club',
        category: 'Pingpong',
        sport: 'Pingpong · 29 anggota',
        imagePath: 'assets/images/basket.jpg',
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
    required this.category,
    required this.sport,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String category;
  final String sport;
  final String imagePath;
  final double latitude;
  final double longitude;

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
