import 'package:cs_elective_2/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Fruit list loads at root route', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Fruits'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Banana'), findsOneWidget);
  });
}
