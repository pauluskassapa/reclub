import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../paulus_home/home_page.dart';
import 'auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.authActions, this.onAuthenticated});

  final AccountAuthActions? authActions;
  final ValueChanged<AuthenticatedAccount>? onAuthenticated;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AccountAuthActions _authActions;
  bool _isLogin = true;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _message;
  bool _messageIsError = false;

  @override
  void initState() {
    super.initState();
    _authActions = widget.authActions ?? const SupabaseAccountAuth();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    try {
      if (_isLogin) {
        final account = await _authActions.signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (mounted) _openHome(account);
      } else {
        final hasSession = await _authActions.signUp(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
        if (!mounted) return;
        if (hasSession) {
          _openHome(
            AuthenticatedAccount(
              username: _usernameController.text.trim(),
              bio: '',
            ),
          );
        } else {
          setState(() {
            _isLogin = true;
            _passwordController.clear();
            _message =
                'Akun dibuat. Cek email untuk verifikasi, lalu masuk di sini.';
            _messageIsError = false;
          });
        }
      }
    } on AuthException catch (error) {
      if (mounted) _showMessage(_friendlyAuthError(error));
    } catch (_) {
      if (mounted) {
        _showMessage('Tidak bisa terhubung. Coba lagi beberapa saat.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _sendPasswordReset() async {
    FocusScope.of(context).unfocus();
    if (_emailController.text.trim().isEmpty) {
      _showMessage('Masukkan email terlebih dahulu.');
      return;
    }

    setState(() {
      _isLoading = true;
      _message = null;
    });
    try {
      await _authActions.sendPasswordReset(_emailController.text);
      if (mounted) {
        setState(() {
          _message = 'Tautan pemulihan dikirim jika email terdaftar.';
          _messageIsError = false;
        });
      }
    } on AuthException catch (error) {
      if (mounted) _showMessage(_friendlyAuthError(error));
    } catch (_) {
      if (mounted) {
        _showMessage('Tidak bisa mengirim email pemulihan. Coba lagi.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _openHome(AuthenticatedAccount account) {
    final onAuthenticated = widget.onAuthenticated;
    if (onAuthenticated != null) {
      onAuthenticated(account);
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) =>
            HomePage(userName: account.username, userBio: account.bio),
      ),
      (_) => false,
    );
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
      _messageIsError = true;
    });
  }

  String _friendlyAuthError(AuthException error) {
    final message = error.message.toLowerCase();
    if (message.contains('invalid login credentials')) {
      return 'Email atau password belum benar.';
    }
    if (message.contains('already registered') ||
        message.contains('user already registered')) {
      return 'Email ini sudah terdaftar. Silakan masuk.';
    }
    if (message.contains('password should be at least')) {
      return 'Password harus terdiri dari minimal 6 karakter.';
    }
    if (message.contains('email not confirmed')) {
      return 'Verifikasi email kamu sebelum masuk.';
    }
    return error.message;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email wajib diisi.';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      return 'Masukkan alamat email yang valid.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Password wajib diisi.';
    if (!_isLogin && password.length < 6) {
      return 'Password minimal 6 karakter.';
    }
    return null;
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.mutedText),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF5F8F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE6ECE9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _isLogin ? 'Selamat datang kembali!' : 'Gabung bersama kami';
    final subtitle = _isLogin
        ? 'Masuk dan lanjutkan aktivitas olahragamu.'
        : 'Buat akun RECLUB untuk mulai bermain bersama.';

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.sports_soccer_rounded,
                        color: AppColors.primary,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'RECLUB',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.text.withValues(alpha: 0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.text,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              subtitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.mutedText,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 22),
                            if (!_isLogin) ...[
                              TextFormField(
                                controller: _usernameController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                decoration: _inputDecoration(
                                  label: 'Username',
                                  icon: Icons.person_outline_rounded,
                                ),
                                validator: (value) {
                                  if (_isLogin) return null;
                                  if ((value ?? '').trim().isEmpty) {
                                    return 'Username wajib diisi.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 14),
                            ],
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [AutofillHints.email],
                              decoration: _inputDecoration(
                                label: 'Email',
                                icon: Icons.mail_outline_rounded,
                              ),
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 14),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: !_isPasswordVisible,
                              textInputAction: TextInputAction.done,
                              autofillHints: _isLogin
                                  ? const [AutofillHints.password]
                                  : const [AutofillHints.newPassword],
                              onFieldSubmitted: (_) => _submit(),
                              decoration: _inputDecoration(
                                label: _isLogin
                                    ? 'Password'
                                    : 'Password (min 6 karakter)',
                                icon: Icons.lock_outline_rounded,
                                suffixIcon: IconButton(
                                  tooltip: _isPasswordVisible
                                      ? 'Sembunyikan password'
                                      : 'Tampilkan password',
                                  onPressed: () => setState(
                                    () => _isPasswordVisible =
                                        !_isPasswordVisible,
                                  ),
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: _validatePassword,
                            ),
                            if (_isLogin)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _sendPasswordReset,
                                  child: const Text('Lupa password?'),
                                ),
                              )
                            else
                              const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'Gunakan minimal 6 karakter.',
                                  style: TextStyle(
                                    color: AppColors.mutedText,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            if (_message != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _message!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _messageIsError
                                      ? const Color(0xFFB42318)
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed: _isLoading ? null : _submit,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        _isLogin ? 'Masuk' : 'Daftar',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isLogin
                                      ? 'Belum punya akun?'
                                      : 'Sudah punya akun?',
                                  style: const TextStyle(
                                    color: AppColors.mutedText,
                                  ),
                                ),
                                TextButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () => setState(() {
                                          _isLogin = !_isLogin;
                                          _message = null;
                                          _formKey.currentState?.reset();
                                        }),
                                  child: Text(
                                    _isLogin ? 'Buat akun' : 'Masuk',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
