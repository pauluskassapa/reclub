import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reclub/features/auth/auth_page.dart';
import 'package:reclub/features/auth/auth_service.dart';

class FakeAccountAuth implements AccountAuthActions {
  String? createdUsername;
  String? signedInEmail;
  String? resetEmail;
  bool createSessionImmediately = false;

  @override
  Future<AuthenticatedAccount> signIn({
    required String email,
    required String password,
  }) async {
    signedInEmail = email;
    return const AuthenticatedAccount(username: 'Joan', bio: 'Voli');
  }

  @override
  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    createdUsername = username;
    return createSessionImmediately;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    resetEmail = email;
  }

  @override
  Future<void> updateProfile({
    required String username,
    required String bio,
  }) async {}

  @override
  Future<void> updatePassword(String password) async {}

  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets(
    'account registration validates and submits username/email/password',
    (tester) async {
      final auth = FakeAccountAuth();
      await tester.pumpWidget(MaterialApp(home: AuthPage(authActions: auth)));

      await tester.ensureVisible(find.text('Buat akun'));
      await tester.tap(find.text('Buat akun'));
      await tester.pumpAndSettle();
      expect(find.byType(TextFormField), findsNWidgets(3));

      await tester.enterText(find.byType(TextFormField).at(0), 'joan');
      await tester.enterText(
        find.byType(TextFormField).at(1),
        'joan@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(2), '123');
      await tester.ensureVisible(find.text('Daftar'));
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();
      expect(find.text('Password minimal 6 karakter.'), findsOneWidget);
      expect(auth.createdUsername, isNull);

      await tester.enterText(find.byType(TextFormField).at(2), 'reclub123');
      await tester.ensureVisible(find.text('Daftar'));
      await tester.tap(find.text('Daftar'));
      await tester.pumpAndSettle();

      expect(auth.createdUsername, 'joan');
      expect(
        find.text(
          'Akun dibuat. Cek email untuk verifikasi, lalu masuk di sini.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'login uses the entered email and opens the authenticated callback',
    (tester) async {
      final auth = FakeAccountAuth();
      AuthenticatedAccount? authenticatedAs;
      await tester.pumpWidget(
        MaterialApp(
          home: AuthPage(
            authActions: auth,
            onAuthenticated: (account) => authenticatedAs = account,
          ),
        ),
      );

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'joan@example.com',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'reclub123');
      await tester.ensureVisible(find.text('Masuk'));
      await tester.tap(find.text('Masuk'));
      await tester.pumpAndSettle();

      expect(auth.signedInEmail, 'joan@example.com');
      expect(authenticatedAs?.username, 'Joan');
      expect(authenticatedAs?.bio, 'Voli');
    },
  );
}
