import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Border? border;
  final List<Color>? gradientColors;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 15,
    this.opacity = 0.08,
    this.borderRadius = 16,
    this.padding = const EdgeInsets.all(16),
    this.border,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDarkMode;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: gradientColors ?? (isDark 
                  ? [
                      const Color(0x1BFFFFFF),
                      const Color(0x05FFFFFF),
                    ]
                  : [
                      Colors.white.withOpacity(0.8),
                      Colors.white.withOpacity(0.4),
                    ]),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: border ?? Border.all(
              color: isDark 
                  ? Colors.white.withOpacity(0.1) 
                  : Colors.black.withOpacity(0.05),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
          ),
        ),
      );
  }
}
