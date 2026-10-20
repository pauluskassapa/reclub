import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECLUB',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Hai, ${userName.trim().isEmpty ? 'Teman' : userName.trim()}',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: AppColors.accent,
                child: Icon(Icons.notifications_none, color: AppColors.text),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Mau olahraga apa hari ini?',
            style: TextStyle(
              color: AppColors.mutedText,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: SizedBox(
              height: 178,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/alexander_volleyball.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.text.withValues(alpha: 0.78),
                          AppColors.text.withValues(alpha: 0.04),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(18),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(
                        width: 240,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dari Priok ke podium nasional',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                height: 1.05,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Alexander juara voli setelah rutin berlatih bersama RECLUB.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                height: 1.15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
