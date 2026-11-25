import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_colors.dart';
import 'features/daniel_detail/services/supabase_community_service.dart';
import 'features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseCommunityService.supabaseUrl,
    publishableKey: SupabaseCommunityService.supabasePublishableKey,
  );
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
