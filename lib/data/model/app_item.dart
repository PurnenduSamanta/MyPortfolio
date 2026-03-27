class AppItem {
  final String name;
  final String iconUrl;
  final String link;
  final String type; // 'project' or 'resume'
  final String overview;
  final List<String> techStacks;
  final List<String> highlights;
  final String profileImage;

  const AppItem({
    required this.name,
    required this.iconUrl,
    required this.link,
    required this.type,
    this.overview = '',
    this.techStacks = const [],
    this.highlights = const [],
    this.profileImage = '',
  });

  bool get isResume {
    final normalizedType = type.trim().toLowerCase();
    final normalizedName = name.trim().toLowerCase();
    return normalizedType == 'resume' || normalizedName.contains('resume');
  }

  static String _processImageUrl(String url) {
    if (url.isEmpty) return url;
    if (url.contains('drive.google.com/file/d/')) {
      final regExp = RegExp(r'file/d/([a-zA-Z0-9_-]+)');
      final match = regExp.firstMatch(url);
      if (match != null && match.groupCount >= 1) {
        final fileId = match.group(1);
        return 'https://lh3.googleusercontent.com/d/$fileId';
      }
    }
    return url;
  }

  /// Splits a pipe-separated string into a list of trimmed, non-empty values
  static List<String> _parsePipeSeparated(String value) {
    if (value.isEmpty) return [];
    return value
        .split('|')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// CSV column order:
  /// 0: Name, 1: IconUrl, 2: Link, 3: Type,
  /// 4: Overview, 5: TechStacks, 6: Highlights, 7: ProfileImage
  factory AppItem.fromCsvRow(List<String> row) {
    return AppItem(
      name: row.isNotEmpty ? row[0].trim() : '',
      iconUrl: _processImageUrl(row.length > 1 ? row[1].trim() : ''),
      link: row.length > 2 ? row[2].trim() : '',
      type: row.length > 3 ? row[3].trim() : 'project',
      overview: row.length > 4 ? row[4].trim() : '',
      techStacks: _parsePipeSeparated(row.length > 5 ? row[5].trim() : ''),
      highlights: _parsePipeSeparated(row.length > 6 ? row[6].trim() : ''),
      profileImage: _processImageUrl(row.length > 7 ? row[7].trim() : ''),
    );
  }

  @override
  String toString() => 'AppItem(name: $name, type: $type)';
}
