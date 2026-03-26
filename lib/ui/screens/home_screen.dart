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
import '../widgets/notification_panel.dart';

class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const HomeScreen({super.key, required this.themeProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final AppRepository _repository = AppRepository();
  final TextEditingController _searchController = TextEditingController();

  List<AppItem> _allApps = [];
  List<AppItem> _filteredApps = [];
  bool _isLoading = true;
  String? _error;

  // Notification Panel Animation
  late AnimationController _notifController;
  late Animation<Offset> _notifSlide;
  bool _isNotifOpen = false;
  double _statusBarDragDistance = 0;
  bool _statusBarDragTriggered = false;

  @override
  void initState() {
    super.initState();
    _loadApps();

    _notifController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _notifSlide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _notifController, curve: Curves.easeOutQuart),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _notifController.dispose();
    super.dispose();
  }

  Future<void> _loadApps() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final apps = await _repository.getApps();
      setState(() {
        _allApps = apps;
        _filteredApps = apps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredApps = _allApps;
      } else {
        _filteredApps = _allApps
            .where(
              (app) => app.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void _openNotif() {
    if (_isNotifOpen) return;
    setState(() {
      _isNotifOpen = true;
    });
    _notifController.forward();
  }

  void _closeNotif() {
    if (!_isNotifOpen) return;
    setState(() {
      _isNotifOpen = false;
    });
    _notifController.reverse();
  }

  void _onStatusBarDragStart(DragStartDetails details) {
    _statusBarDragDistance = 0;
    _statusBarDragTriggered = false;
  }

  void _onStatusBarDragUpdate(DragUpdateDetails details) {
    if (_isNotifOpen || _statusBarDragTriggered) return;
    final delta = details.primaryDelta ?? 0;
    if (delta <= 0) return;

    _statusBarDragDistance += delta;
    if (_statusBarDragDistance >= 24) {
      _statusBarDragTriggered = true;
      _openNotif();
    }
  }

  void _onStatusBarDragEnd(DragEndDetails details) {
    _statusBarDragDistance = 0;
    _statusBarDragTriggered = false;
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
          // Main Home Screen Content
          SafeArea(
            child: Column(
              children: [
                // Status Bar + Top Gesture Area
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onVerticalDragStart: _onStatusBarDragStart,
                  onVerticalDragUpdate: _onStatusBarDragUpdate,
                  onVerticalDragEnd: _onStatusBarDragEnd,
                  onTap: () {
                    if (!_isNotifOpen) {
                      _openNotif();
                    }
                  },
                  child: StatusBarWidget(
                    onNotificationTap: () {
                      if (!_isNotifOpen) {
                        _openNotif();
                      }
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // Search Bar
                SearchBarWidget(
                  controller: _searchController,
                  onSearch: _onSearch,
                ),

                const SizedBox(height: 8),

                // Main Content
                Expanded(
                  child: _isLoading
                      ? _buildLoadingState(isDark)
                      : _error != null
                      ? _buildErrorState(isDark)
                      : _filteredApps.isEmpty
                      ? _buildEmptyState(isDark)
                      : RefreshIndicator(
                          onRefresh: _loadApps,
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                          child: AppGrid(apps: _filteredApps),
                        ),
                ),

                // Dock Bar
                DockBar(themeProvider: widget.themeProvider),

                // Navigation Bar
                const NavigationBarWidget(),
              ],
            ),
          ),

          // Notification Panel Overlay
          AnimatedBuilder(
            animation: _notifController,
            builder: (context, child) {
              final isVisible = _notifController.value > 0;
              if (!isVisible) {
                return const SizedBox.shrink();
              }
              return IgnorePointer(
                ignoring: !isVisible,
                child: Opacity(
                  opacity: _notifController.value,
                  child: SlideTransition(position: _notifSlide, child: child),
                ),
              );
            },
            child: NotificationPanel(
              onClose: _closeNotif,
              resumeLink: _allApps.isNotEmpty
                  ? _allApps
                        .firstWhere(
                          (a) => a.isResume,
                          orElse: () => _allApps.first,
                        )
                        .link
                  : "https://google.com",
            ),
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
            onPressed: _loadApps,
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
