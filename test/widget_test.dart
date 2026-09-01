import 'package:cs_elective_2/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home screen loads product grid', (WidgetTester tester) async {
    await tester.pumpWidget(const KeyboardStoreApp());
    await tester.pumpAndSettle();

    expect(find.textContaining('Keyboard Store'), findsWidgets);
    expect(find.textContaining('Wired Keyboards'), findsOneWidget);
    expect(
      find.text('Wooting 60HE+ Lekker Linear 60 RGB Gaming Keyboard (Black)'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Corsair K60 Pro TKL RGB Tenkeyless Optical-Mechanical Gaming Keyboard (White) (Corsair OPX Switch)',
      ),
      findsOneWidget,
    );
  });
}
