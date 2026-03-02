// lib/features/auth/auth_screen.dart
//
// Single screen that handles both Login and Sign Up with a smooth toggle.
// Matches the app's existing dark theme and design language perfectly.

import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/gradient_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  // ── State ─────────────────────────────────────────────────────────────────
  bool _isLogin = true;     // toggle between Login and Sign Up
  bool _isLoading = false;
  bool _obscurePassword = true;

  // ── Controllers ───────────────────────────────────────────────────────────
  final _formKey     = GlobalKey<FormState>();
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _passwordCtrl = TextEditingController();

  // ── Animation ─────────────────────────────────────────────────────────────
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  // ── Toggle between login and signup ───────────────────────────────────────
  void _toggleMode() {
    _formKey.currentState?.reset();
    _nameCtrl.clear();
    _emailCtrl.clear();
    _passwordCtrl.clear();
    _fadeCtrl.reset();
    setState(() => _isLogin = !_isLogin);
    _fadeCtrl.forward();
  }

  // ── Submit handler ────────────────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    AuthResult result;

    if (_isLogin) {
      result = await _authService.signInWithEmailPassword(
        email:    _emailCtrl.text,
        password: _passwordCtrl.text,
      );
    } else {
      result = await _authService.signUpWithEmailPassword(
        name:     _nameCtrl.text,
        email:    _emailCtrl.text,
        password: _passwordCtrl.text,
      );
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (!result.success) {
      // Show error as a floating snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  result.error ?? 'Something went wrong.',
                  style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
    }
    // On success, AuthWrapper automatically navigates to MainScreen
    // because authStateChanges() emits a User — no manual navigation needed.
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark  = colors.isDark;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Logo + header ────────────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      // Logo
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          gradient: AppTheme.brandGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text('DS',
                              style: TextStyle(fontSize: 22,
                                fontWeight: FontWeight.w900, color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ShaderMask(
                        shaderCallback: (b) => AppTheme.brandGradient.createShader(b),
                        child: const Text(
                          'DesignSphere',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isLogin
                            ? 'Welcome back. Sign in to continue.'
                            : 'Create your account to get started.',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSub,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // ── Toggle tab ────────────────────────────────────────────────
                Container(
                  height: 46,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.divider, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      _tabButton('Log In',  isActive: _isLogin,  onTap: () { if (!_isLogin) _toggleMode(); }),
                      _tabButton('Sign Up', isActive: !_isLogin, onTap: () { if (_isLogin)  _toggleMode(); }),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Form ──────────────────────────────────────────────────────
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Name — only shown on Sign Up
                      if (!_isLogin) ...[
                        _label('Full Name'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameCtrl,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            hintText: 'Enter your name',
                            prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Name is required';
                            if (v.trim().length < 2) return 'Minimum 2 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                      ],

                      // Email
                      _label('Email Address'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.mail_outline_rounded, size: 20),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Email is required';
                          final re = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!re.hasMatch(v.trim())) return 'Enter a valid email';
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Password
                      _label('Password'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          hintText: _isLogin ? 'Enter your password' : 'Create a password (min. 6 chars)',
                          prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: colors.textHint,
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password is required';
                          if (!_isLogin && v.length < 6) return 'Minimum 6 characters';
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // Submit button
                      _isLoading
                          ? _loadingButton()
                          : GradientButton(
                              label: _isLogin ? 'Log In' : 'Create Account',
                              icon: _isLogin
                                  ? Icons.login_rounded
                                  : Icons.check_circle_outline_rounded,
                              onPressed: _submit,
                            ),

                      const SizedBox(height: 20),

                      // Toggle link
                      Center(
                        child: GestureDetector(
                          onTap: _toggleMode,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: _isLogin
                                      ? "Don't have an account? "
                                      : 'Already have an account? ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colors.textSub,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                TextSpan(
                                  text: _isLogin ? 'Sign Up' : 'Log In',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primary,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── UI helpers ────────────────────────────────────────────────────────────
  Widget _tabButton(String label, {required bool isActive, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: isActive ? AppTheme.brandGradient : null,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Colors.white : context.appColors.textHint,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: context.appColors.textPrimary,
      letterSpacing: 0.1,
      fontFamily: 'Poppins',
    ),
  );

  Widget _loadingButton() => Container(
    width: double.infinity,
    height: 54,
    decoration: BoxDecoration(
      gradient: AppTheme.brandGradient,
      borderRadius: BorderRadius.circular(AppTheme.radiusM),
      boxShadow: AppTheme.buttonGlow,
    ),
    child: const Center(
      child: SizedBox(
        width: 22, height: 22,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
      ),
    ),
  );
}