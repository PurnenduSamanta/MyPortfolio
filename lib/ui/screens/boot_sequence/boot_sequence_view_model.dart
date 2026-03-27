import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_durations.dart';

class BootSequenceViewModel extends ChangeNotifier {
  static const Duration bootDuration = AppDurations.boot;
  static const Duration transitionDelay = AppDurations.page;

  bool _showMainScreen = false;
  Timer? _transitionTimer;

  bool get showMainScreen => _showMainScreen;

  void start() {
    _showMainScreen = false;
    _transitionTimer?.cancel();
    _transitionTimer = Timer(bootDuration + transitionDelay, () {
      _showMainScreen = true;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _transitionTimer?.cancel();
    super.dispose();
  }
}
