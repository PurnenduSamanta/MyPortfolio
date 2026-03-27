import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_durations.dart';
import 'package:my_portfolio/core/theme/theme_provider.dart';
import 'package:my_portfolio/ui/screens/home/home_screen.dart';
import 'package:my_portfolio/ui/screens/main/widgets/main_desktop_layout.dart';
import 'main_view_model.dart';

class MainScreen extends StatelessWidget {
  final ThemeProvider themeProvider;
  final Widget? startupScreen;
  final MainViewModel _viewModel = MainViewModel();

  MainScreen({super.key, required this.themeProvider, this.startupScreen});

  Widget _content() =>
      startupScreen ?? HomeScreen(themeProvider: themeProvider);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = _viewModel.isDesktop(constraints.maxWidth);
        final content = _content();

        if (isDesktop) {
          return MainDesktopLayout(
            content: content,
            showingStartup: startupScreen != null,
          );
        }

        return Scaffold(
          body: AnimatedSwitcher(
            duration: AppDurations.transition,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey<bool>(startupScreen != null),
              child: content,
            ),
          ),
        );
      },
    );
  }
}
