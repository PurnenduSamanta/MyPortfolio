import 'package:flutter/material.dart';
import '../../data/model/app_item.dart';
import '../../core/theme/app_colors.dart';
import 'app_icon.dart';

class AppGrid extends StatefulWidget {
  final List<AppItem> apps;

  const AppGrid({super.key, required this.apps});

  @override
  State<AppGrid> createState() => _AppGridState();
}

class _AppGridState extends State<AppGrid> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const int _iconsPerPage = 20;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.apps.isEmpty) return const SizedBox.shrink();

    final pagesCount = (widget.apps.length / _iconsPerPage).ceil();

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: pagesCount,
            itemBuilder: (context, pageIndex) {
              final startIndex = pageIndex * _iconsPerPage;
              final endIndex = (startIndex + _iconsPerPage).clamp(0, widget.apps.length);
              final pageApps = widget.apps.sublist(startIndex, endIndex);

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                physics: const NeverScrollableScrollPhysics(), // Scroll handled by PageView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.78,
                ),
                itemCount: pageApps.length,
                itemBuilder: (context, index) {
                  return _AnimatedAppIcon(
                    key: ValueKey(pageApps[index].name),
                    index: index,
                    child: AppIcon(appItem: pageApps[index]),
                  );
                },
              );
            },
          ),
        ),
        if (pagesCount > 1)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pagesCount, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 8 : 6,
                  height: _currentPage == index ? 8 : 6,
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

class _AnimatedAppIcon extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedAppIcon({super.key, required this.index, required this.child});

  @override
  State<_AnimatedAppIcon> createState() => _AnimatedAppIconState();
}

class _AnimatedAppIconState extends State<_AnimatedAppIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    final delay = widget.index * 0.05; // Slightly faster entrance
    final curve = Interval(
      delay.clamp(0.0, 0.7),
      (delay + 0.3).clamp(0.3, 1.0),
      curve: Curves.easeOutCubic,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: curve),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: curve),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
