import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../data/model/app_item.dart';
import '../../data/repository/app_repository.dart';
import '../widgets/status_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/app_grid.dart';
import '../widgets/dock_bar.dart';
import '../widgets/navigation_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const HomeScreen({super.key, required this.themeProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppRepository _repository = AppRepository();
  late Future<List<AppItem>> _appsFuture;

  @override
  void initState() {
    super.initState();
    _appsFuture = _repository.getApps();
  }

  Future<void> _refresh() async {
    _repository.clearCache();
    setState(() {
      _appsFuture = _repository.getApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBackground : AppColors.lightBackground;

    return Container(
      color: bgColor,
      child: SafeArea(
        child: Column(
          children: [
            // Status Bar
            const StatusBarWidget(),

            const SizedBox(height: 8),

            // Search Bar
            const SearchBarWidget(),

            const SizedBox(height: 8),

            // App Grid (expandable)
            Expanded(
              child: FutureBuilder<List<AppItem>>(
                future: _appsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingState(isDark);
                  }
                  if (snapshot.hasError) {
                    return _buildErrorState(isDark);
                  }
                  final apps = snapshot.data ?? [];
                  if (apps.isEmpty) {
                    return _buildEmptyState(isDark);
                  }
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    color: isDark
                        ? AppColors.darkPrimary
                        : AppColors.lightPrimary,
                    child: AppGrid(apps: apps),
                  );
                },
              ),
            ),

            // Dock Bar
            DockBar(themeProvider: widget.themeProvider),

            // Navigation Bar
            const NavigationBarWidget(),
          ],
        ),
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
          const SizedBox(height: 16),
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
          const SizedBox(height: 12),
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
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _refresh,
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
          const SizedBox(height: 12),
          Text(
            'No apps installed',
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
