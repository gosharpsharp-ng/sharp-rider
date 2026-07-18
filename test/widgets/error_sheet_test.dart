import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:gorider/core/utils/widgets/status_bottom_sheet.dart';

/// EXPLANATION:
/// This file tests UI widgets - specifically the error sheet we use
/// to display registration and verification errors.
///
/// What we're testing:
/// 1. Error sheet displays the correct title
/// 2. Error sheet displays the correct message
/// 3. Error sheet has a "Try Again" button
/// 4. Tapping the button closes the sheet
///
/// WHY WIDGET TESTS MATTER:
/// Widget tests ensure that our UI components look and behave correctly.
/// They're faster than integration tests but more thorough than unit tests.

void main() {
  /// Helper function to wrap widgets with required dependencies
  /// This is needed because our app uses GetX and custom theming
  Widget createTestWidget({required Widget child}) {
    return GetMaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => child,
        ),
      ),
    );
  }

  group('Error Sheet Widget Tests', () {
    testWidgets('should display error sheet with title and message',
        (WidgetTester tester) async {
      // EXPLANATION:
      // WidgetTester is like a robot that interacts with our UI
      // It can tap buttons, enter text, and check what's displayed

      // ARRANGE: Set up the test
      // Create a button that shows the error sheet when tapped
      await tester.pumpWidget(
        createTestWidget(
          child: ElevatedButton(
            onPressed: () {
              showErrorSheet(
                title: 'Registration Failed',
                message: 'Email already exists',
              );
            },
            child: const Text('Show Error'),
          ),
        ),
      );

      // ACT: Perform the action
      // Tap the button to show the error sheet
      await tester.tap(find.text('Show Error'));

      // pumpAndSettle waits for all animations to complete
      await tester.pumpAndSettle();

      // ASSERT: Check the results
      // The error sheet should now be visible with our text
      expect(find.text('Registration Failed'), findsOneWidget);
      expect(find.text('Email already exists'), findsOneWidget);
    });

    testWidgets('should show default "Try Again" button',
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        createTestWidget(
          child: ElevatedButton(
            onPressed: () {
              showErrorSheet(
                title: 'Error',
                message: 'Something went wrong',
                // No custom button text - should use default
              );
            },
            child: const Text('Show Error'),
          ),
        ),
      );

      // ACT
      await tester.tap(find.text('Show Error'));
      await tester.pumpAndSettle();

      // ASSERT
      // Should show default "Try Again" button
      expect(find.text('Try Again'), findsOneWidget);
    });

    testWidgets('should show custom button text when provided',
        (WidgetTester tester) async {
      // ARRANGE
      await tester.pumpWidget(
        createTestWidget(
          child: ElevatedButton(
            onPressed: () {
              showErrorSheet(
                title: 'Error',
                message: 'Something went wrong',
                buttonText: 'Close', // Custom button text
              );
            },
            child: const Text('Show Error'),
          ),
        ),
      );

      // ACT
      await tester.tap(find.text('Show Error'));
      await tester.pumpAndSettle();

      // ASSERT
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('should close when button is tapped',
        (WidgetTester tester) async {
      // ARRANGE
      bool wasClosed = false;

      await tester.pumpWidget(
        createTestWidget(
          child: ElevatedButton(
            onPressed: () {
              showErrorSheet(
                title: 'Error',
                message: 'Test message',
                onButtonPressed: () {
                  wasClosed = true;
                  Get.back(); // Close the sheet
                },
              );
            },
            child: const Text('Show Error'),
          ),
        ),
      );

      // Show the error sheet
      await tester.tap(find.text('Show Error'));
      await tester.pumpAndSettle();

      // ACT: Tap the "Try Again" button
      await tester.tap(find.text('Try Again'));
      await tester.pumpAndSettle();

      // ASSERT
      // The callback should have been called
      expect(wasClosed, true);

      // The error sheet should be gone
      expect(find.text('Error'), findsNothing);
    });
  });
}
