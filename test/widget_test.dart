import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uniconnect/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const UniConnectApp());

    // Basic sanity check: app builds without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
