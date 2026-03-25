import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/model/app_item.dart';
import '../../core/theme/app_colors.dart';

class AppIcon extends StatefulWidget {
  final AppItem appItem;

  const AppIcon({super.key, required this.appItem});

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    // Play press animation
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 80));
    await _controller.reverse();

    // Open link
    final url = Uri.parse(widget.appItem.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor =
        isDark ? AppColors.darkIconLabel : AppColors.lightIconLabel;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (isDark
                            ? Colors.black
                            : Colors.grey.shade400)
                        .withValues(alpha: _isPressed ? 0.0 : 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildIcon(isDark),
              ),
            ),
            const SizedBox(height: 8),
            // Label
            SizedBox(
              width: 72,
              child: Text(
                widget.appItem.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(bool isDark) {
    if (widget.appItem.iconUrl.isNotEmpty) {
      return Image.network(
        widget.appItem.iconUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildDefaultIcon(isDark);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingIcon(isDark);
        },
      );
    }
    return _buildDefaultIcon(isDark);
  }

  Widget _buildDefaultIcon(bool isDark) {
    // Generate a unique gradient based on app name
    final hash = widget.appItem.name.hashCode;
    final colors = _getGradientColors(hash);

    IconData icon;
    if (widget.appItem.isResume) {
      icon = Icons.person_rounded;
    } else {
      final icons = [
        Icons.code_rounded,
        Icons.smartphone_rounded,
        Icons.cloud_rounded,
        Icons.palette_rounded,
        Icons.music_note_rounded,
        Icons.shopping_bag_rounded,
        Icons.chat_bubble_rounded,
        Icons.fitness_center_rounded,
        Icons.note_alt_rounded,
        Icons.camera_alt_rounded,
        Icons.rocket_launch_rounded,
        Icons.games_rounded,
      ];
      icon = icons[hash.abs() % icons.length];
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildLoadingIcon(bool isDark) {
    return Container(
      width: 56,
      height: 56,
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(int hash) {
    final gradients = [
      [const Color(0xFF667EEA), const Color(0xFF764BA2)],
      [const Color(0xFFF093FB), const Color(0xFFF5576C)],
      [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
      [const Color(0xFF43E97B), const Color(0xFF38F9D7)],
      [const Color(0xFFFA709A), const Color(0xFFFEE140)],
      [const Color(0xFFA18CD1), const Color(0xFFFBC2EB)],
      [const Color(0xFFFCCB90), const Color(0xFFD57EEB)],
      [const Color(0xFF13547A), const Color(0xFF80D0C7)],
      [const Color(0xFFFF9A9E), const Color(0xFFFECFEF)],
      [const Color(0xFF96FBC4), const Color(0xFFF9F586)],
      [const Color(0xFF0BA360), const Color(0xFF3CBA92)],
      [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)],
    ];
    return gradients[hash.abs() % gradients.length];
  }
}
