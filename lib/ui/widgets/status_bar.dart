import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusBarWidget extends StatelessWidget {
  const StatusBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
              // Signal
              Icon(Icons.signal_cellular_alt, color: textColor, size: 16),
              const SizedBox(width: 6),
              // WiFi
              Icon(Icons.wifi, color: textColor, size: 16),
              const SizedBox(width: 6),
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
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
