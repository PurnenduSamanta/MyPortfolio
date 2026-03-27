import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';

class ProjectStatusBarWidget extends StatelessWidget {
  const ProjectStatusBarWidget({super.key});

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
          Text(
            _getFormattedTime(),
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
          Row(
            children: [
              Icon(Icons.signal_cellular_alt, color: textColor, size: 16),
              const SizedBox(width: AppSpacing.sm),
              Icon(Icons.wifi, color: textColor, size: 16),
              const SizedBox(width: AppSpacing.sm),
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
