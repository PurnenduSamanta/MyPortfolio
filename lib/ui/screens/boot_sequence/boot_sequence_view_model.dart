import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_durations.dart';
import 'package:my_portfolio/data/repository/app_repository.dart';
import 'package:my_portfolio/data/model/app_item.dart';

class BootSequenceViewModel extends ChangeNotifier {
  static const Duration bootDuration = AppDurations.boot;
  static const Duration transitionDelay = AppDurations.page;
  static const Duration _safetyTimeout = Duration(seconds: 10);

  bool _showMainScreen = false;
  bool _bootAnimDone = false;
  bool _imageReady = false;
  Timer? _bootTimer;
  Timer? _safetyTimer;
  String? _profileImageUrl;

  bool get showMainScreen => _showMainScreen;
  String? get profileImageUrl => _profileImageUrl;

  final AppRepository _repository;

  BootSequenceViewModel({AppRepository? repository})
      : _repository = repository ?? AppRepository();

  void start() {
    _showMainScreen = false;
    _bootAnimDone = false;
    _imageReady = false;

    _bootTimer?.cancel();
    _bootTimer = Timer(bootDuration + transitionDelay, () {
      debugPrint('[Boot] Animation done');
      _bootAnimDone = true;
      _tryTransition();
    });

    // Safety timeout — never hang longer than 10s
    _safetyTimer?.cancel();
    _safetyTimer = Timer(_safetyTimeout, () {
      debugPrint('[Boot] Safety timeout reached, forcing transition');
      _bootAnimDone = true;
      _imageReady = true;
      _tryTransition();
    });

    _loadProfileImage();
  }

  /// Called by the Screen after precacheImage succeeds or fails.
  void onImagePrecached() {
    debugPrint('[Boot] Image precached');
    _imageReady = true;
    _tryTransition();
  }

  void _tryTransition() {
    if (_showMainScreen) return;
    if (_bootAnimDone && _imageReady) {
      _showMainScreen = true;
      _safetyTimer?.cancel();
      notifyListeners();
    }
  }

  Future<void> _loadProfileImage() async {
    try {
      final apps = await _repository.getApps();
      debugPrint('[Boot] Loaded ${apps.length} apps from sheet');
      final itemWithImage = apps.cast<AppItem?>().firstWhere(
        (a) => a != null && a.profileImage.isNotEmpty,
        orElse: () => null,
      );
      if (itemWithImage != null) {
        _profileImageUrl = itemWithImage.profileImage;
        debugPrint('[Boot] profileImageUrl: $_profileImageUrl');
        notifyListeners(); // triggers Screen rebuild → precacheImage
      } else {
        debugPrint('[Boot] No profileImage found, marking ready');
        _imageReady = true;
        _tryTransition();
      }
    } catch (e) {
      debugPrint('[Boot] Error loading profile image: $e');
      _imageReady = true;
      _tryTransition();
    }
  }

  @override
  void dispose() {
    _bootTimer?.cancel();
    _safetyTimer?.cancel();
    super.dispose();
  }
}

