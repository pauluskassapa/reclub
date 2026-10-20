import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reclub/main.dart';

void main() {
  testWidgets('RECLUB opens with its branded splash screen', (tester) async {
    await tester.pumpWidget(const ReclubApp());

    expect(find.text('RECLUB'), findsOneWidget);
    expect(find.text('TEMUKAN TEMAN. MAIN BARENG.'), findsOneWidget);

    // Dispose the splash timer before the widget test ends.
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
