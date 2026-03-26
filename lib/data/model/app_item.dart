class AppItem {
  final String name;
  final String iconUrl;
  final String link;
  final String type; // 'project' or 'resume'

  const AppItem({
    required this.name,
    required this.iconUrl,
    required this.link,
    required this.type,
  });

  bool get isResume {
    final normalizedType = type.trim().toLowerCase();
    final normalizedName = name.trim().toLowerCase();
    return normalizedType == 'resume' || normalizedName.contains('resume');
  }

  factory AppItem.fromCsvRow(List<String> row) {
    return AppItem(
      name: row.isNotEmpty ? row[0].trim() : '',
      iconUrl: row.length > 1 ? row[1].trim() : '',
      link: row.length > 2 ? row[2].trim() : '',
      type: row.length > 3 ? row[3].trim() : 'project',
    );
  }

  @override
  String toString() => 'AppItem(name: $name, type: $type)';
}
