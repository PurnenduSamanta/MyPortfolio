import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_links.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';

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
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkDock : AppColors.lightDock).withValues(
          alpha: 0.85,
        ),
        borderRadius: BorderRadius.circular(28),
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
            icon: Icons.code_rounded,
            label: 'GitHub',
            isDark: isDark,
            onTap: () => _openLink(AppLinks.github),
          ),
          _DockIcon(
            icon: Icons.email_rounded,
            label: 'Email',
            isDark: isDark,
            onTap: () => _openLink(AppLinks.email),
          ),
          _ThemeToggleIcon(themeProvider: themeProvider, isDark: isDark),
          _DockIcon(
            icon: Icons.link_rounded,
            label: 'LinkedIn',
            isDark: isDark,
            onTap: () => _openLink(AppLinks.linkedIn),
          ),
          _DockIcon(
            icon: Icons.play_circle_fill_rounded,
            label: 'Play',
            isDark: isDark,
            onTap: () => _openLink(AppLinks.googlePlayConsole),
          ),
        ],
      ),
    );
  }
}

class _DockIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _DockIcon({
    required this.icon,
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
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
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
            child: Icon(
              widget.icon,
              color: widget.isDark
                  ? AppColors.darkOnSurface
                  : AppColors.lightOnSurface,
              size: 22,
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
      duration: const Duration(milliseconds: 350),
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
                    ? [const Color(0xFF667EEA), const Color(0xFF764BA2)]
                    : [const Color(0xFFF093FB), const Color(0xFFF5576C)],
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
