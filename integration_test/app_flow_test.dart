import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:livre_doc/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('welcome screen and new document action are shown', (
    tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Recent Documents'), findsOneWidget);
    expect(find.text('New Document'), findsOneWidget);
  });
}