// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

void updateFavicon(String url) {
  try {
    // Force browser to recognize change by completely removing old icons
    final links = html.document.head?.querySelectorAll("link[rel*='icon']");
    if (links != null) {
      for (final element in links) {
        element.remove();
      }
    }

    // Add new favicon
    final newLink = html.LinkElement()
      ..rel = 'shortcut icon'
      ..href = url;
    html.document.head?.append(newLink);
    
    // Add new Apple touch icon
    final newAppleLink = html.LinkElement()
      ..rel = 'apple-touch-icon'
      ..href = url;
    html.document.head?.append(newAppleLink);
  } catch (_) {
    // Ignore any DOM errors silently
  }
}
