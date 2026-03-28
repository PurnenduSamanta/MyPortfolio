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

  static const _frameRadius = 44.0;
  static const _innerRadius = 42.0;
  static const _frameThickness = 3.0;

  @override
  Widget build(BuildContext context) {
    // Silver metallic frame colors
    final frameColor = isDark
        ? const Color(0xFF8A8D96)
        : const Color(0xFFC0C4CC);
    final frameHighlight = isDark
        ? const Color(0xFFAEB1B9)
        : const Color(0xFFE2E4E8);
    final frameShadowColor = isDark
        ? const Color(0xFF3A3D45)
        : const Color(0xFF8F929A);

    return SizedBox(
      // Extra width for side buttons
      width: AppSizes.phoneWidth + 20,
      height: AppSizes.phoneHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // === LEFT SIDE BUTTONS (Volume Up + Down) ===
          // Volume Up
          Positioned(
            left: 0,
            top: 160,
            child: _SideButton(
              isDark: isDark,
              height: 44,
              isLeft: true,
              frameColor: frameColor,
            ),
          ),
          // Volume Down
          Positioned(
            left: 0,
            top: 216,
            child: _SideButton(
              isDark: isDark,
              height: 44,
              isLeft: true,
              frameColor: frameColor,
            ),
          ),

          // === RIGHT SIDE BUTTON (Power) ===
          Positioned(
            right: 0,
            top: 190,
            child: _SideButton(
              isDark: isDark,
              height: 52,
              isLeft: false,
              frameColor: frameColor,
            ),
          ),

          // === PHONE BODY ===
          Center(
            child: Container(
              width: AppSizes.phoneWidth,
              height: AppSizes.phoneHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_frameRadius),
                // Metallic frame gradient (simulates edge bevel)
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    frameHighlight,
                    frameColor,
                    frameColor,
                    frameShadowColor,
                  ],
                  stops: const [0.0, 0.15, 0.85, 1.0],
                ),
                boxShadow: [
                  // Primary glow
                  BoxShadow(
                    color:
                        (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                            .withValues(alpha: 0.12),
                    blurRadius: 80,
                    spreadRadius: 8,
                  ),
                  // Bottom drop shadow (3D lift)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.55 : 0.22),
                    blurRadius: 40,
                    offset: const Offset(0, 16),
                  ),
                  // Tight shadow for depth
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                  // Left edge highlight
                  BoxShadow(
                    color: (isDark ? Colors.white : Colors.white)
                        .withValues(alpha: isDark ? 0.04 : 0.12),
                    blurRadius: 2,
                    offset: const Offset(-1, 0),
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(_frameThickness),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_innerRadius),
                  color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_innerRadius),
                  child: Stack(
                    children: [
                      // Screen content
                      AnimatedSwitcher(
                        duration: AppDurations.transition,
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: KeyedSubtree(
                          key: ValueKey<bool>(showingStartup),
                          child: content,
                        ),
                      ),

                      // Speaker Grill (top bezel)
                      Positioned(
                        top: 2,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 56,
                            height: 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.7)
                                  : Colors.black.withValues(alpha: 0.15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  10,
                                  (i) => Container(
                                    width: 1.5,
                                    height: 5,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 1.2,
                                    ),
                                    color: isDark
                                        ? Colors.grey.shade900
                                            .withValues(alpha: 0.6)
                                        : Colors.black
                                            .withValues(alpha: 0.08),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Dynamic Island (Notch) — clean pill, no camera
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
                          ),
                        ),
                      ),

                      // Top left screen reflection (3D shine)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(_innerRadius),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white
                                      .withValues(alpha: isDark ? 0.02 : 0.06),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Side button widget for volume and power buttons
class _SideButton extends StatelessWidget {
  final bool isDark;
  final double height;
  final bool isLeft;
  final Color frameColor;

  const _SideButton({
    required this.isDark,
    required this.height,
    required this.isLeft,
    required this.frameColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = 4.0;
    // Offset to overlap with the phone frame edge
    final edgeOffset = isLeft ? 7.0 : 7.0;

    return Transform.translate(
      offset: Offset(isLeft ? edgeOffset : -edgeOffset, 0),
      child: Container(
        width: buttonWidth,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(2.5) : Radius.zero,
            right: isLeft ? Radius.zero : const Radius.circular(2.5),
          ),
          gradient: LinearGradient(
            begin: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            end: isLeft ? Alignment.centerRight : Alignment.centerLeft,
            colors: [
              isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.5),
              frameColor,
              isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.1),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
              blurRadius: 3,
              offset: Offset(isLeft ? -1 : 1, 1),
            ),
          ],
        ),
      ),
    );
  }
}

