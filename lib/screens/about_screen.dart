// lib/screens/about_screen.dart

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});
  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark  = colors.isDark;

    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Brand Card ─────────────────────────────────────────────────
                _stagger(0, _BrandCard(isDark: isDark)),
                const SizedBox(height: 24),

                // ── Stats Row ──────────────────────────────────────────────────
                _stagger(1, _buildStatsRow(colors)),
                const SizedBox(height: 28),

                // ── Company Values section ─────────────────────────────────────
                _stagger(2, _sectionLabel(context, 'Company Values')),
                const SizedBox(height: 14),

                _stagger(
                  3,
                  _ValueCard(
                    colors: colors,
                    icon: Icons.lightbulb_outline_rounded,
                    gradient: const LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                    title: 'Our Vision',
                    body:
                        'To empower businesses and individuals with innovative digital solutions that enhance their digital presence and drive meaningful growth in the modern world.',
                  ),
                ),
                const SizedBox(height: 14),

                _stagger(
                  4,
                  _ValueCard(
                    colors: colors,
                    icon: Icons.rocket_launch_outlined,
                    gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF22D3EE)]),
                    title: 'Our Aim',
                    body:
                        'To deliver high-quality, scalable, and user-centric design and development services while maintaining creativity and reliability — ensuring every client achieves their digital goals.',
                  ),
                ),
                const SizedBox(height: 28),

                // ── Why us ─────────────────────────────────────────────────────
                _stagger(5, _sectionLabel(context, 'Why DesignSphere?')),
                const SizedBox(height: 14),
                _stagger(6, _WhyUsGrid(colors: colors)),
                const SizedBox(height: 32),

                // ── Footer ─────────────────────────────────────────────────────
                _stagger(
                  7,
                  Center(
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (b) => AppTheme.brandGradient.createShader(b),
                          child: const Text(
                            'DesignSphere',
                            style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800,
                              color: Colors.white, letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Made with ❤️  by the DesignSphere team',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: colors.textHint),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _stagger(int index, Widget child) {
    final start = (index * 0.10).clamp(0.0, 0.85);
    final end   = (start + 0.4).clamp(0.0, 1.0);
    final fade  = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOut)),
    );
    final slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
      CurvedAnimation(parent: _ctrl, curve: Interval(start, end, curve: Curves.easeOutCubic)),
    );
    return FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
  }

  Widget _sectionLabel(BuildContext context, String label) {
    return Row(
      children: [
        Container(
          width: 3, height: 18,
          decoration: BoxDecoration(
            gradient: AppTheme.brandGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(label, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Widget _buildStatsRow(AppColors colors) {
    const stats = [
      ('50+', 'Projects'),
      ('30+', 'Clients'),
      ('3+', 'Years'),
      ('6', 'Services'),
    ];
    return Row(
      children: [
        for (int i = 0; i < stats.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: _StatTile(value: stats[i].$1, label: stats[i].$2, colors: colors),
          ),
        ],
      ],
    );
  }
}

// ── Brand card ────────────────────────────────────────────────────────────────
class _BrandCard extends StatelessWidget {
  final bool isDark;
  const _BrandCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        gradient: AppTheme.brandGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(isDark ? 0.45 : 0.25),
            blurRadius: 32,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppTheme.accent.withOpacity(0.2),
            blurRadius: 60,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10, top: -10,
            child: Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 72, height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Text('DS',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'DesignSphere',
                style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800,
                  color: Colors.white, letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Your Digital Transformation Partner',
                style: TextStyle(
                  fontSize: 13, color: Colors.white.withOpacity(0.82),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Stat tile ─────────────────────────────────────────────────────────────────
class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final AppColors colors;
  const _StatTile({required this.value, required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: colors.cardShadow,
        border: Border.all(color: colors.divider, width: 0.5),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (b) => AppTheme.brandGradient.createShader(b),
            child: Text(value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: colors.textSub, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ── Value card ────────────────────────────────────────────────────────────────
class _ValueCard extends StatelessWidget {
  final AppColors colors;
  final IconData icon;
  final LinearGradient gradient;
  final String title;
  final String body;
  const _ValueCard({
    required this.colors,
    required this.icon,
    required this.gradient,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        boxShadow: colors.cardShadow,
        border: Border.all(color: colors.divider, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(body,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.65)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Why us grid ───────────────────────────────────────────────────────────────
class _WhyUsGrid extends StatelessWidget {
  final AppColors colors;
  const _WhyUsGrid({required this.colors});

  @override
  Widget build(BuildContext context) {
    const points = [
      (Icons.verified_rounded,         'Quality First',     'Every deliverable meets premium standards.',     Color(0xFF6366F1)),
      (Icons.access_time_filled_rounded,'On-Time Delivery',  'We respect every deadline, every time.',         Color(0xFF8B5CF6)),
      (Icons.support_agent_rounded,     '24/7 Support',      'Always here when you need us most.',             Color(0xFF22D3EE)),
      (Icons.trending_up_rounded,       'Results Driven',    'We measure success by your real growth.',        Color(0xFF10B981)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: points.length,
      itemBuilder: (context, index) {
        final (icon, title, sub, accent) = points[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            boxShadow: colors.cardShadow,
            border: Border.all(
              color: accent.withOpacity(colors.isDark ? 0.2 : 0.1),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent.withOpacity(colors.isDark ? 0.18 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accent, size: 18),
              ),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 3),
              Text(sub,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.4),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        );
      },
    );
  }
}