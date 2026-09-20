import 'package:cs_elective_2/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dashboard loads at root route', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('responsivedashboard'), findsOneWidget);
    expect(find.text('Click Me'), findsOneWidget);
  });
}
