import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reclub/features/daniel_detail/detail_page.dart';
import 'package:reclub/features/daniel_detail/widgets/teamGenerator.dart';
import 'package:reclub/features/paulus_home/data/sample_activities.dart';

void main() {
  test('generateTeams distributes players evenly and tracks reserves', () {
    final names = List.generate(10, (i) => 'Pemain ${i + 1}');
    final result = TeamGenerator.generateTeams(
      names: names,
      teamCount: 3,
      playersPerTeam: 3,
      random: Random(42),
    );

    expect(result.teams.length, 3);
    expect(result.teams[0].length, 3);
    expect(result.teams[1].length, 3);
    expect(result.teams[2].length, 3);
    expect(result.reserves.length, 1);

    final allAssigned = [
      ...result.teams.expand((t) => t),
      ...result.reserves,
    ];
    expect(allAssigned.toSet().length, 10);
  });

  testWidgets('Basket DetailPage shows team generator and shuffles by input', (
    tester,
  ) async {
    final basketActivity = sampleActivities.firstWhere(
      (activity) => activity.category == 'Basket',
    );

    await tester.pumpWidget(
      MaterialApp(home: DetailPage(activity: basketActivity)),
    );

    // Chatbot sudah dihapus
    expect(find.text('Tanya Reclub AI'), findsNothing);

    // Scroll sampai widget pengacak tim terlihat
    await tester.scrollUntilVisible(
      find.text('Pembagian Tim Otomatis'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byType(TeamGenerator), findsOneWidget);
    expect(find.text('Mau Berapa Tim'), findsOneWidget);
    expect(find.text('1 Tim Berapa Orang'), findsOneWidget);

    // Sebelum ditekan Acak Tim, belum ada kartu TIM A
    expect(find.text('TIM A'), findsNothing);

    // Ubah ke 3 Tim dan 3 Orang/Tim (mode 3x3 Basket)
    final teamField = find.descendant(
      of: find.byKey(const ValueKey('team_count_stepper')),
      matching: find.byType(TextField),
    );
    final playersField = find.descendant(
      of: find.byKey(const ValueKey('players_per_team_stepper')),
      matching: find.byType(TextField),
    );

    await tester.enterText(teamField, '3');
    await tester.enterText(playersField, '3');
    await tester.pump();

    await tester.ensureVisible(
      find.byKey(const ValueKey('shuffle_teams_button')),
    );
    await tester.tap(find.byKey(const ValueKey('shuffle_teams_button')));
    await tester.pumpAndSettle();

    expect(find.text('TIM A'), findsOneWidget);
    expect(find.text('TIM B'), findsOneWidget);
    expect(find.text('TIM C'), findsOneWidget);
    expect(find.text('Cadangan / Rotasi Berikutnya'), findsOneWidget);
  });

  testWidgets('Futsal DetailPage hides team generator for now', (tester) async {
    final futsalActivity = sampleActivities.firstWhere(
      (activity) => activity.title == 'Fun Futsal Bareng',
    );

    await tester.pumpWidget(
      MaterialApp(home: DetailPage(activity: futsalActivity)),
    );

    expect(find.byType(TeamGenerator), findsNothing);
    expect(find.text('Tanya Reclub AI'), findsNothing);
  });
}
