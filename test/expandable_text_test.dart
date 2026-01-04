import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uniconnect/widgets/expandable_text.dart';

void main() {
  testWidgets('ExpandableText hides toggle when text fits',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: ExpandableText(
              str: 'Short text that fits.',
              allowed: 2,
            ),
          ),
        ),
      ),
    );

    // Allow post-frame callback to compute text overflow.
    await tester.pump();

    expect(find.text('Show more'), findsNothing);
    expect(find.text('Show less'), findsNothing);
  });

  testWidgets('ExpandableText toggles expansion for long text',
      (WidgetTester tester) async {
    const longText =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 150,
            child: ExpandableText(
              str: longText,
              allowed: 1,
            ),
          ),
        ),
      ),
    );

    // Allow post-frame callback to compute text overflow.
    await tester.pump();

    expect(find.text('Show more'), findsOneWidget);

    await tester.tap(find.text('Show more'));
    await tester.pump();

    expect(find.text('Show less'), findsOneWidget);
  });
}