import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../paulus_home/home_page.dart';
import 'auth_page.dart';
import 'reset_password_page.dart';

class ReclubAuthGate extends StatefulWidget {
  const ReclubAuthGate({super.key});

  @override
  State<ReclubAuthGate> createState() => _ReclubAuthGateState();
}

class _ReclubAuthGateState extends State<ReclubAuthGate> {
  late final StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      state,
    ) {
      if (state.event == AuthChangeEvent.passwordRecovery && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const ResetPasswordPage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return const AuthPage();

    final username = user.userMetadata?['username'];
    final displayName = username is String && username.trim().isNotEmpty
        ? username.trim()
        : user.email?.split('@').first ?? 'Teman';
    final bio = user.userMetadata?['bio'];
    return HomePage(userName: displayName, userBio: bio is String ? bio : '');
  }
}
