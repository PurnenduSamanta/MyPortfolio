import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/constants/app_gradients.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';
import 'package:my_portfolio/data/model/app_item.dart';
import 'package:my_portfolio/ui/screens/project_detail/project_detail_view_model.dart';

class ProjectDetailTopBar extends StatelessWidget {
  final AppItem appItem;
  final bool isDark;
  final VoidCallback onBack;
  final VoidCallback onOpenProject;

  const ProjectDetailTopBar({
    super.key,
    required this.appItem,
    required this.isDark,
    required this.onBack,
    required this.onOpenProject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xxs,
        AppSpacing.lg,
        AppSpacing.xxs,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: isDark
                  ? AppColors.darkOnSurface
                  : AppColors.lightOnSurface,
            ),
          ),
          const SizedBox(width: AppSpacing.xxs),
          ProjectAppIcon(appItem: appItem, size: 22),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              appItem.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkOnSurface
                    : AppColors.lightOnSurface,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.09)
                  : Colors.black.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(AppRadius.pill),
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.black12,
              ),
            ),
            child: Text(
              'Preview',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkOnSurface.withValues(alpha: 0.86)
                    : AppColors.lightOnSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            tooltip: 'Open project',
            onPressed: onOpenProject,
            icon: Icon(
              Icons.open_in_new_rounded,
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectHeroCard extends StatelessWidget {
  final AppItem appItem;
  final bool isDark;
  final String summary;
  final String state;

  const ProjectHeroCard({
    super.key,
    required this.appItem,
    required this.isDark,
    required this.summary,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xxl - AppSpacing.xxs),
        color: isDark
            ? Colors.white.withValues(alpha: 0.06)
            : Colors.white.withValues(alpha: 0.88),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.black12,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.accentBlueSoft)
                .withValues(alpha: isDark ? 0.2 : 0.1),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.white.withValues(alpha: 0.6),
            ),
            child: Center(child: ProjectAppIcon(appItem: appItem, size: 54)),
          ),
          const SizedBox(width: AppSpacing.xxl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  summary,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkOnSurface
                        : AppColors.lightOnSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  state,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkPrimary.withValues(alpha: 0.92)
                        : AppColors.lightPrimary.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectSectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;

  const ProjectSectionTitle({
    super.key,
    required this.title,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
      ),
    );
  }
}

class ProjectSectionCard extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const ProjectSectionCard({
    super.key,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.83),
        border: Border.all(color: isDark ? Colors.white12 : Colors.black12),
      ),
      child: child,
    );
  }
}

class ProjectTechChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const ProjectTechChip({super.key, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.white.withValues(alpha: 0.7),
        border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
        ),
      ),
    );
  }
}

class ProjectAppIcon extends StatelessWidget {
  final AppItem appItem;
  final double size;

  const ProjectAppIcon({super.key, required this.appItem, required this.size});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (appItem.isResume) {
      return _resumeIcon(size);
    }

    if (appItem.iconUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular((size * 0.28).clamp(12, 18)),
        child: Image.network(
          appItem.iconUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _fallbackIcon(isDark),
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return _loadingIcon(isDark);
          },
        ),
      );
    }

    return _fallbackIcon(isDark);
  }

  Widget _resumeIcon(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((size * 0.28).clamp(12, 18)),
        gradient: const LinearGradient(
          colors: AppGradients.resumeIcon,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Icon(
        Icons.description_rounded,
        color: Colors.white,
        size: size * 0.42,
      ),
    );
  }

  Widget _loadingIcon(bool isDark) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((size * 0.28).clamp(12, 18)),
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.34,
          height: size * 0.34,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          ),
        ),
      ),
    );
  }

  Widget _fallbackIcon(bool isDark) {
    final colors = _getGradientColors(appItem.name.hashCode);
    final icons = [
      Icons.code_rounded,
      Icons.smartphone_rounded,
      Icons.cloud_rounded,
      Icons.palette_rounded,
      Icons.music_note_rounded,
      Icons.shopping_bag_rounded,
      Icons.chat_bubble_rounded,
      Icons.rocket_launch_rounded,
      Icons.games_rounded,
    ];
    final icon = icons[appItem.name.hashCode.abs() % icons.length];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((size * 0.28).clamp(12, 18)),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : colors.first).withValues(
              alpha: 0.18,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.44),
    );
  }
}

class ProjectActionBar extends StatelessWidget {
  final AppItem appItem;
  final bool isDark;
  final VoidCallback onOpenProject;

  const ProjectActionBar({
    super.key,
    required this.appItem,
    required this.isDark,
    required this.onOpenProject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xxxl,
        AppSpacing.lg,
        AppSpacing.xxxl,
        AppSpacing.sm,
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onOpenProject,
          icon: const Icon(Icons.rocket_launch_rounded, size: 18),
          label: const Text('Open Actual Project'),
          style: FilledButton.styleFrom(
            backgroundColor: isDark
                ? AppColors.darkPrimary
                : AppColors.lightPrimary,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      ),
    );
  }
}

List<Color> _getGradientColors(int hash) {
  return AppGradients.appIconPalettes[hash.abs() %
      AppGradients.appIconPalettes.length];
}

Widget buildProjectHighlights({
  required bool isDark,
  required ProjectDetailData detail,
}) {
  return Column(
    children: detail.highlights.map((item) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.accentBlue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                item,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark
                      ? AppColors.darkOnSurface.withValues(alpha: 0.8)
                      : AppColors.lightOnSurface.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList(),
  );
}
