import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reclub/features/paulus_home/data/sample_activities.dart';
import 'package:reclub/features/paulus_home/pages/activity_summary_page.dart';
import 'package:reclub/features/paulus_home/widgets/activity_card.dart';
import 'package:reclub/features/paulus_home/widgets/popular_clubs_section.dart';

void main() {
  testWidgets('Badminton opens its own summary instead of futsal details', (
    tester,
  ) async {
    final activity = sampleActivities.firstWhere(
      (a) => a.category == 'Badminton',
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ActivityCard(activity: activity)),
      ),
    );
    await tester.tap(find.text(activity.title));
    await tester.pumpAndSettle();
    expect(find.byType(ActivitySummaryPage), findsOneWidget);
    expect(find.text(activity.location), findsOneWidget);
  });

  testWidgets('Club opens information and selects its sport', (tester) async {
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PopularClubsSection(
              searchQuery: '',
              selectedCategory: 'Badminton',
              selectedLocation: null,
              radiusKm: 20,
              onClearFilters: () {},
              onSportSelected: (value) => selected = value,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Badminton Weekend'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cari kegiatan Badminton'));
    await tester.pumpAndSettle();
    expect(selected, 'Badminton');
  });
}
