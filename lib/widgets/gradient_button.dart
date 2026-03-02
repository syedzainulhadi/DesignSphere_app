// lib/widgets/gradient_button.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_theme.dart';

class GradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isFullWidth;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = true,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onDown(_) { _ctrl.forward(); HapticFeedback.lightImpact(); }
  void _onUp(_)   { _ctrl.reverse(); widget.onPressed(); }
  void _onCancel(){ _ctrl.reverse(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   _onDown,
      onTapUp:     _onUp,
      onTapCancel: _onCancel,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: Container(
          width: widget.isFullWidth ? double.infinity : null,
          height: 54,
          decoration: BoxDecoration(
            gradient: AppTheme.brandGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            boxShadow: AppTheme.buttonGlow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (!widget.isFullWidth) const SizedBox(width: 20),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
              if (widget.icon != null) ...[
                const SizedBox(width: 8),
                Icon(widget.icon, color: Colors.white, size: 18),
              ],
              if (!widget.isFullWidth) const SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}