import 'package:flutter/material.dart';

import 'activity_card.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Text(
            'Kegiatan dekat kamu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ActivityCard(
          title: 'Fun Futsal Bareng',
          category: 'Sepak bola',
          location: 'Jakarta Selatan',
          schedule: 'Minggu, 08.00',
        ),
        ActivityCard(
          title: 'Badminton Santai',
          category: 'Badminton',
          location: 'Jakarta Pusat',
          schedule: 'Sabtu, 16.00',
        ),
      ],
    );
  }
}