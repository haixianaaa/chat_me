import 'package:flutter_test/flutter_test.dart';
import 'package:chat_me/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ChatMeApp());
    expect(find.text('ChatMe'), findsOneWidget);
  });
}
