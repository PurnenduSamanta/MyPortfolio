import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';

class ResumeWidget extends StatefulWidget {
  final String resumeLink;

  const ResumeWidget({super.key, required this.resumeLink});

  @override
  State<ResumeWidget> createState() => _ResumeWidgetState();
}

class _ResumeWidgetState extends State<ResumeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openResume() async {
    final uri = Uri.parse(widget.resumeLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _controller.reverse();
          _openResume();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        child: AnimatedBuilder(
          animation: _scale,
          builder: (context, child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurface.withValues(alpha: 0.7)
                  : AppColors.lightSurface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: (isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary)
                    .withValues(alpha: _isPressed ? 0.4 : 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: (isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary)
                      .withValues(alpha: _isPressed ? 0.12 : 0.05),
                  blurRadius: _isPressed ? 16 : 8,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Resume Icon with gradient background
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [const Color(0xFF6366F1), const Color(0xFF818CF8)]
                          : [const Color(0xFF818CF8), const Color(0xFFA78BFA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 14),

                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Purnendu Samanta',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darkOnSurface
                              : AppColors.lightOnSurface,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Android Developer · View Resume',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkPrimary.withValues(alpha: 0.9)
                              : AppColors.lightPrimary.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow indicator
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: (isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary)
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_outward_rounded,
                    size: 16,
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
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
