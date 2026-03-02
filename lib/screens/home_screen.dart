// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/providers/theme_provider.dart';
import '../widgets/service_preview_card.dart';
import '../widgets/gradient_button.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onContactTap;
  final VoidCallback? onServicesTap;
  const HomeScreen({super.key, this.onContactTap, this.onServicesTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _staggerFade;
  late List<Animation<Offset>> _staggerSlide;

  static const _services = [
    {'icon': Icons.phone_android_rounded, 'title': 'Mobile App Dev',  'color': Color(0xFF6366F1), 'route': 0},
    {'icon': Icons.language_rounded,      'title': 'Web Development', 'color': Color(0xFF8B5CF6), 'route': 1},
    {'icon': Icons.auto_awesome_rounded,  'title': 'UI/UX Design',    'color': Color(0xFF22D3EE), 'route': 2},
    {'icon': Icons.table_chart_rounded,   'title': 'Excel Solutions', 'color': Color(0xFF10B981), 'route': 4},
    {'icon': Icons.brush_rounded,         'title': 'Graphic Design',  'color': Color(0xFFF59E0B), 'route': 3},
    {'icon': Icons.videocam_rounded,      'title': 'Photo & Video',   'color': Color(0xFFEF4444), 'route': 5},
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _staggerFade = List.generate(4, (i) {
      final s = (i * 0.15).clamp(0.0, 1.0);
      final e = (s + 0.4).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: Interval(s, e, curve: Curves.easeOut)),
      );
    });
    _staggerSlide = List.generate(4, (i) {
      final s = (i * 0.15).clamp(0.0, 1.0);
      final e = (s + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
        CurvedAnimation(parent: _ctrl, curve: Interval(s, e, curve: Curves.easeOutCubic)),
      );
    });
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onExploreTap(BuildContext context, int serviceIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => _ServiceDetailSheet(serviceIndex: serviceIndex),
        transitionDuration: const Duration(milliseconds: 350),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colors = context.appColors;
    final isDark = colors.isDark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: _LogoTitle(),
        actions: [
          _ThemeToggle(isDark: isDark, onTap: themeProvider.toggle),
          const SizedBox(width: 16),
        ],
      ),
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero ────────────────────────────────────────────────────────
              FadeTransition(
                opacity: _staggerFade[0],
                child: SlideTransition(
                  position: _staggerSlide[0],
                  child: _HeroBanner(isDark: isDark),
                ),
              ),
              const SizedBox(height: 32),

              // ── Services header ──────────────────────────────────────────────
              FadeTransition(
                opacity: _staggerFade[1],
                child: SlideTransition(
                  position: _staggerSlide[1],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Our Services',
                              style: Theme.of(context).textTheme.headlineMedium),
                          const SizedBox(height: 2),
                          Text('Everything your brand needs',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      GestureDetector(
                        onTap: widget.onServicesTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withOpacity(
                                isDark ? 0.15 : 0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.primary.withOpacity(
                                  isDark ? 0.3 : 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'View all',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded,
                                  size: 13, color: AppTheme.primary),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Grid ────────────────────────────────────────────────────────
              FadeTransition(
                opacity: _staggerFade[2],
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    final s = _services[index];
                    return ServicePreviewCard(
                      icon: s['icon'] as IconData,
                      title: s['title'] as String,
                      color: s['color'] as Color,
                      onExploreTap: () =>
                          _onExploreTap(context, s['route'] as int),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // ── CTA ─────────────────────────────────────────────────────────
              FadeTransition(
                opacity: _staggerFade[3],
                child: SlideTransition(
                  position: _staggerSlide[3],
                  child: GradientButton(
                    label: 'Request a Service',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: widget.onContactTap ?? () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Logo title ────────────────────────────────────────────────────────────────
class _LogoTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: AppTheme.brandGradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(
              child: Text('DS',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.white)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ShaderMask(
          shaderCallback: (b) => AppTheme.brandGradient.createShader(b),
          child: const Text(
            'DesignSphere',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Hero banner ───────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final bool isDark;
  const _HeroBanner({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bgColor  = isDark ? const Color(0xFF0E0D20) : const Color(0xFFEEEDFF);
    final textMain = isDark ? AppTheme.textPrimaryD : AppTheme.textPrimaryL;
    final textSub  = isDark ? AppTheme.textSubD      : AppTheme.textSubL;
    final textHint = isDark ? AppTheme.textHintD     : AppTheme.textHintL;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(
          color: AppTheme.primary.withOpacity(isDark ? 0.2 : 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(isDark ? 0.15 : 0.08),
            blurRadius: 40,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        child: Stack(
          children: [
            // ── Soft glow — top-right ──────────────────────────────────────
            Positioned(
              right: -30, top: -30,
              child: Container(
                width: 180, height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppTheme.primary.withOpacity(isDark ? 0.16 : 0.09),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
            // ── Soft glow — bottom-left ────────────────────────────────────
            Positioned(
              left: -20, bottom: -20,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppTheme.accent.withOpacity(isDark ? 0.12 : 0.07),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),

            // ── Main content ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Top row: logo + badge ──────────────────────────────────
                  Row(
                    children: [
                      // Logo
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          gradient: AppTheme.brandGradient,
                          borderRadius: BorderRadius.circular(11),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withOpacity(0.38),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Text('DS',
                              style: TextStyle(fontSize: 12,
                                fontWeight: FontWeight.w900, color: Colors.white)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // "Open" status pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.green.withOpacity(isDark ? 0.14 : 0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.green.withOpacity(isDark ? 0.35 : 0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5, height: 5,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.green,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text('Open for projects',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.green,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Headline ──────────────────────────────────────────────
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'We craft ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: textMain,
                          height: 1.2,
                          letterSpacing: -0.8,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: ShaderMask(
                          shaderCallback: (b) =>
                              AppTheme.brandGradient.createShader(b),
                          child: const Text(
                            'digital\nexperiences',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                              letterSpacing: -0.8,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: '\nthat grow your brand.',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: textMain,
                          height: 1.2,
                          letterSpacing: -0.8,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ]),
                  ),

                  const SizedBox(height: 16),

                  // ── Subtle divider ─────────────────────────────────────────
                  Container(
                    height: 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppTheme.primary.withOpacity(isDark ? 0.35 : 0.2),
                        Colors.transparent,
                      ]),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ── Bottom row: tagline + service dots ─────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Service capability dots
                      Expanded(
                        child: Wrap(
                          spacing: 12,
                          children: ['Apps', 'Web', 'Design', 'Video'].map((s) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 4, height: 4,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.primary.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(s,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: textHint,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Service detail bottom sheet ───────────────────────────────────────────────
class _ServiceDetailSheet extends StatelessWidget {
  final int serviceIndex;
  const _ServiceDetailSheet({required this.serviceIndex});

  static const _allServices = [
    {
      'icon': Icons.phone_android_rounded,
      'title': 'Mobile App Development',
      'color': Color(0xFF6366F1),
      'description':
          'We build high-performance, cross-platform mobile apps using Flutter — delivering pixel-perfect UI and seamless user experiences on both iOS and Android.',
      'tags': ['Flutter', 'Firebase', 'iOS & Android', 'Performance'],
    },
    {
      'icon': Icons.language_rounded,
      'title': 'Web Development',
      'color': Color(0xFF8B5CF6),
      'description':
          'We build scalable web applications using the MERN stack (MongoDB, Express, React, Node.js) and implement SEO best practices for better search visibility and organic growth.',
      'tags': ['MERN Stack', 'React', 'Node.js', 'SEO'],
    },
    {
      'icon': Icons.auto_awesome_rounded,
      'title': 'UI/UX Designing',
      'color': Color(0xFF22D3EE),
      'description':
          'We craft modern, intuitive user interfaces and seamless user experiences — from wireframes and prototypes to polished, production-ready design systems.',
      'tags': ['Figma', 'Prototyping', 'Design Systems', 'User Research'],
    },
    {
      'icon': Icons.brush_rounded,
      'title': 'Graphic Designing',
      'color': Color(0xFFF59E0B),
      'description':
          'We create compelling brand identities, marketing materials, and visual content that communicate your brand\'s story with impact and consistency.',
      'tags': ['Brand Identity', 'Illustrations', 'Print', 'Social Media'],
    },
    {
      'icon': Icons.table_chart_rounded,
      'title': 'Excel Solutions',
      'color': Color(0xFF10B981),
      'description':
          'We build intelligent Excel dashboards, automated spreadsheets, and data tools that save time and turn raw data into actionable business insights.',
      'tags': ['Excel VBA', 'Dashboards', 'Automation', 'Data Analysis'],
    },
    {
      'icon': Icons.videocam_rounded,
      'title': 'Photo & Video Editing',
      'color': Color(0xFFEF4444),
      'description':
          'We deliver professional photo retouching, color grading, video editing, and motion graphics — perfect for social media, marketing campaigns, and brand storytelling.',
      'tags': ['Photo Editing', 'Video Editing', 'Color Grading', 'Reels'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;
    final s = _allServices[serviceIndex.clamp(0, _allServices.length - 1)];
    final color = s['color'] as Color;
    final tags = List<String>.from(s['tags'] as List);

    return Scaffold(
      backgroundColor: colors.cardBg,
      appBar: AppBar(
        backgroundColor: colors.cardBg,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(s['title'] as String),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child:
                        Icon(s['icon'] as IconData, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    s['title'] as String,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Overview', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Text(s['description'] as String,
                style:
                    Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7)),
            const SizedBox(height: 24),
            Text('Technologies & Skills',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags.map((tag) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: color.withOpacity(isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: color.withOpacity(isDark ? 0.35 : 0.2)),
                  ),
                  child: Text(tag,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: color)),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            GradientButton(
              label: 'Get a Quote',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Theme toggle ──────────────────────────────────────────────────────────────
class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _ThemeToggle({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 56,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isDark ? AppTheme.cardDark2 : AppTheme.dividerLight,
          border: Border.all(
            color: isDark
                ? AppTheme.primary.withOpacity(0.4)
                : AppTheme.primary.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: isDark
              ? [BoxShadow(color: AppTheme.primary.withOpacity(0.2), blurRadius: 8)]
              : [],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 7, top: 7,
              child: Icon(Icons.wb_sunny_rounded, size: 16,
                  color: isDark ? AppTheme.textHintD : AppTheme.primary),
            ),
            Positioned(
  right: 7,
  top: 7,
  child: Icon(
    Icons.nightlight_round,
    size: 16,
    color: isDark ? AppTheme.primary : Colors.grey,
  ),
),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOutCubic,
              left: isDark ? 28 : 2,
              top: 2,
              child: Container(
                width: 26, height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.brandGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.4),
                      blurRadius: 6, offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                  size: 14, color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}