import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/constants/app_durations.dart';
import 'package:my_portfolio/core/constants/app_gradients.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';
import 'package:my_portfolio/data/model/app_item.dart';

class AppIcon extends StatefulWidget {
  final AppItem appItem;
  final ValueChanged<AppItem>? onTap;

  const AppIcon({super.key, required this.appItem, this.onTap});

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> {
  bool _isPressed = false;

  void _onTap() {
    widget.onTap?.call(widget.appItem);
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
        duration: AppDurations.ultraFast,
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
                        borderRadius: BorderRadius.circular(AppRadius.lg),
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
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: _buildIcon(isDark),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
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
          colors: AppGradients.resumeIcon,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
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
    return AppGradients.appIconPalettes[hash.abs() %
        AppGradients.appIconPalettes.length];
  }
}
