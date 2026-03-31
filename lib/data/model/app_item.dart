class AppItem {
  final String name;
  final String iconUrl;
  final String link;
  final String type; // 'project' or 'resume'
  final String about;
  final String overview;
  final List<String> techStacks;
  final List<String> techIconUrls;
  final List<String> highlights;
  final String profileImage;

  const AppItem({
    required this.name,
    required this.iconUrl,
    required this.link,
    required this.type,
    this.about = '',
    this.overview = '',
    this.techStacks = const [],
    this.techIconUrls = const [],
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

  static String _readField(Map<String, String> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  factory AppItem.fromCsvMap(Map<String, String> row) {
    final about = _readField(row, const ['about']);
    final overview = _readField(row, const ['overview', 'description']);

    return AppItem(
      name: _readField(row, const ['name', 'title']),
      iconUrl: _processImageUrl(_readField(row, const ['iconurl', 'icon_url'])),
      link: _readField(row, const ['link', 'url']),
      type: _readField(row, const ['type']).isEmpty
          ? 'project'
          : _readField(row, const ['type']),
      about: about,
      overview: overview.isNotEmpty ? overview : about,
      techStacks: _parsePipeSeparated(
        _readField(row, const ['techstacks', 'techstack', 'tech_stacks']),
      ),
      techIconUrls: _parsePipeSeparated(
        _readField(row, const ['techicons', 'tech_icons', 'techicon']),
      ).map(_processImageUrl).toList(),
      highlights: _parsePipeSeparated(
        _readField(row, const ['highlights', 'highlight']),
      ),
      profileImage: _processImageUrl(
        _readField(row, const ['profileimage', 'profile_image']),
      ),
    );
  }

  /// CSV column order:
  /// 0: Name, 1: IconUrl, 2: Link, 3: Type,
  /// 4: About/Overview, 5: TechStacks, 6: Highlights, 7: ProfileImage
  factory AppItem.fromCsvRow(List<String> row) {
    return AppItem(
      name: row.isNotEmpty ? row[0].trim() : '',
      iconUrl: _processImageUrl(row.length > 1 ? row[1].trim() : ''),
      link: row.length > 2 ? row[2].trim() : '',
      type: row.length > 3 ? row[3].trim() : 'project',
      about: row.length > 4 ? row[4].trim() : '',
      overview: row.length > 4 ? row[4].trim() : '',
      techStacks: _parsePipeSeparated(row.length > 5 ? row[5].trim() : ''),
      techIconUrls: row.length > 8
          ? _parsePipeSeparated(row[8].trim()).map(_processImageUrl).toList()
          : const [],
      highlights: _parsePipeSeparated(row.length > 6 ? row[6].trim() : ''),
      profileImage: _processImageUrl(row.length > 7 ? row[7].trim() : ''),
    );
  }

  @override
  String toString() => 'AppItem(name: $name, type: $type)';
}
