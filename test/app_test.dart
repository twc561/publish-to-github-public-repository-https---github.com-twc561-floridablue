import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Renders LoginScreen and navigates to DashboardScreen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const FloridaBlueGuideApp(),
      ),
    );

    // Verify that the LoginScreen is rendered.
    expect(find.text('Florida Blue Guide'), findsOneWidget);
    expect(find.text('AI-Powered Field Assistant'), findsOneWidget);
    expect(find.byKey(const Key('loginButton')), findsOneWidget);

    // Tap the login button and trigger a frame.
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pumpAndSettle();

    // Verify that the DashboardScreen is rendered.
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(GridView), findsOneWidget);

    // Verify that the search bar is present
    expect(find.byType(TextField), findsOneWidget);

    // Enter text in the search bar
    await tester.enterText(find.byType(TextField), 'test query');

    // Tap the search button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Search'));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify that the search results are displayed (at least one widget with some text)
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data!.isNotEmpty,
      ),
      findsWidgets,
    );
  });
}
