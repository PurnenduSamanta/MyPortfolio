import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/constants/app_durations.dart';
import 'package:my_portfolio/core/constants/app_gradients.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';

class MainDesktopLayout extends StatelessWidget {
  final Widget content;
  final bool showingStartup;

  const MainDesktopLayout({
    super.key,
    required this.content,
    required this.showingStartup,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? AppGradients.desktopBackgroundDark
                : AppGradients.desktopBackgroundLight,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            _BackgroundOrbs(isDark: isDark),
            Center(
              child: MainPhoneFrame(
                isDark: isDark,
                content: content,
                showingStartup: showingStartup,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundOrbs extends StatefulWidget {
  final bool isDark;

  const _BackgroundOrbs({required this.isDark});

  @override
  State<_BackgroundOrbs> createState() => _BackgroundOrbsState();
}

class _BackgroundOrbsState extends State<_BackgroundOrbs>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.backgroundLoop,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _OrbPainter(
            progress: _controller.value,
            isDark: widget.isDark,
          ),
        );
      },
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _OrbPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = (isDark ? AppColors.lightPrimary : AppColors.darkPrimary)
        .withValues(alpha: isDark ? 0.08 : 0.12);
    final x1 = size.width * 0.2 + math.sin(progress * 2 * math.pi) * 40;
    final y1 = size.height * 0.3 + math.cos(progress * 2 * math.pi) * 30;
    canvas.drawCircle(Offset(x1, y1), 120, paint);

    paint.color =
        (isDark ? AppColors.accentVioletSoft : AppColors.accentVioletPastel)
            .withValues(alpha: isDark ? 0.06 : 0.10);
    final x2 = size.width * 0.8 + math.cos(progress * 2 * math.pi + 1) * 50;
    final y2 = size.height * 0.6 + math.sin(progress * 2 * math.pi + 1) * 40;
    canvas.drawCircle(Offset(x2, y2), 150, paint);

    paint.color = (isDark ? AppColors.accentCyan : AppColors.accentCyanSoft)
        .withValues(alpha: isDark ? 0.05 : 0.08);
    final x3 = size.width * 0.5 + math.sin(progress * 2 * math.pi + 2.5) * 35;
    final y3 = size.height * 0.8 + math.cos(progress * 2 * math.pi + 2.5) * 25;
    canvas.drawCircle(Offset(x3, y3), 100, paint);
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

class MainPhoneFrame extends StatelessWidget {
  final bool isDark;
  final Widget content;
  final bool showingStartup;

  const MainPhoneFrame({
    super.key,
    required this.isDark,
    required this.content,
    required this.showingStartup,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.phoneWidth,
      height: AppSizes.phoneHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(44),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.08),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                .withValues(alpha: 0.15),
            blurRadius: 60,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(42),
        child: Stack(
          children: [
            AnimatedSwitcher(
              duration: AppDurations.transition,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey<bool>(showingStartup),
                child: content,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: AppSpacing.lg),
                  width: 100,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade800,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
