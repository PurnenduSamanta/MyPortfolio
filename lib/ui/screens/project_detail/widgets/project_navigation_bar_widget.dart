import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';

class ProjectNavigationBarWidget extends StatelessWidget {
  const ProjectNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(bottom: AppSpacing.md, top: AppSpacing.xs),
      child: Center(
        child: Container(
          width: 120,
          height: 4,
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withValues(
              alpha: 0.3,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
