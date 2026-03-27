import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/constants/app_durations.dart';
import 'package:my_portfolio/core/constants/app_gradients.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';

class BootView extends StatelessWidget {
  static const String _defaultProfileImagePath = 'profile/purnendu.jpg';
  final Animation<double> progress;
  final String? imageUrl;

  const BootView({super.key, required this.progress, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final p = progress.value.clamp(0.0, 1.0);
        final statusText = _statusText(p);
        final dotCount = ((p * 18).floor() % 4) + 1;
        final dots = '.' * dotCount;
        final percent = (p * 100).round();

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? AppGradients.bootBackgroundDark
                  : AppGradients.bootBackgroundLight,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _BootStreaksPainter(progress: p, isDark: isDark),
                ),
              ),
              Positioned(
                top: -120,
                right: -80,
                child: _GlowOrb(
                  size: 280,
                  color: AppColors.accentBlueSoft.withValues(
                    alpha: isDark ? 0.20 : 0.17,
                  ),
                ),
              ),
              Positioned(
                bottom: -140,
                left: -70,
                child: _GlowOrb(
                  size: 300,
                  color: AppColors.accentTealSoft.withValues(
                    alpha: isDark ? 0.15 : 0.13,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _BootAvatar(
                          progress: p,
                          imagePath: imageUrl ?? _defaultProfileImagePath,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Text(
                          'Hi👏, I am Purnendu Samanta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkOnSurface
                                : AppColors.lightOnSurface,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Mobile app developer with 3+ years of experience.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.35,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkOnSurface.withValues(alpha: 0.8)
                                : AppColors.lightOnSurface.withValues(
                                    alpha: 0.72,
                                  ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl + AppSpacing.md),
                        _BootProgress(isDark: isDark, progress: p),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$statusText$dots',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 0.6,
                                color: isDark
                                    ? AppColors.darkOnSurface.withValues(
                                        alpha: 0.65,
                                      )
                                    : AppColors.lightOnSurface.withValues(
                                        alpha: 0.58,
                                      ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white10
                                    : Colors.black.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.pill,
                                ),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.black12,
                                ),
                              ),
                              child: Text(
                                '$percent%',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? AppColors.darkOnSurface.withValues(
                                          alpha: 0.78,
                                        )
                                      : AppColors.lightOnSurface.withValues(
                                          alpha: 0.7,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _statusText(double progress) {
    if (progress < 0.33) return 'Booting system modules';
    if (progress < 0.67) return 'Loading launcher experience';
    return 'Preparing home screen';
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: size * 0.4,
              spreadRadius: size * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}

class _BootStreaksPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _BootStreaksPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final streakPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final baseAlpha = isDark ? 0.15 : 0.10;
    for (int i = 0; i < 6; i++) {
      final offset = (progress + i * 0.18) % 1;
      final y = size.height * offset;
      final xStart = -40 + math.sin((progress + i) * math.pi * 2) * 30;
      final xEnd = size.width * 0.52 + i * 12;
      streakPaint
        ..strokeWidth = 1.6 + (i % 2) * 0.5
        ..color = AppColors.accentBlueSoft.withValues(
          alpha: baseAlpha - (i * 0.015),
        );
      canvas.drawLine(Offset(xStart, y), Offset(xEnd, y - 36), streakPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BootStreaksPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

class _BootAvatar extends StatelessWidget {
  static const Duration _fadeInDuration = Duration(milliseconds: 800);
  final double progress;
  final String imagePath;

  const _BootAvatar({required this.progress, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spin = progress * 6.283185307179586;
    final glowOpacity = 0.38 + (progress * 0.45);
    final pulse = 1 + (math.sin(progress * math.pi * 8) * 0.04);

    return SizedBox(
      width: 178,
      height: 178,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: pulse,
            child: Container(
              width: 168,
              height: 168,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentBlueSoft.withValues(
                    alpha: isDark ? 0.30 : 0.22,
                  ),
                  width: 1.4,
                ),
              ),
            ),
          ),
          Transform.rotate(
            angle: spin,
            child: Container(
              width: 156,
              height: 156,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    AppColors.accentBlue.withValues(alpha: glowOpacity),
                    AppColors.accentTeal.withValues(alpha: glowOpacity),
                    AppColors.accentBlue.withValues(alpha: glowOpacity),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentBlue.withValues(
                      alpha: isDark ? 0.34 : 0.24,
                    ),
                    blurRadius: 26,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          Transform.rotate(
            angle: -spin * 0.74,
            child: Container(
              width: 146,
              height: 146,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accentTeal.withValues(
                    alpha: isDark ? 0.44 : 0.32,
                  ),
                  width: 1.1,
                ),
              ),
            ),
          ),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? AppColors.bootAvatarBackgroundDark : Colors.white,
            ),
          ),
          ClipOval(
            child: SizedBox(
              width: 130,
              height: 130,
              child: Image.network(
                imagePath,
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame != null ? 1.0 : 0.0,
                    duration: _fadeInDuration,
                    curve: Curves.easeIn,
                    child: child,
                  );
                },
                errorBuilder: (context, _, _) => Container(
                  color: isDark
                      ? AppColors.bootAvatarFallbackDark
                      : AppColors.bootAvatarFallbackLight,
                  child: Icon(
                    Icons.person_rounded,
                    size: 62,
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary.withValues(alpha: 0.8),
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

class _BootProgress extends StatelessWidget {
  final bool isDark;
  final double progress;

  const _BootProgress({required this.isDark, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 286,
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.10),
        border: Border.all(
          color: isDark ? Colors.white24 : Colors.black12,
          width: 0.8,
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedContainer(
          duration: AppDurations.normal,
          curve: Curves.easeOut,
          width: 286 * progress,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            gradient: LinearGradient(
              colors: [
                AppColors.accentBlue,
                AppColors.accentTealSoft,
                AppColors.accentBlue.withValues(alpha: 0.95),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentBlue.withValues(alpha: 0.35),
                blurRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
