import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/category_filter.dart';
import 'widgets/activity_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          children: const [
            HomeHeader(),
            HomeSearchBar(),
            CategoryFilter(),
            const ActivityCard(
            title: 'Fun Futsal Bareng',
            category: 'Sepak bola',
            location: 'Jakarta Selatan',
            schedule: 'Minggu, 08.00',
            ),
          ],
        ),
      ),
    );
  }
}
