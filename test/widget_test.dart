import 'package:cs_elective_2/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home screen loads product grid', (WidgetTester tester) async {
    await tester.pumpWidget(const FreshFruitMarketApp());
    await tester.pumpAndSettle();

    expect(find.text('Fresh Fruit Market'), findsOneWidget);
    expect(find.text('Honeycrisp Apple'), findsOneWidget);
    expect(find.text('Organic Bananas'), findsOneWidget);
  });
}
