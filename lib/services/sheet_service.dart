import 'package:http/http.dart' as http;
import '../core/constants/app_links.dart';
import '../data/model/app_item.dart';

class SheetService {
  Future<List<AppItem>> fetchApps() async {
    if (AppLinks.googleSheetCsvUrl.isEmpty) {
      throw Exception('Google Sheet URL not configured');
    }

    final response = await http.get(Uri.parse(AppLinks.googleSheetCsvUrl));

    if (response.statusCode == 200) {
      return _parseCsv(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  List<AppItem> _parseCsv(String csvData) {
    final lines = csvData.split('\n');
    final items = <AppItem>[];

    if (lines.isEmpty) {
      return items;
    }

    final headers = _parseCsvLine(
      lines.first.trim(),
    ).map((header) => header.trim().toLowerCase()).toList();

    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final columns = _parseCsvLine(line);
      if (columns.isNotEmpty) {
        if (headers.isNotEmpty && headers.length == columns.length) {
          final row = <String, String>{};
          for (int j = 0; j < headers.length; j++) {
            row[headers[j]] = columns[j].trim();
          }
          items.add(AppItem.fromCsvMap(row));
        } else {
          items.add(AppItem.fromCsvRow(columns));
        }
      }
    }

    return items;
  }

  List<String> _parseCsvLine(String line) {
    final result = <String>[];
    bool inQuotes = false;
    StringBuffer current = StringBuffer();

    for (int i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current.toString());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }

    result.add(current.toString());
    return result;
  }
}
