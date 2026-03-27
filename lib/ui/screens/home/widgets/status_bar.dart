import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';

class StatusBarWidget extends StatelessWidget {
  final VoidCallback? onNotificationTap;

  const StatusBarWidget({super.key, this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.darkOnSurface
        : AppColors.lightOnSurface;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.page,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Time
          Text(
            _getFormattedTime(),
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          // Status icons
          Row(
            children: [
              GestureDetector(
                onTap: onNotificationTap,
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxs,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: textColor,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              // Signal
              Icon(Icons.signal_cellular_alt, color: textColor, size: 16),
              const SizedBox(width: AppSpacing.sm),
              // WiFi
              Icon(Icons.wifi, color: textColor, size: 16),
              const SizedBox(width: AppSpacing.sm),
              // Battery
              Icon(Icons.battery_std, color: textColor, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  String _getFormattedTime() {
    final now = DateTime.now();
    final hour = now.hour > 12
        ? now.hour - 12
        : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
