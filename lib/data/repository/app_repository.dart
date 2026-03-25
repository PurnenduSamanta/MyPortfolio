import '../model/app_item.dart';
import '../../services/sheet_service.dart';

class AppRepository {
  final SheetService _sheetService = SheetService();

  List<AppItem>? _cachedItems;

  Future<List<AppItem>> getApps() async {
    if (_cachedItems != null) return _cachedItems!;

    try {
      _cachedItems = await _sheetService.fetchApps();
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
    return const [
      AppItem(
        name: 'Portfolio',
        iconUrl: '',
        link: 'https://github.com',
        type: 'project',
      ),
      AppItem(
        name: 'Weather App',
        iconUrl: '',
        link: 'https://github.com',
        type: 'project',
      ),
      AppItem(
        name: 'Chat App',
        iconUrl: '',
        link: 'https://github.com',
        type: 'project',
      ),
      AppItem(
        name: 'E-Commerce',
        iconUrl: '',
        link: 'https://github.com',
        type: 'project',
      ),
      AppItem(
        name: 'Notes App',
        iconUrl: '',
        link: 'https://github.com',
        type: 'project',
      ),
      AppItem(
        name: 'Fitness App',
        iconUrl: '',
        link: 'https://github.com',
        type: 'project',
      ),
      AppItem(
        name: 'Music Player',
        iconUrl: '',
        link: 'https://github.com',
        type: 'project',
      ),
      AppItem(
        name: 'Resume',
        iconUrl: '',
        link: 'https://drive.google.com',
        type: 'resume',
      ),
    ];
  }
}
