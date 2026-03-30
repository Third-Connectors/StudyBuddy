// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:studybuddy/main.dart';

void main() {
  testWidgets('App smoke test — StudyBuddyApp renders without crashing', (
    WidgetTester tester,
  ) async {
    // Build the app wrapped in a ProviderScope (required by Riverpod).
    await tester.pumpWidget(const ProviderScope(child: StudyBuddyApp()));

    // Allow all animations and async frames to settle.
    await tester.pumpAndSettle();

    // Verify the onboarding screen is shown by checking for the hero text.
    expect(find.textContaining('UPGRADE'), findsOneWidget);
  });
}
