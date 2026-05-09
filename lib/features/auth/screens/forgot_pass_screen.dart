import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_theme.dart';
import '../widgets/auth_widgets.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _loading = false;
  bool _isResetMode = false;
  bool _obscure = true;
  late final StreamSubscription<AuthState> _authSub;

  @override
  void initState() {
    super.initState();
    // Listen for password recovery event. When a user clicks the reset link in their email,
    // Supabase will trigger this event and we'll show the password update fields.
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        setState(() {
          _isResetMode = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleAction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      if (_isResetMode) {
        await _updatePassword();
      } else {
        await _sendResetEmail();
      }
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
    }
  }

  /// Sends the password reset email via Supabase.
  Future<void> _sendResetEmail() async {
    // The redirectTo URL must be registered in your Supabase project under Auth -> URL Configuration.
    await Supabase.instance.client.auth.resetPasswordForEmail(
      _emailCtrl.text.trim(),
      redirectTo: 'io.tinysteps://login-callback',
    );

    if (mounted) {
      setState(() => _loading = false);
      _showSuccessDialog(
        'Email Sent',
        'Check your inbox for a password reset link. Follow the instructions in the email to set a new password.',
        () => context.pop(),
      );
    }
  }

  /// Updates the user's password once they've clicked the recovery link.
  Future<void> _updatePassword() async {
    await Supabase.instance.client.auth.updateUser(
      UserAttributes(password: _passCtrl.text.trim()),
    );

    if (mounted) {
      setState(() => _loading = false);
      _showSuccessDialog(
        'Password Updated',
        'Your password has been reset successfully. You can now sign in with your new password.',
        () async {
          // Sign out to clear the recovery session and force a fresh login
          await Supabase.instance.client.auth.signOut();
          if (mounted) {
            context.go('/login');
          }
        },
      );
    }
  }

  void _showSuccessDialog(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isResetMode ? 'Reset Password' : 'Forgot Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isResetMode ? 'Create New Password' : 'Reset your password',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _isResetMode 
                    ? 'Enter your new password below. Make sure it is strong and secure.'
                    : 'Enter your email address and we\'ll send you a link to reset your password.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!_isResetMode)
                      AuthTextField(
                        label: 'Email Address',
                        hint: 'hello@tinysteps.com',
                        controller: _emailCtrl,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      )
                    else ...[
                      AuthTextField(
                        label: 'New Password',
                        hint: '••••••••',
                        controller: _passCtrl,
                        icon: Icons.lock_outline,
                        obscureText: _obscure,
                        suffix: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 20,
                            color: cs.onSurface.withValues(alpha: 0.4),
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v.length < 8) return 'Min 8 characters';
                          return null;
                        },
                      ),
                      AuthTextField(
                        label: 'Confirm New Password',
                        hint: '••••••••',
                        controller: _confirmPassCtrl,
                        icon: Icons.lock_outline,
                        obscureText: _obscure,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v != _passCtrl.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    AuthGradientButton(
                      label: _isResetMode ? 'Update Password' : 'Send Reset Link',
                      icon: _isResetMode ? Icons.check_circle_outline : Icons.send_rounded,
                      onTap: _loading ? null : _handleAction,
                      loading: _loading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
