import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:my_portfolio/core/constants/app_durations.dart';
import 'package:my_portfolio/core/constants/app_spacing.dart';
import 'package:my_portfolio/data/model/app_item.dart';
import 'app_icon.dart';

class AppGrid extends StatefulWidget {
  final List<AppItem> apps;
  final ValueChanged<AppItem>? onAppTap;

  const AppGrid({super.key, required this.apps, this.onAppTap});

  @override
  State<AppGrid> createState() => _AppGridState();
}

class _AppGridState extends State<AppGrid> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _iconsPerPage = 16; // 4 columns × 4 rows

  Future<void> _goToPage(int page) async {
    if (!_pageController.hasClients) return;
    await _pageController.animateToPage(
      page,
      duration: AppDurations.page,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.apps.isEmpty) return const SizedBox.shrink();

    final pagesCount = (widget.apps.length / _iconsPerPage).ceil();
    final isDesktopWeb = kIsWeb && MediaQuery.of(context).size.width > 600;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controlBg = (isDark ? Colors.black : Colors.white).withValues(
      alpha: 0.35,
    );
    final controlFg = isDark ? Colors.white : Colors.black87;

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                physics: const PageScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: pagesCount,
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * _iconsPerPage;
                  final endIndex = (startIndex + _iconsPerPage).clamp(
                    0,
                    widget.apps.length,
                  );
                  final pageApps = widget.apps.sublist(startIndex, endIndex);

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.page,
                      vertical: AppSpacing.xxxl,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: AppSpacing.xxxl,
                      crossAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: pageApps.length,
                    itemBuilder: (context, index) {
                      return RepaintBoundary(
                        key: ValueKey(pageApps[index].name),
                        child: AppIcon(
                          appItem: pageApps[index],
                          onTap: widget.onAppTap,
                        ),
                      );
                    },
                  );
                },
              ),
              if (isDesktopWeb && pagesCount > 1 && _currentPage > 0)
                Positioned(
                  left: AppSpacing.sm,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: controlBg,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        tooltip: 'Previous page',
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          color: controlFg,
                        ),
                        onPressed: () => _goToPage(_currentPage - 1),
                      ),
                    ),
                  ),
                ),
              if (isDesktopWeb &&
                  pagesCount > 1 &&
                  _currentPage < pagesCount - 1)
                Positioned(
                  right: AppSpacing.sm,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: controlBg,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        tooltip: 'Next page',
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          color: controlFg,
                        ),
                        onPressed: () => _goToPage(_currentPage + 1),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (pagesCount > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pagesCount, (index) {
                return AnimatedContainer(
                  duration: AppDurations.transition,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  width: _currentPage == index ? AppSpacing.md : AppSpacing.sm,
                  height: _currentPage == index ? AppSpacing.md : AppSpacing.sm,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.9)
                              : Colors.black.withValues(alpha: 0.7))
                        : (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.2)),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
