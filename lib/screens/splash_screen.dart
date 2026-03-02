// lib/screens/splash_screen.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Master controller – drives sequencing
  late AnimationController _master;

  // Individual animations
  late Animation<double> _bgFade;
  late Animation<double> _orb1Scale;
  late Animation<double> _orb2Scale;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double>  _titleFade;
  late Animation<Offset> _taglineSlide;
  late Animation<double>  _taglineFade;
  late Animation<double> _dotsFade;
  late Animation<double> _dotsProgress;

  @override
  void initState() {
    super.initState();

    _master = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // Background orbs
    _bgFade     = _curve(0.00, 0.25, Curves.easeOut);
    _orb1Scale  = _curve(0.00, 0.40, Curves.elasticOut, begin: 0.0, end: 1.0);
    _orb2Scale  = _curve(0.10, 0.50, Curves.elasticOut, begin: 0.0, end: 1.0);

    // Logo
    _logoFade   = _curve(0.20, 0.55, Curves.easeOut);
    _logoScale  = _curve(0.15, 0.55, Curves.elasticOut, begin: 0.4, end: 1.0);

    // Ring pulse
    _ringScale  = _curve(0.45, 0.80, Curves.easeOut, begin: 0.7, end: 1.4);
    _ringOpacity= _curve(0.45, 0.80, Curves.easeOut, begin: 0.6, end: 0.0);

    // Text
    _titleSlide  = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(_curveRaw(0.50, 0.78, Curves.easeOutCubic));
    _titleFade   = _curve(0.50, 0.78, Curves.easeOut);

    _taglineSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(_curveRaw(0.60, 0.85, Curves.easeOutCubic));
    _taglineFade  = _curve(0.60, 0.85, Curves.easeOut);

    // Loading dots
    _dotsFade     = _curve(0.72, 0.88, Curves.easeOut);
    _dotsProgress = _curve(0.75, 1.00, Curves.easeInOut);

    _master.forward();

    Future.delayed(const Duration(milliseconds: 2900), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainScreen(),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
            child: child,
          ),
        ),
      );
    });
  }

  // Helper: creates a 0→1 animation between [start] and [end] normalized time
  Animation<double> _curve(double start, double intervalEnd, Curve curve,
      {double begin = 0.0, double end = 1.0}) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: _master,
        curve: Interval(start, intervalEnd, curve: curve),
      ),
    );
  }

  CurvedAnimation _curveRaw(double start, double end, Curve curve) =>
      CurvedAnimation(parent: _master, curve: Interval(start, end, curve: curve));

  @override
  void dispose() {
    _master.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: AnimatedBuilder(
        animation: _master,
        builder: (context, _) {
          return Stack(
            children: [
              // ── Background gradient ────────────────────────────────────────
              FadeTransition(
                opacity: _bgFade,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0, -0.3),
                      radius: 1.2,
                      colors: [Color(0xFF1A1040), AppTheme.bgDark],
                    ),
                  ),
                ),
              ),

              // ── Orb 1 – top-left ──────────────────────────────────────────
              Positioned(
                top: -size.height * 0.15,
                left: -size.width * 0.3,
                child: Transform.scale(
                  scale: _orb1Scale.value,
                  child: Container(
                    width: size.width * 0.8,
                    height: size.width * 0.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.primary.withOpacity(0.18),
                          AppTheme.primary.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Orb 2 – bottom-right ──────────────────────────────────────
              Positioned(
                bottom: -size.height * 0.1,
                right: -size.width * 0.25,
                child: Transform.scale(
                  scale: _orb2Scale.value,
                  child: Container(
                    width: size.width * 0.7,
                    height: size.width * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.accent.withOpacity(0.15),
                          AppTheme.accent.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Grid overlay (subtle) ─────────────────────────────────────
              Opacity(
                opacity: _bgFade.value * 0.25,
                child: CustomPaint(
                  size: size,
                  painter: _GridPainter(),
                ),
              ),

              // ── Center content ────────────────────────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo + ring pulse
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Expanding ring
                          Opacity(
                            opacity: _ringOpacity.value,
                            child: Transform.scale(
                              scale: _ringScale.value,
                              child: Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppTheme.primary.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Logo box
                          FadeTransition(
                            opacity: _logoFade,
                            child: Transform.scale(
                              scale: _logoScale.value,
                              child: Container(
                                width: 92,
                                height: 92,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  gradient: AppTheme.brandGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primary.withOpacity(0.5),
                                      blurRadius: 32,
                                      spreadRadius: 2,
                                    ),
                                    BoxShadow(
                                      color: AppTheme.accent.withOpacity(0.3),
                                      blurRadius: 60,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(26),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Text(
                                        'DS',
                                        style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // App name
                    FadeTransition(
                      opacity: _titleFade,
                      child: SlideTransition(
                        position: _titleSlide,
                        child: ShaderMask(
                          shaderCallback: (bounds) =>
                              AppTheme.brandGradient.createShader(bounds),
                          child: const Text(
                            'DesignSphere',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Tagline
                    FadeTransition(
                      opacity: _taglineFade,
                      child: SlideTransition(
                        position: _taglineSlide,
                        child: Text(
                          'Your Digital Transformation Partner',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.textSubD,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 52),

                    // Loading dots
                    FadeTransition(
                      opacity: _dotsFade,
                      child: _LoadingDots(progress: _dotsProgress.value),
                    ),
                  ],
                ),
              ),

              // Version tag bottom
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _taglineFade,
                  child: Center(
                    child: Text(
                      'v1.0.0',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.textHintD,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Loading dots widget ───────────────────────────────────────────────────────
class _LoadingDots extends StatelessWidget {
  final double progress; // 0 → 1
  const _LoadingDots({required this.progress});

  @override
  Widget build(BuildContext context) {
    const count = 3;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final threshold = (i + 1) / count;
        final active = progress >= (i / count);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: active
                ? AppTheme.brandGradient
                : null,
            color: active ? null : AppTheme.textHintD.withOpacity(0.3),
          ),
        );
      }),
    );
  }
}

// ── Subtle grid background painter ───────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary.withOpacity(0.08)
      ..strokeWidth = 0.5;
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}