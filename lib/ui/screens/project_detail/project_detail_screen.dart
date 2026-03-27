import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/constants/app_gradients.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';
import 'package:my_portfolio/data/model/app_item.dart';
import 'package:my_portfolio/ui/screens/project_detail/widgets/project_detail_components.dart';
import 'package:my_portfolio/ui/screens/project_detail/widgets/project_navigation_bar_widget.dart';
import 'package:my_portfolio/ui/screens/project_detail/widgets/project_status_bar_widget.dart';
import 'project_detail_view_model.dart';

class ProjectDetailScreen extends StatelessWidget {
  final AppItem appItem;
  final VoidCallback onBack;

  const ProjectDetailScreen({
    super.key,
    required this.appItem,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final viewModel = ProjectDetailViewModel(appItem: appItem);
    final detail = viewModel.detail;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? AppGradients.projectDetailBackgroundDark
              : AppGradients.projectDetailBackgroundLight,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const ProjectStatusBarWidget(),
            ProjectDetailTopBar(
              appItem: appItem,
              isDark: isDark,
              onBack: onBack,
              onOpenProject: () => viewModel.openProject(),
              stateBadge: detail.state.contains('Live') ? 'Live' : 'Preview',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.xxl,
                  AppSpacing.page,
                  AppSpacing.page,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProjectHeroCard(
                      appItem: appItem,
                      isDark: isDark,
                      summary: detail.summary,
                      state: detail.state,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    ProjectSectionTitle(title: 'Overview', isDark: isDark),
                    const SizedBox(height: AppSpacing.md),
                    ProjectSectionCard(
                      isDark: isDark,
                      child: Text(
                        detail.description,
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.45,
                          color: isDark
                              ? AppColors.darkOnSurface.withValues(alpha: 0.82)
                              : AppColors.lightOnSurface.withValues(
                                  alpha: 0.76,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    ProjectSectionTitle(title: 'Tech Stack', isDark: isDark),
                    const SizedBox(height: AppSpacing.lg),
                    ProjectSectionCard(
                      isDark: isDark,
                      child: Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: detail.techStack
                            .map(
                              (tech) =>
                                  ProjectTechChip(label: tech, isDark: isDark),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    ProjectSectionTitle(title: 'Highlights', isDark: isDark),
                    const SizedBox(height: AppSpacing.md),
                    ProjectSectionCard(
                      isDark: isDark,
                      child: buildProjectHighlights(
                        isDark: isDark,
                        detail: detail,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ProjectActionBar(
              appItem: appItem,
              isDark: isDark,
              onOpenProject: () => viewModel.openProject(),
            ),
            const ProjectNavigationBarWidget(),
          ],
        ),
      ),
    );
  }
}
