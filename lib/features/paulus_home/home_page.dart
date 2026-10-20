import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'models/activity.dart';
import 'widgets/activity_time_filter.dart';
import 'widgets/category_filter.dart';
import 'widgets/featured_section.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/popular_clubs_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Semua';
  ActivityTimeGroup? _selectedTime;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          children: [
            const HomeHeader(),
            HomeSearchBar(
              controller: _searchController,
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
            CategoryFilter(
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
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
            FeaturedSection(
              searchQuery: _searchQuery,
              selectedCategory: _selectedCategory,
              selectedTime: _selectedTime,
            ),
            PopularClubsSection(searchQuery: _searchQuery),
          ],
        ),
      ),
    );
  }
}
