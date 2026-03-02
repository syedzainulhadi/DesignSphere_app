// lib/screens/team_screen.dart

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../widgets/team_member_card.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});
  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  static const _team = [
    {
      'name': 'Syed Hadi',
      'role': 'Founder & CEO',
      'speciality': 'Mobile App Developer',
      'initials': 'SH',
      'color': Color(0xFF6366F1),
      'image': 'assets/images/team_hadi.png',
      'bio':
          'Visionary entrepreneur and mobile-first developer. Syed leads DesignSphere\'s strategy and builds cutting-edge Flutter applications that delight users.',
      'skills': ['Flutter', 'Firebase', 'Strategy', 'Leadership'],
    },
    {
      'name': 'Shahid Firozabad',
      'role': 'Co-Founder & CTO',
      'speciality': 'MERN Stack Developer',
      'initials': 'SF',
      'color': Color(0xFF8B5CF6),
      'image': 'assets/images/team_shahid.png',
      'bio':
          'Full-stack architect with deep expertise in the MERN stack, SEO, and scalable cloud systems. Shahid ensures every product is engineered for performance and longevity.',
      'skills': ['MongoDB', 'React', 'Node.js', 'SEO', 'DevOps'],
    },
    {
      'name': 'Saish Naik',
      'role': 'CMO',
      'speciality': 'UI/UX Developer & Graphic Designer',
      'initials': 'SN',
      'color': Color(0xFF22D3EE),
      'image': 'assets/images/team_saish.png',
      'bio':
          'Creative director and growth strategist. Saish blends beautiful design with smart marketing — crafting brand identities and campaigns that convert.',
      'skills': ['Figma', 'Graphic Design', 'Branding', 'Marketing'],
    },
  ];

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
    return Scaffold(
      appBar: AppBar(title: const Text('Our Team')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (context, child) {
                  final t = Curves.easeOut.transform(_ctrl.value.clamp(0, 1));
                  return Opacity(opacity: t, child: child);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Meet the Team', style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 6),
                    Text(
                      'The people building DesignSphere\'s future',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final member = _team[index];
                  final delay = index * 0.15;

                  return AnimatedBuilder(
                    animation: _ctrl,
                    builder: (context, child) {
                      final raw = ((_ctrl.value - delay) / 0.4).clamp(0.0, 1.0);
                      final fade = Curves.easeOut.transform(raw);
                      final slide = 1.0 - Curves.easeOutCubic.transform(raw);
                      return Opacity(
                        opacity: fade,
                        child: Transform.translate(
                          offset: Offset(0, 40 * slide),
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: TeamMemberCard(
                        name:        member['name']       as String,
                        role:        member['role']       as String,
                        speciality:  member['speciality'] as String,
                        initials:    member['initials']   as String,
                        color:       member['color']      as Color,
                        imagePath:   member['image']      as String,
                        bio:         member['bio']        as String,
                        skills:      List<String>.from(member['skills'] as List),
                      ),
                    ),
                  );
                },
                childCount: _team.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}