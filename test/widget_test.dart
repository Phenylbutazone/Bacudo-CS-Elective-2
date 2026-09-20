import 'package:cs_elective_2/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dialing screen loads at initial route', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Dialing'), findsOneWidget);
    expect(find.text('Pearl Luna'), findsOneWidget);
    expect(find.text('+ 476-229-9449'), findsOneWidget);
    expect(find.text('Mute'), findsOneWidget);
  });
}
