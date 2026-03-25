import 'package:flutter_test/flutter_test.dart';
import 'package:client_flow_mobile/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const ClientFlowApp());
    expect(find.text('ClientFlow Pro'), findsOneWidget);
  });
}
