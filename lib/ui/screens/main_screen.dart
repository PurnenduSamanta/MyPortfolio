import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import 'home_screen.dart';

class MainScreen extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MainScreen({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;

        if (isDesktop) {
          return _DesktopLayout(themeProvider: themeProvider);
        } else {
          return Scaffold(
            body: HomeScreen(themeProvider: themeProvider),
          );
        }
      },
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final ThemeProvider themeProvider;

  const _DesktopLayout({required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF0A0B14),
                    const Color(0xFF13142A),
                    const Color(0xFF1A1040),
                    const Color(0xFF0F1118),
                  ]
                : [
                    const Color(0xFFE8EAFE),
                    const Color(0xFFF0E6FF),
                    const Color(0xFFE6F0FF),
                    const Color(0xFFF5F0FF),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background orbs
            _BackgroundOrbs(isDark: isDark),

            // Phone frame centered
            Center(
              child: _PhoneFrame(
                isDark: isDark,
                themeProvider: themeProvider,
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
      duration: const Duration(seconds: 20),
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

    // Orb 1
    paint.color = (isDark
            ? const Color(0xFF6366F1)
            : const Color(0xFF818CF8))
        .withValues(alpha: isDark ? 0.08 : 0.12);
    final x1 = size.width * 0.2 + math.sin(progress * 2 * math.pi) * 40;
    final y1 = size.height * 0.3 + math.cos(progress * 2 * math.pi) * 30;
    canvas.drawCircle(Offset(x1, y1), 120, paint);

    // Orb 2
    paint.color = (isDark
            ? const Color(0xFFA78BFA)
            : const Color(0xFFC4B5FD))
        .withValues(alpha: isDark ? 0.06 : 0.10);
    final x2 =
        size.width * 0.8 + math.cos(progress * 2 * math.pi + 1) * 50;
    final y2 =
        size.height * 0.6 + math.sin(progress * 2 * math.pi + 1) * 40;
    canvas.drawCircle(Offset(x2, y2), 150, paint);

    // Orb 3
    paint.color = (isDark
            ? const Color(0xFF22D3EE)
            : const Color(0xFF67E8F9))
        .withValues(alpha: isDark ? 0.05 : 0.08);
    final x3 =
        size.width * 0.5 + math.sin(progress * 2 * math.pi + 2.5) * 35;
    final y3 =
        size.height * 0.8 + math.cos(progress * 2 * math.pi + 2.5) * 25;
    canvas.drawCircle(Offset(x3, y3), 100, paint);
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

class _PhoneFrame extends StatelessWidget {
  final bool isDark;
  final ThemeProvider themeProvider;

  const _PhoneFrame({required this.isDark, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 780,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(44),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.black.withValues(alpha: 0.08),
          width: 2,
        ),
        boxShadow: [
          // Outer glow
          BoxShadow(
            color: (isDark
                    ? AppColors.darkPrimary
                    : AppColors.lightPrimary)
                .withValues(alpha: 0.15),
            blurRadius: 60,
            spreadRadius: 5,
          ),
          // Deep shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          // Inner ambient
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
            // Home screen content
            HomeScreen(themeProvider: themeProvider),

            // Notch / Dynamic Island
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 100,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
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
