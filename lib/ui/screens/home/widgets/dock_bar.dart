import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/constants/app_durations.dart';
import 'package:my_portfolio/core/constants/app_gradients.dart';
import 'package:my_portfolio/core/constants/app_links.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';
import 'package:my_portfolio/core/theme/theme_provider.dart';

class DockBar extends StatelessWidget {
  final ThemeProvider themeProvider;

  const DockBar({super.key, required this.themeProvider});

  Future<void> _openLink(String link) async {
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenHorizontal,
        vertical: AppSpacing.lg,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.page,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkDock : AppColors.lightDock).withValues(
          alpha: 0.85,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl + AppSpacing.xs),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _DockIcon(
            iconData: FontAwesomeIcons.github,
            iconSize: 20,
            label: 'GitHub',
            isDark: isDark,
            onTap: () => _openLink(AppLinks.github),
          ),
          _DockIcon(
            iconData: FontAwesomeIcons.linkedinIn,
            iconSize: 18,
            label: 'LinkedIn',
            isDark: isDark,
            onTap: () => _openLink(AppLinks.linkedIn),
          ),
          _ThemeToggleIcon(themeProvider: themeProvider, isDark: isDark),
          _DockIcon(
            iconData: FontAwesomeIcons.envelope,
            iconSize: 18,
            label: 'Email',
            isDark: isDark,
            onTap: () => _openLink(AppLinks.email),
          ),
          _DockIcon(
            iconData: FontAwesomeIcons.googlePlay,
            iconSize: 18,
            label: 'Play Store',
            isDark: isDark,
            onTap: () => _openLink(AppLinks.googlePlayConsole),
          ),
        ],
      ),
    );
  }
}

class _DockIcon extends StatefulWidget {
  final IconData iconData;
  final double iconSize;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _DockIcon({
    required this.iconData,
    required this.iconSize,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_DockIcon> createState() => _DockIconState();
}

class _DockIconState extends State<_DockIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: AppDurations.fast, vsync: this);
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Tooltip(
          message: widget.label,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (widget.isDark ? Colors.white : Colors.black).withValues(
                alpha: 0.08,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: FaIcon(
                widget.iconData,
                size: widget.iconSize,
                color: widget.isDark
                    ? AppColors.darkOnSurface
                    : AppColors.lightOnSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeToggleIcon extends StatefulWidget {
  final ThemeProvider themeProvider;
  final bool isDark;

  const _ThemeToggleIcon({required this.themeProvider, required this.isDark});

  @override
  State<_ThemeToggleIcon> createState() => _ThemeToggleIconState();
}

class _ThemeToggleIconState extends State<_ThemeToggleIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.transition,
      vsync: this,
    );
    _rotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.themeProvider.toggleTheme();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: Transform.rotate(
              angle: _rotation.value * 3.14159,
              child: child,
            ),
          );
        },
        child: Tooltip(
          message: widget.isDark ? 'Light Mode' : 'Dark Mode',
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.isDark
                    ? AppGradients.themeToggleDark
                    : AppGradients.themeToggleLight,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              widget.isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
