import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const ReclubApp());
}

class ReclubApp extends StatelessWidget {
  const ReclubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RECLUB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Rajdhani',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: const ReclubSplashScreen(),
    );
  }
}
