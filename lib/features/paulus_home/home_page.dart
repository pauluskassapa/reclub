import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
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
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          children: [
            const HomeHeader(),
            HomeSearchBar(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
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
            FeaturedSection(
              searchQuery: _searchQuery,
              selectedCategory: _selectedCategory,
            ),
            PopularClubsSection(searchQuery: _searchQuery),
          ],
        ),
      ),
    );
  }
}
