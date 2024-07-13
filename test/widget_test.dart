import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_status_overlay/flutter_status_overlay.dart';

void main() {
  testWidgets('StatusOverlay shows and hides correctly', (WidgetTester tester) async {
    // Build a MaterialApp with a button that shows the StatusOverlay
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                child: Text('Show Overlay'),
                onPressed: () {
                  StatusOverlay.show(
                    context,
                    title: 'Test Title',
                    message: 'Test Message',
                    type: StatusType.success,
                    duration: Duration(seconds: 2),
                  );
                },
              );
            },
          ),
        ),
      ),
    );

    // Initially, the overlay should not be visible
    expect(find.text('Test Title'), findsNothing);
    expect(find.text('Test Message'), findsNothing);

    // Tap the button to show the overlay
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Now the overlay should be visible
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Message'), findsOneWidget);

    // Wait for the overlay to disappear
    await tester.pump(Duration(seconds: 2));
    await tester.pumpAndSettle();

    // The overlay should no longer be visible
    expect(find.text('Test Title'), findsNothing);
    expect(find.text('Test Message'), findsNothing);
  });

  testWidgets('StatusOverlay shows correct color for error type', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                child: Text('Show Error Overlay'),
                onPressed: () {
                  StatusOverlay.show(
                    context,
                    title: 'Error',
                    message: 'An error occurred',
                    type: StatusType.error,
                  );
                },
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Find the Material widget that should have the error color
    final Material material = tester.widget<Material>(
      find.ancestor(
        of: find.text('Error'),
        matching: find.byType(Material),
      ).first,
    );

    // Check if the color is red (for error type)
    expect(material.color, equals(Colors.red));
  });
}
