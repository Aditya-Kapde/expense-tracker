import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:financetracker_pro/main.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the Dashboard Home Screen is shown initially
    expect(find.text('Dashboard'), findsOneWidget);

    // Verify that the quick action FAB is present
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
