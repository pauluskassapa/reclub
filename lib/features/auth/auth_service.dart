import 'package:supabase_flutter/supabase_flutter.dart';

class ReclubAuthConfig {
  ReclubAuthConfig._();

  static const redirectUrl = 'com.reclubapp.reclub://login-callback/';
}

class AuthenticatedAccount {
  const AuthenticatedAccount({required this.username, required this.bio});

  final String username;
  final String bio;
}

abstract interface class AccountAuthActions {
  Future<AuthenticatedAccount> signIn({
    required String email,
    required String password,
  });

  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
  });

  Future<void> sendPasswordReset(String email);

  Future<void> updateProfile({required String username, required String bio});

  Future<void> updatePassword(String password);

  Future<void> signOut();
}

class SupabaseAccountAuth implements AccountAuthActions {
  const SupabaseAccountAuth();

  GoTrueClient get _auth => Supabase.instance.client.auth;

  @override
  Future<AuthenticatedAccount> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    final user = response.user;
    final metadata = user?.userMetadata;
    final username = metadata?['username'];
    final bio = metadata?['bio'];
    if (username is String && username.trim().isNotEmpty) {
      return AuthenticatedAccount(
        username: username.trim(),
        bio: bio is String ? bio : '',
      );
    }
    return AuthenticatedAccount(
      username: email.trim().split('@').first,
      bio: bio is String ? bio : '',
    );
  }

  @override
  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _auth.signUp(
      email: email.trim(),
      password: password,
      data: {'username': username.trim(), 'bio': ''},
      emailRedirectTo: ReclubAuthConfig.redirectUrl,
    );
    return response.session != null;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await _auth.resetPasswordForEmail(
      email.trim(),
      redirectTo: ReclubAuthConfig.redirectUrl,
    );
  }

  @override
  Future<void> updateProfile({
    required String username,
    required String bio,
  }) async {
    await _auth.updateUser(
      UserAttributes(data: {'username': username.trim(), 'bio': bio.trim()}),
    );
  }

  @override
  Future<void> updatePassword(String password) async {
    await _auth.updateUser(UserAttributes(password: password));
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
