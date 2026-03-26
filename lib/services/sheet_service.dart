import 'package:http/http.dart' as http;
import '../data/model/app_item.dart';

class SheetService {
  // Replace this with your published Google Sheet CSV URL
  // Format: https://docs.google.com/spreadsheets/d/e/{SHEET_ID}/pub?output=csv
  static const String _sheetUrl = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vRFIPsBCW3RAt2OzP__ggkgM7wLh6tpTe7M9KJ4U566bH32zMOPS9WJiS6XBbCJ8yhfUx02GDE1axZH/pub?gid=0&single=true&output=csv';

  Future<List<AppItem>> fetchApps() async {
    if (_sheetUrl.isEmpty) {
      throw Exception('Google Sheet URL not configured');
    }

    final response = await http.get(Uri.parse(_sheetUrl));

    if (response.statusCode == 200) {
      return _parseCsv(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  List<AppItem> _parseCsv(String csvData) {
    final lines = csvData.split('\n');
    final items = <AppItem>[];

    // Skip header row
    for (int i = 1; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      final columns = _parseCsvLine(line);
      if (columns.isNotEmpty) {
        items.add(AppItem.fromCsvRow(columns));
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
