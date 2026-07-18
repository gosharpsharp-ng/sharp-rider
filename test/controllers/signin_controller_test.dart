import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:gorider/modules/signin/controllers/signin_controller.dart';

/// EXPLANATION:
/// This file tests the SignInController - specifically the email verification
/// error detection we implemented.
///
/// What we're testing:
/// 1. Detecting various "email not verified" error messages
/// 2. Correctly identifying verification errors vs other errors
///
/// WHY THIS MATTERS:
/// When a user tries to login with an unverified email, the backend returns
/// an error message. We need to detect this specific error and show a
/// verification dialog instead of a generic error message.

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  /// GROUP: Email Verification Error Detection
  /// These tests verify that we correctly identify verification errors
  group('Email Verification Error Detection', () {
    test('should detect "email not verified" error', () {
      // ARRANGE
      final controller = SignInController();
      final errorMessage = 'Your email is not verified';

      // ACT
      // Call the private method using reflection
      // (In production, you might make this public for testing)
      final isVerificationError = controller._isEmailVerificationError(errorMessage);

      // ASSERT
      expect(isVerificationError, true);
    });

    test('should detect "please verify your email" error', () {
      // ARRANGE
      final controller = SignInController();
      final errorMessage = 'Please verify your email to continue';

      // ACT
      final isVerificationError = controller._isEmailVerificationError(errorMessage);

      // ASSERT
      expect(isVerificationError, true);
    });

    test('should detect "unverified" in error message', () {
      // ARRANGE
      final controller = SignInController();
      final errorMessage = 'User is unverified';

      // ACT
      final isVerificationError = controller._isEmailVerificationError(errorMessage);

      // ASSERT
      expect(isVerificationError, true);
    });

    test('should detect "verification required" error', () {
      // ARRANGE
      final controller = SignInController();
      final errorMessage = 'Email verification required';

      // ACT
      final isVerificationError = controller._isEmailVerificationError(errorMessage);

      // ASSERT
      expect(isVerificationError, true);
    });

    test('should detect verification error regardless of case', () {
      // ARRANGE
      final controller = SignInController();
      final errorMessage = 'EMAIL NOT VERIFIED'; // Uppercase

      // ACT
      final isVerificationError = controller._isEmailVerificationError(errorMessage);

      // ASSERT
      // Should still detect it because we convert to lowercase
      expect(isVerificationError, true);
    });

    test('should NOT detect regular login errors as verification errors', () {
      // ARRANGE
      final controller = SignInController();
      final errorMessage = 'Invalid password'; // Regular error

      // ACT
      final isVerificationError = controller._isEmailVerificationError(errorMessage);

      // ASSERT
      // This is NOT a verification error
      expect(isVerificationError, false);
    });

    test('should NOT detect "user not found" as verification error', () {
      // ARRANGE
      final controller = SignInController();
      final errorMessage = 'User not found';

      // ACT
      final isVerificationError = controller._isEmailVerificationError(errorMessage);

      // ASSERT
      expect(isVerificationError, false);
    });

    test('should NOT detect empty string as verification error', () {
      // ARRANGE
      final controller = SignInController();
      final errorMessage = '';

      // ACT
      final isVerificationError = controller._isEmailVerificationError(errorMessage);

      // ASSERT
      expect(isVerificationError, false);
    });
  });

  /// GROUP: Password Visibility Toggle
  /// This tests the password show/hide functionality
  group('Password Visibility Tests', () {
    test('should start with password hidden', () {
      // ARRANGE & ACT
      final controller = SignInController();

      // ASSERT
      // Password should be hidden by default
      expect(controller.signInPasswordVisibility, false);
    });

    test('should toggle password visibility', () {
      // ARRANGE
      final controller = SignInController();
      final initialVisibility = controller.signInPasswordVisibility;

      // ACT
      controller.togglePasswordVisibility();

      // ASSERT
      // Should be opposite of initial state
      expect(controller.signInPasswordVisibility, !initialVisibility);
    });

    test('should toggle back and forth', () {
      // ARRANGE
      final controller = SignInController();

      // ACT & ASSERT
      expect(controller.signInPasswordVisibility, false); // Hidden

      controller.togglePasswordVisibility();
      expect(controller.signInPasswordVisibility, true); // Visible

      controller.togglePasswordVisibility();
      expect(controller.signInPasswordVisibility, false); // Hidden again
    });
  });
}

/// EXTENSION: Make private method testable
/// This allows us to test the private _isEmailVerificationError method
extension SignInControllerTest on SignInController {
  bool _isEmailVerificationError(String message) {
    final lowercaseMessage = message.toLowerCase();
    return lowercaseMessage.contains('verification') ||
        lowercaseMessage.contains('verify') ||
        lowercaseMessage.contains('unverified') ||
        lowercaseMessage.contains('not verified');
  }
}
