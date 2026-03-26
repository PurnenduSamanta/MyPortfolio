import '../model/app_item.dart';
import '../../services/sheet_service.dart';
import '../../core/constants/app_links.dart';

class AppRepository {
  final SheetService _sheetService = SheetService();

  List<AppItem>? _cachedItems;

  Future<List<AppItem>> getApps() async {
    if (_cachedItems != null) return _cachedItems!;

    try {
      _cachedItems = await _sheetService.fetchApps();
      
      // Ensure we always have a Resume item even if it's not in the sheet
      if (!_cachedItems!.any((app) => app.isResume)) {
        _cachedItems!.add(AppItem(
          name: 'Resume',
          iconUrl: '',
          link: AppLinks.resume,
          type: 'resume',
        ));
      }
      
      return _cachedItems!;
    } catch (e) {
      // Return fallback data if Google Sheets fails
      return _getFallbackApps();
    }
  }

  void clearCache() {
    _cachedItems = null;
  }

  List<AppItem> _getFallbackApps() {
    final projects = [
      'Portfolio', 'Weather App', 'Chat App', 'E-Commerce', 'Notes App',
      'Fitness App', 'Music Player', 'Recipe App', 'FinTrack', 'Travel Buddy',
      'Book Shelf', 'Task Master', 'News Feed', 'Stock Watch', 'Garden AR',
      'Photo Editor', 'Movie DB', 'Quiz Wiz', 'Pet Care', 'Home Auto'
    ];

    final items = projects.map((name) => AppItem(
      name: name,
      iconUrl: '',
      link: 'https://github.com',
      type: 'project',
    )).toList();

    items.add(AppItem(
      name: 'Resume',
      iconUrl: '',
      link: AppLinks.resume,
      type: 'resume',
    ));

    return items;
  }
}
