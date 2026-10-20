import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'widgets/home_header.dart';

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
          ],
        ),
      ),
    );
  }
}
