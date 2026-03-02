// lib/widgets/team_member_card.dart

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class TeamMemberCard extends StatefulWidget {
  final String name;
  final String role;
  final String speciality;
  final String initials;
  final Color color;
  final String imagePath;
  final String bio;
  final List<String> skills;

  const TeamMemberCard({
    super.key,
    required this.name,
    required this.role,
    required this.speciality,
    required this.initials,
    required this.color,
    required this.imagePath,
    required this.bio,
    required this.skills,
  });

  @override
  State<TeamMemberCard> createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<TeamMemberCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return GestureDetector(
      onTapDown: (_) => _hoverCtrl.forward(),
      onTapUp:   (_) => _hoverCtrl.reverse(),
      onTapCancel: () => _hoverCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _hoverCtrl,
        builder: (context, child) => Transform.scale(
          scale: 1.0 - (_hoverCtrl.value * 0.012),
          child: child,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(isDark ? 0.25 : 0.14),
                blurRadius: 28,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
            child: Stack(
              children: [
                // ── Full card background ───────────────────────────────────────
                Container(color: colors.cardBg),

                // ── Colour accent strip — left edge ───────────────────────────
                Positioned(
                  left: 0, top: 0, bottom: 0,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.color, widget.color.withOpacity(0.4)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // ── Subtle background glow ─────────────────────────────────────
                Positioned(
                  right: -40, top: -40,
                  child: Container(
                    width: 140, height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withOpacity(isDark ? 0.07 : 0.04),
                    ),
                  ),
                ),

                // ── Main content ──────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: avatar + name block
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          Stack(
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      widget.color,
                                      widget.color.withOpacity(0.6)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.color.withOpacity(0.4),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    widget.imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Center(
                                      child: Text(
                                        widget.initials,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Online indicator dot
                              Positioned(
                                right: 2, bottom: 2,
                                child: Container(
                                  width: 14, height: 14,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.green,
                                    border: Border.all(
                                      color: colors.cardBg, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 14),

                          // Name + role + speciality
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(letterSpacing: -0.3),
                                ),
                                const SizedBox(height: 5),
                                // Role pill
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        widget.color.withOpacity(isDark ? 0.28 : 0.14),
                                        widget.color.withOpacity(isDark ? 0.12 : 0.06),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: widget.color
                                          .withOpacity(isDark ? 0.4 : 0.22),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    widget.role,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: widget.color,
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                // Speciality
                                Row(
                                  children: [
                                    Icon(Icons.code_rounded,
                                        size: 13, color: colors.textHint),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        widget.speciality,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: colors.textSub,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Thin divider
                      Container(
                        height: 0.5,
                        color: colors.divider,
                      ),

                      const SizedBox(height: 14),

                      // Bio
                      Text(
                        widget.bio,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              height: 1.65,
                              color: colors.textSub,
                            ),
                      ),

                      const SizedBox(height: 14),

                      // Skills row
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: widget.skills.map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? colors.cardBg2
                                  : const Color(0xFFF0EFFF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: colors.divider, width: 0.5),
                            ),
                            child: Text(
                              skill,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: widget.color,
                              ),
                            ),
                          );
                        }).toList(),
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
}