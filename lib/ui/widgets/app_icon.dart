import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/model/app_item.dart';
import '../../core/theme/app_colors.dart';

class AppIcon extends StatefulWidget {
  final AppItem appItem;

  const AppIcon({super.key, required this.appItem});

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> {
  bool _isPressed = false;

  Future<void> _onTap() async {
    final url = Uri.parse(widget.appItem.link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? AppColors.darkIconLabel
        : AppColors.lightIconLabel;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        scale: _isPressed ? 0.92 : 1.0,
        child: Center(
          child: ClipRect(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 72,
                height: 84,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: kIsWeb
                            ? const []
                            : [
                                BoxShadow(
                                  color:
                                      (isDark
                                              ? Colors.black
                                              : Colors.grey.shade400)
                                          .withValues(
                                            alpha: _isPressed ? 0.0 : 0.15,
                                          ),
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(bool isDark) {
    if (widget.appItem.isResume) {
      return _buildResumeIcon();
    }

    if (widget.appItem.iconUrl.isNotEmpty) {
      return Image.network(
        widget.appItem.iconUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
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
    const iconSize = 28.0;
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
      child: Icon(icon, color: Colors.white, size: iconSize),
    );
  }

  Widget _buildResumeIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(6),
        child: Icon(Icons.description_rounded, color: Colors.white, size: 18),
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
