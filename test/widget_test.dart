import 'package:basso_hoogerheide/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test description', (tester) async {
    await tester.pumpWidget(const App());
  });
}
