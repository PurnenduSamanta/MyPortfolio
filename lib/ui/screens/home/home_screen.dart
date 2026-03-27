import 'package:flutter/material.dart';

import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/constants/app_durations.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';
import 'package:my_portfolio/core/theme/theme_provider.dart';
import 'package:my_portfolio/data/model/app_item.dart';
import 'package:my_portfolio/ui/screens/project_detail/project_detail_screen.dart';
import 'home_view_model.dart';
import 'widgets/app_grid.dart';
import 'widgets/dock_bar.dart';
import 'widgets/navigation_bar_widget.dart';
import 'widgets/notification_panel.dart';
import 'widgets/resume_widget.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/status_bar.dart';

class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const HomeScreen({super.key, required this.themeProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final HomeViewModel _viewModel = HomeViewModel();

  late AnimationController _notifController;
  late Animation<Offset> _notifSlide;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadApps();

    _notifController = AnimationController(
      vsync: this,
      duration: AppDurations.panel,
    );
    _notifSlide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _notifController, curve: Curves.easeOutQuart),
        );
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _notifController.dispose();
    super.dispose();
  }

  void _onSearch(String query) => _viewModel.onSearch(query);

  void _openProjectDetail(AppItem appItem) {
    final shouldCloseNotif = _viewModel.openProjectDetail(appItem);
    if (shouldCloseNotif) {
      _notifController.reverse();
    }
  }

  void _closeProjectDetail() {
    _viewModel.closeProjectDetail();
  }

  void _openNotif() {
    if (_viewModel.openNotif()) {
      _notifController.forward();
    }
  }

  void _closeNotif() {
    if (_viewModel.closeNotif()) {
      _notifController.reverse();
    }
  }

  void _onStatusBarDragStart(DragStartDetails details) {
    _viewModel.onStatusBarDragStart();
  }

  void _onStatusBarDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    if (_viewModel.onStatusBarDragUpdate(delta)) {
      _notifController.forward();
    }
  }

  void _onStatusBarDragEnd(DragEndDetails details) {
    _viewModel.onStatusBarDragEnd();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    return Container(
      color: bgColor,
      child: Stack(
        children: [
          if (!_viewModel.isDetailOpen)
            SafeArea(
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onVerticalDragStart: _onStatusBarDragStart,
                    onVerticalDragUpdate: _onStatusBarDragUpdate,
                    onVerticalDragEnd: _onStatusBarDragEnd,
                    onTap: _openNotif,
                    child: StatusBarWidget(
                      onNotificationTap: _openNotif,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SearchBarWidget(
                    controller: _searchController,
                    onSearch: _onSearch,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (!_viewModel.isLoading)
                    ResumeWidget(
                      resumeLink: _viewModel.resumeLink,
                      profileImageUrl: _viewModel.profileImageUrl,
                    ),
                  const SizedBox(height: AppSpacing.xs),
                  Expanded(
                    child: _viewModel.isLoading
                        ? _buildLoadingState(isDark)
                        : _viewModel.error != null
                        ? _buildErrorState(isDark)
                        : _viewModel.filteredApps.isEmpty
                        ? _buildEmptyState(isDark)
                        : RefreshIndicator(
                            onRefresh: _viewModel.loadApps,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                            child: AppGrid(
                              apps: _viewModel.filteredApps,
                              onAppTap: _openProjectDetail,
                            ),
                          ),
                  ),
                  DockBar(themeProvider: widget.themeProvider),
                  const NavigationBarWidget(),
                ],
              ),
            ),
          if (_viewModel.isDetailOpen)
            ProjectDetailScreen(
              appItem: _viewModel.activeProject!,
              onBack: _closeProjectDetail,
            ),
          if (!_viewModel.isDetailOpen)
            AnimatedBuilder(
              animation: _notifController,
              builder: (context, _) {
                final isVisible = _notifController.value > 0;
                if (!isVisible) {
                  return const SizedBox.shrink();
                }
                return IgnorePointer(
                  ignoring: !isVisible,
                  child: Opacity(
                    opacity: _notifController.value,
                    child: SlideTransition(
                      position: _notifSlide,
                      child: NotificationPanel(
                        onClose: _closeNotif,
                        resumeLink: _viewModel.resumeLink,
                        quoteText: _viewModel.quote?.text,
                        quoteAuthor: _viewModel.quote?.author,
                        quoteLoading: _viewModel.quoteLoading,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          Text(
            'Loading apps...',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkOnSurfaceVariant
                  : AppColors.lightOnSurfaceVariant,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: isDark
                ? AppColors.darkOnSurfaceVariant
                : AppColors.lightOnSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Failed to load apps',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkOnSurface
                  : AppColors.lightOnSurface,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextButton.icon(
            onPressed: _viewModel.loadApps,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.apps_rounded,
            size: 48,
            color: isDark
                ? AppColors.darkOnSurfaceVariant
                : AppColors.lightOnSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            _searchController.text.isNotEmpty
                ? 'No matching apps'
                : 'No apps installed',
            style: TextStyle(
              color: isDark
                  ? AppColors.darkOnSurface
                  : AppColors.lightOnSurface,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
