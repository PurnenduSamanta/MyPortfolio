import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Quote {
  final String text;
  final String author;

  const Quote({required this.text, required this.author});

  @override
  String toString() => 'Quote(text: "$text", author: "$author")';
}

class QuoteService {
  static const String _apiUrl = 'https://dummyjson.com/quotes/random';

  static const List<Quote> _localQuotes = [
    Quote(text: 'The only way to do great work is to love what you do.', author: 'Steve Jobs'),
    Quote(text: 'Innovation distinguishes between a leader and a follower.', author: 'Steve Jobs'),
    Quote(text: 'Stay hungry, stay foolish.', author: 'Steve Jobs'),
    Quote(text: 'Code is like humor. When you have to explain it, it\'s bad.', author: 'Cory House'),
    Quote(text: 'First, solve the problem. Then, write the code.', author: 'John Johnson'),
    Quote(text: 'Simplicity is the soul of efficiency.', author: 'Austin Freeman'),
    Quote(text: 'Make it work, make it right, make it fast.', author: 'Kent Beck'),
    Quote(text: 'Any fool can write code that a computer can understand.', author: 'Martin Fowler'),
    Quote(text: 'The best error message is the one that never shows up.', author: 'Thomas Fuchs'),
    Quote(text: 'Programming is the art of telling another human what one wants the computer to do.', author: 'Donald Knuth'),
    Quote(text: 'Perfection is achieved not when there is nothing more to add, but when there is nothing left to take away.', author: 'Antoine de Saint-Exupéry'),
    Quote(text: 'The best way to predict the future is to invent it.', author: 'Alan Kay'),
    Quote(text: 'Talk is cheap. Show me the code.', author: 'Linus Torvalds'),
    Quote(text: 'It\'s not a bug — it\'s an undocumented feature.', author: 'Anonymous'),
    Quote(text: 'In the middle of every difficulty lies opportunity.', author: 'Albert Einstein'),
  ];

  static final _random = Random();

  static Quote randomLocalQuote() {
    return _localQuotes[_random.nextInt(_localQuotes.length)];
  }

  Future<Quote> fetchRandomQuote() async {
    try {
      debugPrint('[QuoteService] Fetching from $_apiUrl');
      final response = await http.get(Uri.parse(_apiUrl));
      debugPrint('[QuoteService] Status: ${response.statusCode}, Body length: ${response.body.length}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = json.decode(response.body);
        debugPrint('[QuoteService] Parsed: $data');
        final text = data['quote'] as String?;
        final author = data['author'] as String?;

        if (text != null && text.isNotEmpty) {
          debugPrint('[QuoteService] Success: "$text" — $author');
          return Quote(text: text, author: author ?? 'Unknown');
        }
      }

      debugPrint('[QuoteService] API response unusable, using local quote');
      return randomLocalQuote();
    } catch (e) {
      debugPrint('[QuoteService] Error: $e — using local quote');
      return randomLocalQuote();
    }
  }
}
