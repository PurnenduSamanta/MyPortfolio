import 'package:flutter/material.dart';
import 'package:my_portfolio/core/theme/theme_provider.dart';
import 'package:my_portfolio/ui/screens/main/main_screen.dart';
import 'package:my_portfolio/ui/screens/boot_sequence/widgets/boot_view.dart';
import 'boot_sequence_view_model.dart';

class BootSequenceScreen extends StatefulWidget {
  final ThemeProvider themeProvider;

  const BootSequenceScreen({super.key, required this.themeProvider});

  @override
  State<BootSequenceScreen> createState() => _BootSequenceScreenState();
}

class _BootSequenceScreenState extends State<BootSequenceScreen>
    with SingleTickerProviderStateMixin {
  late final BootSequenceViewModel _viewModel;
  late final AnimationController _bootController;
  bool _precaching = false;

  @override
  void initState() {
    super.initState();
    _viewModel = BootSequenceViewModel()..addListener(_onViewModelChanged);
    _bootController = AnimationController(
      duration: BootSequenceViewModel.bootDuration,
      vsync: this,
    )..forward();
    _viewModel.start();
  }

  void _onViewModelChanged() {
    if (!mounted) return;

    // When the ViewModel has fetched the profileImageUrl, precache it
    final url = _viewModel.profileImageUrl;
    if (url != null && !_precaching) {
      _precaching = true;
      precacheImage(NetworkImage(url), context).then((_) {
        debugPrint('[Boot] precacheImage success');
        _viewModel.onImagePrecached();
      }).catchError((e) {
        debugPrint('[Boot] precacheImage failed: $e');
        _viewModel.onImagePrecached(); // proceed anyway
      });
    }

    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _bootController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      themeProvider: widget.themeProvider,
      startupScreen: _viewModel.showMainScreen
          ? null
          : BootView(
              key: const ValueKey('boot-view'),
              progress: _bootController,
              imageUrl: _viewModel.profileImageUrl,
            ),
    );
  }
}

