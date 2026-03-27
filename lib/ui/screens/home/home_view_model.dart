import 'package:flutter/material.dart';

import 'package:my_portfolio/core/constants/app_links.dart';
import 'package:my_portfolio/data/model/app_item.dart';
import 'package:my_portfolio/data/repository/app_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final AppRepository _repository;

  HomeViewModel({AppRepository? repository})
    : _repository = repository ?? AppRepository();

  List<AppItem> _allApps = [];
  List<AppItem> _filteredApps = [];
  AppItem? _activeProject;
  bool _isLoading = true;
  String? _error;

  bool _isNotifOpen = false;
  double _statusBarDragDistance = 0;
  bool _statusBarDragTriggered = false;

  List<AppItem> get filteredApps => _filteredApps;
  AppItem? get activeProject => _activeProject;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isNotifOpen => _isNotifOpen;
  bool get isDetailOpen => _activeProject != null;

  String get resumeLink {
    final resume = _allApps.cast<AppItem?>().firstWhere(
      (a) => a!.isResume,
      orElse: () => null,
    );
    return resume?.link ?? AppLinks.resume;
  }

  Future<void> loadApps() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apps = await _repository.getApps();
      _allApps = apps;
      _filteredApps = apps.where((a) => !a.isResume).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void onSearch(String query) {
    final nonResumeApps = _allApps.where((a) => !a.isResume);
    if (query.isEmpty) {
      _filteredApps = nonResumeApps.toList();
    } else {
      _filteredApps = nonResumeApps
          .where((app) => app.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  bool openProjectDetail(AppItem appItem) {
    final shouldCloseNotif = _isNotifOpen;
    _isNotifOpen = false;
    _activeProject = appItem;
    notifyListeners();
    return shouldCloseNotif;
  }

  void closeProjectDetail() {
    _activeProject = null;
    notifyListeners();
  }

  bool openNotif() {
    if (_isNotifOpen || isDetailOpen) return false;
    _isNotifOpen = true;
    notifyListeners();
    return true;
  }

  bool closeNotif() {
    if (!_isNotifOpen) return false;
    _isNotifOpen = false;
    notifyListeners();
    return true;
  }

  void onStatusBarDragStart() {
    _statusBarDragDistance = 0;
    _statusBarDragTriggered = false;
  }

  bool onStatusBarDragUpdate(double delta) {
    if (_isNotifOpen || _statusBarDragTriggered || isDetailOpen || delta <= 0) {
      return false;
    }

    _statusBarDragDistance += delta;
    if (_statusBarDragDistance >= 24) {
      _statusBarDragTriggered = true;
      _isNotifOpen = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void onStatusBarDragEnd() {
    _statusBarDragDistance = 0;
    _statusBarDragTriggered = false;
  }
}
