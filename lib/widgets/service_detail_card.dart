// lib/widgets/service_detail_card.dart

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class ServiceDetailCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final List<String> tags;

  const ServiceDetailCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark  = colors.isDark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: color.withOpacity(isDark ? 0.2 : 0.1),
          width: 1,
        ),
        boxShadow: colors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.65),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(isDark ? 0.14 : 0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: color.withOpacity(isDark ? 0.3 : 0.18),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600,
                    color: color, letterSpacing: 0.1,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}