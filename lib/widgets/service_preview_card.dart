// lib/widgets/service_preview_card.dart

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class ServicePreviewCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final int animDelay;
  final VoidCallback? onExploreTap;

  const ServicePreviewCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    this.animDelay = 0,
    this.onExploreTap,
  });

  @override
  State<ServicePreviewCard> createState() => _ServicePreviewCardState();
}

class _ServicePreviewCardState extends State<ServicePreviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _press;
  bool _down = false;

  @override
  void initState() {
    super.initState();
    _press = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = colors.isDark;

    return GestureDetector(
      onTapDown: (_) {
        _press.forward();
        setState(() => _down = true);
      },
      onTapUp: (_) {
        _press.reverse();
        setState(() => _down = false);
        widget.onExploreTap?.call();
      },
      onTapCancel: () {
        _press.reverse();
        setState(() => _down = false);
      },
      child: AnimatedBuilder(
        animation: _press,
        builder: (context, child) => Transform.scale(
          scale: 1.0 - (_press.value * 0.04),
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(
              color: _down
                  ? widget.color.withOpacity(0.5)
                  : widget.color.withOpacity(isDark ? 0.18 : 0.1),
              width: 1,
            ),
            boxShadow: _down
                ? [
                    BoxShadow(
                        color: widget.color.withOpacity(0.2),
                        blurRadius: 14,
                        offset: const Offset(0, 4))
                  ]
                : colors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.color.withOpacity(isDark ? 0.25 : 0.15),
                      widget.color.withOpacity(isDark ? 0.1 : 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: widget.color.withOpacity(isDark ? 0.25 : 0.15),
                    width: 0.5,
                  ),
                ),
                child: Icon(widget.icon, color: widget.color, size: 20),
              ),
              const Spacer(),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  height: 1.3,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: widget.color,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(Icons.arrow_forward_rounded,
                      size: 11, color: widget.color),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}