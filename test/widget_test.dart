import 'package:flutter_test/flutter_test.dart';

import 'package:my_portfolio/main.dart';

void main() {
  testWidgets('Portfolio app boots and shows loading state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyPortfolioApp());

    expect(find.text('Loading apps...'), findsOneWidget);
  });
}
