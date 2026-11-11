import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reclub/features/paulus_feed/feed_page.dart';
import 'package:reclub/features/paulus_feed/models/feed_post.dart';
import 'package:reclub/features/paulus_feed/services/feed_service.dart';

class TestFeedService extends FeedService {
  bool fail = false;
  List<FeedPost> posts = [];

  @override
  Future<List<FeedPost>> fetchPosts() async {
    if (fail) throw Exception('Offline');
    return posts;
  }
}

void main() {
  testWidgets('Feed renders database posts and handles an empty result', (
    tester,
  ) async {
    final service = TestFeedService();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: FeedPage(service: service)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Belum ada kabar komunitas'), findsOneWidget);
    expect(find.text('Main bareng akhir pekan'), findsNothing);
  });

  testWidgets(
    'Failed database request can be retried without local seed posts',
    (tester) async {
      final service = TestFeedService()..fail = true;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FeedPage(service: service)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Coba lagi'), findsOneWidget);
      expect(find.text('Main bareng akhir pekan'), findsNothing);
      service.fail = false;
      service.posts = [
        const FeedPost(
          id: 'database-1',
          club: 'Klub dari database',
          initials: 'KD',
          category: 'Futsal',
          title: 'Latihan sore',
          message: 'Bawa sepatu.',
          imagePath: 'assets/images/futsal.jpg',
          likes: 2,
        ),
      ];
      await tester.tap(find.text('Coba lagi'));
      await tester.pumpAndSettle();
      expect(find.text('Klub dari database'), findsOneWidget);
      expect(find.text('Latihan sore'), findsOneWidget);
      expect(find.text('Coba lagi'), findsNothing);
    },
  );
}
