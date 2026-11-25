import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reclub/features/joan_profile/profile_page.dart';
import 'package:reclub/features/paulus_home/home_page.dart';

void main() {
  testWidgets('profile switches between upcoming activities and history', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: JoanProfilePage()));

    expect(find.text('Futsal Santai Minggu Pagi'), findsOneWidget);
    expect(find.text('Kegiatan mendatang'), findsOneWidget);

    await tester.tap(find.text('Riwayat'));
    await tester.pumpAndSettle();

    expect(find.text('Kegiatan yang sudah diikuti'), findsOneWidget);
    expect(find.text('Basket 3x3'), findsOneWidget);
    expect(find.text('Futsal Santai Minggu Pagi'), findsNothing);
  });

  testWidgets('profile edit updates the displayed name and bio', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: JoanProfilePage()));

    await tester.tap(find.text('Edit profil'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'Joan Baru');
    await tester.enterText(find.byType(TextField).at(1), 'Suka main badminton');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Joan Baru'), findsOneWidget);
    expect(find.text('Suka main badminton'), findsOneWidget);
  });

  testWidgets('Home menu opens the Joan profile page', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    await tester.tap(find.byTooltip('Menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil saya'));
    await tester.pumpAndSettle();

    expect(find.byType(JoanProfilePage), findsOneWidget);
    expect(find.text('Profil Saya'), findsOneWidget);
  });
}
