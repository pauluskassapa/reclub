import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../paulus_home/home_page.dart';

class ReclubSplashScreen extends StatefulWidget {
  const ReclubSplashScreen({super.key});

  @override
  State<ReclubSplashScreen> createState() => _ReclubSplashScreenState();
}

class _ReclubSplashScreenState extends State<ReclubSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleUp;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scaleUp = Tween<double>(
      begin: 0.72,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
    _navigationTimer = Timer(const Duration(milliseconds: 2100), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<void>(
          pageBuilder: (_, _, _) => const HomePage(),
          transitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (_, animation, _, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: ScaleTransition(
            scale: _scaleUp,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final pulse =
                        1 + 0.035 * math.sin(_controller.value * math.pi);
                    return Transform.scale(scale: pulse, child: child);
                  },
                  child: Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(34),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 28,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.sports_soccer_rounded,
                      color: Colors.white,
                      size: 62,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'RECLUB',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'TEMUKAN TEMAN. MAIN BARENG.',
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 34),
                const SizedBox(
                  width: 92,
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    color: AppColors.primary,
                    backgroundColor: Color(0xFFDDE7E3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
