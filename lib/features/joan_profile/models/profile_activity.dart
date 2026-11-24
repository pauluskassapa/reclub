import 'package:flutter/material.dart';

class ProfileActivity {
  const ProfileActivity({
    required this.title,
    required this.location,
    required this.date,
    required this.sport,
    required this.icon,
    required this.upcoming,
  });

  final String title;
  final String location;
  final String date;
  final String sport;
  final IconData icon;
  final bool upcoming;
}
