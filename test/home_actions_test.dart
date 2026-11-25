import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reclub/features/paulus_home/data/sample_activities.dart';
import 'package:reclub/features/daniel_detail/widgets/club/club_detail.dart';
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

  testWidgets('Club opens Daniel club detail page', (tester) async {
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
              onSportSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Badminton Weekend'));
    await tester.pumpAndSettle();
    expect(find.byType(ClubDetailPage), findsOneWidget);
    expect(find.text('Badminton Weekend'), findsWidgets);
  });
}
