import 'package:flutter/material.dart';

import 'package:my_portfolio/core/constants/app_links.dart';
import 'package:my_portfolio/data/model/app_item.dart';
import 'package:my_portfolio/data/repository/app_repository.dart';
import 'package:my_portfolio/services/quote_service.dart';

class HomeViewModel extends ChangeNotifier {
  final AppRepository _repository;
  final QuoteService _quoteService;

  HomeViewModel({AppRepository? repository, QuoteService? quoteService})
    : _repository = repository ?? AppRepository(),
      _quoteService = quoteService ?? QuoteService();

  List<AppItem> _allApps = [];
  List<AppItem> _filteredApps = [];
  AppItem? _activeProject;
  bool _isLoading = true;
  String? _error;

  bool _isNotifOpen = false;
  double _statusBarDragDistance = 0;
  bool _statusBarDragTriggered = false;

  // Quote state
  Quote? _quote;
  bool _quoteLoading = false;

  List<AppItem> get filteredApps => _filteredApps;
  AppItem? get activeProject => _activeProject;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isNotifOpen => _isNotifOpen;
  bool get isDetailOpen => _activeProject != null;
  Quote? get quote => _quote;
  bool get quoteLoading => _quoteLoading;

  String get resumeLink {
    final resume = _allApps.cast<AppItem?>().firstWhere(
      (a) => a!.isResume,
      orElse: () => null,
    );
    return resume?.link ?? AppLinks.resume;
  }

  String? get profileImageUrl {
    final item = _allApps.cast<AppItem?>().firstWhere(
      (a) => a != null && a.profileImage.isNotEmpty,
      orElse: () => null,
    );
    return item?.profileImage;
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
    _prepareQuote();
    notifyListeners();
    return true;
  }

  void _prepareQuote() {
    _quote = QuoteService.randomLocalQuote();
    _quoteLoading = false;

    _tryApiQuote();
  }

  Future<void> _tryApiQuote() async {
    try {
      final apiQuote = await _quoteService
          .fetchRandomQuote()
          .timeout(const Duration(seconds: 5));
      _quote = apiQuote;
      notifyListeners();
    } catch (_) {
      // Local quote is already set, nothing to do
    }
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
      _prepareQuote();
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
