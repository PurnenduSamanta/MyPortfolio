import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'ui/screens/boot_sequence/boot_sequence_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatefulWidget {
  const MyPortfolioApp({super.key});

  @override
  State<MyPortfolioApp> createState() => _MyPortfolioAppState();
}

class _MyPortfolioAppState extends State<MyPortfolioApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    _themeProvider.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Portfolio',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _WebDragScrollBehavior(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeProvider.themeMode,
      home: BootSequenceScreen(themeProvider: _themeProvider),
    );
  }
}

class _WebDragScrollBehavior extends MaterialScrollBehavior {
  const _WebDragScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.unknown,
  };
}
