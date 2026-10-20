import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'models/activity.dart';
import 'widgets/activity_location_filter.dart';
import 'widgets/activity_time_filter.dart';
import 'widgets/featured_section.dart';
import 'widgets/home_bottom_navigation.dart';
import 'widgets/home_header.dart';
import 'widgets/home_promo_card.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/popular_clubs_section.dart';
import 'widgets/sport_shortcut_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  ActivityTimeGroup? _selectedTime;
  String? _selectedLocation;
  double _radiusKm = 20;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: HomeBottomNavigation(
        onDestinationSelected: _onDestinationSelected,
        onSearchPressed: _searchFocusNode.requestFocus,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const HomeHeader(),
            HomePromoCard(onDiscoverTap: _searchFocusNode.requestFocus),
            HomeSearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onClear: () {
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
            SportShortcutSection(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() => _selectedCategory = category);
              },
            ),
            ActivityTimeFilter(
              selectedTime: _selectedTime,
              onTimeSelected: (time) {
                setState(() {
                  _selectedTime = time;
                });
              },
            ),
            ActivityLocationFilter(
              selectedLocation: _selectedLocation,
              radiusKm: _radiusKm,
              onLocationSelected: (location) {
                setState(() {
                  _selectedLocation = location;
                });
              },
              onRadiusChanged: (radius) {
                setState(() => _radiusKm = radius);
              },
            ),
            FeaturedSection(
              searchQuery: _searchQuery,
              selectedCategory: _selectedCategory,
              selectedTime: _selectedTime,
              selectedLocation: _selectedLocation,
              radiusKm: _radiusKm,
            ),
            PopularClubsSection(
              searchQuery: _searchQuery,
              selectedCategory: _selectedCategory,
              selectedLocation: _selectedLocation,
              radiusKm: _radiusKm,
            ),
          ],
        ),
      ),
    );
  }

  void _onDestinationSelected(int index) {
    if (index == 0) return;

    const destinations = ['Home', 'Feed', 'Inbox', 'Menu'];
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Halaman ${destinations[index]} akan dihubungkan setelah fitur tim siap.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
