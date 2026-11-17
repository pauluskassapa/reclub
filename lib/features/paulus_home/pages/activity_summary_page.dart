import 'package:flutter/material.dart';

import '../models/activity.dart';

class ActivitySummaryPage extends StatelessWidget {
  const ActivitySummaryPage({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(activity.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              activity.imagePath,
              height: 210,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            activity.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ListTile(
            leading: const Icon(Icons.sports),
            title: Text(activity.category),
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(activity.location),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: Text(activity.schedule),
          ),
          if (activity.capacity > 0)
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: Text(
                '${activity.participants} dari ${activity.capacity} peserta',
              ),
            ),
          const SizedBox(height: 12),
          const Text(
            'Informasi kegiatan. Pendaftaran untuk kegiatan ini belum tersedia.',
          ),
        ],
      ),
    );
  }
}
