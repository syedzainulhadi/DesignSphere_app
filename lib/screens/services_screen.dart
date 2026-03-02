// lib/screens/services_screen.dart

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../widgets/service_detail_card.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  static const _services = [
    {
      'icon': Icons.phone_android_rounded,
      'title': 'Mobile App Development',
      'description':
          'We build high-performance, cross-platform mobile apps using Flutter — delivering pixel-perfect UI and seamless user experiences on both iOS and Android.',
      'color': Color(0xFF6366F1),
      'tags': ['Flutter', 'Firebase', 'iOS & Android', 'Performance'],
    },
    {
      'icon': Icons.language_rounded,
      'title': 'Web Development',
      'description':
          'We build scalable web applications using the MERN stack (MongoDB, Express, React, Node.js) and implement SEO best practices for better search visibility and organic growth.',
      'color': Color(0xFF8B5CF6),
      'tags': ['MERN Stack', 'React', 'Node.js', 'SEO'],
    },
    {
      'icon': Icons.auto_awesome_rounded,
      'title': 'UI/UX Designing',
      'description':
          'We craft modern, intuitive user interfaces and seamless user experiences — from wireframes and prototypes to polished, production-ready design systems.',
      'color': Color(0xFF22D3EE),
      'tags': ['Figma', 'Prototyping', 'Design Systems', 'User Research'],
    },
    {
      'icon': Icons.brush_rounded,
      'title': 'Graphic Designing',
      'description':
          'We create compelling brand identities, marketing materials, and visual content that communicate your brand\'s story with impact and consistency.',
      'color': Color(0xFFF59E0B),
      'tags': ['Brand Identity', 'Illustrations', 'Print', 'Social Media'],
    },
    {
      'icon': Icons.table_chart_rounded,
      'title': 'Excel Solutions',
      'description':
          'We build intelligent Excel dashboards, automated spreadsheets, and data tools that save time and turn raw data into actionable business insights.',
      'color': Color(0xFF10B981),
      'tags': ['Excel VBA', 'Dashboards', 'Automation', 'Data Analysis'],
    },
    {
      'icon': Icons.videocam_rounded,
      'title': 'Photo & Video Editing',
      'description':
          'We deliver professional photo retouching, color grading, video editing, and motion graphics — perfect for social media, marketing campaigns, and brand storytelling.',
      'color': Color(0xFFEF4444),
      'tags': ['Photo Editing', 'Video Editing', 'Color Grading', 'Reels'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
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
    final isDark = colors.isDark;

    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _ctrl,
                  curve: const Interval(0, 0.5, curve: Curves.easeOut),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What We Offer',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Comprehensive digital solutions, built to scale',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final s = _services[index];
                  final delay = index * 0.08;

                  return AnimatedBuilder(
                    animation: _ctrl,
                    builder: (context, child) {
                      final t =
                          ((_ctrl.value - delay) / 0.35).clamp(0.0, 1.0);
                      final opacity =
                          Curves.easeOut.transform(t.toDouble());
                      final slide =
                          1 - Curves.easeOutCubic.transform(t.toDouble());

                      return Opacity(
                        opacity: opacity,
                        child: Transform.translate(
                          offset: Offset(0, 30 * slide),
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: ServiceDetailCard(
                        icon: s['icon'] as IconData,
                        title: s['title'] as String,
                        description: s['description'] as String,
                        color: s['color'] as Color,
                        tags: List<String>.from(s['tags'] as List),
                      ),
                    ),
                  );
                },
                childCount: _services.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}