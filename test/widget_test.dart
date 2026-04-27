import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:basic_app/main.dart'; // 프로젝트 이름에 맞게 수정됨

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // PMSApp 대신 MyApp을 호출하도록 수정
    await tester.pumpWidget(const MyApp());

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
