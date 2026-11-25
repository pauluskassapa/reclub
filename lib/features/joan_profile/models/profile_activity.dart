import 'package:flutter/material.dart';

class ProfileActivity {
  const ProfileActivity({
    required this.title,
    required this.location,
    required this.date,
    required this.sport,
    required this.icon,
  });

  final String title;
  final String location;
  final DateTime date;
  final String sport;
  final IconData icon;

  bool get isUpcoming {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final activityDay = DateTime(date.year, date.month, date.day);
    return !activityDay.isBefore(today);
  }

  String get formattedDate {
    const weekdays = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${weekdays[date.weekday - 1]}, ${date.day} '
        '${months[date.month - 1]} ${date.year}';
  }
}
