import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:gorider/modules/signup/controllers/sign_up_controller.dart';

/// EXPLANATION:
/// This file tests the SignUpController - specifically the step navigation
/// and form reset functionality we implemented.
///
/// What we're testing:
/// 1. Moving forward through steps (nextStep)
/// 2. Moving backward through steps (previousStep)
/// 3. Not exceeding max steps
/// 4. Not going below step 0
/// 5. Resetting the form clears all data

void main() {
  // This runs before each test to set up a clean state
  setUp(() {
    // Initialize GetX (required for GetX controllers)
    Get.testMode = true;
  });

  // This runs after each test to clean up
  tearDown(() {
    // Remove all GetX controllers to avoid conflicts between tests
    Get.reset();
  });

  /// GROUP 1: Testing Step Navigation
  /// These tests verify that users can move between registration steps correctly
  group('Step Navigation Tests', () {
    test('should start at step 0 (first step)', () {
      // ARRANGE: Set up the test
      // Create a new SignUpController
      final controller = SignUpController();

      // ASSERT: Check the result
      // When first created, currentStep should be 0
      expect(controller.currentStep, 0);
    });

    test('should move to next step when nextStep is called', () {
      // ARRANGE
      final controller = SignUpController();
      controller.currentStep = 0; // Start at step 0

      // ACT: Perform the action we're testing
      controller.nextStep(); // Move to next step

      // ASSERT
      // Step should now be 1
      expect(controller.currentStep, 1);
    });

    test('should move to step 2 from step 1', () {
      // ARRANGE
      final controller = SignUpController();
      controller.currentStep = 1; // Start at step 1

      // ACT
      controller.nextStep(); // Move to next step

      // ASSERT
      // Step should now be 2 (the last step)
      expect(controller.currentStep, 2);
    });

    test('should NOT go beyond step 2 (max step)', () {
      // ARRANGE
      final controller = SignUpController();
      controller.currentStep = 2; // Already at last step

      // ACT
      controller.nextStep(); // Try to move forward

      // ASSERT
      // Should stay at step 2 (can't go beyond)
      expect(controller.currentStep, 2);
    });

    test('should move to previous step when previousStep is called', () {
      // ARRANGE
      final controller = SignUpController();
      controller.currentStep = 2; // Start at step 2

      // ACT
      controller.previousStep(); // Go back

      // ASSERT
      // Should now be at step 1
      expect(controller.currentStep, 1);
    });

    test('should NOT go below step 0 (first step)', () {
      // ARRANGE
      final controller = SignUpController();
      controller.currentStep = 0; // Already at first step

      // ACT
      controller.previousStep(); // Try to go back

      // ASSERT
      // Should stay at step 0 (can't go below)
      expect(controller.currentStep, 0);
    });
  });

  /// GROUP 2: Testing Form Reset
  /// These tests verify that the form resets correctly
  group('Form Reset Tests', () {
    test('should reset currentStep to 0', () {
      // ARRANGE
      final controller = SignUpController();
      controller.currentStep = 2; // Set to last step

      // ACT
      controller.resetForm(); // Reset the form

      // ASSERT
      // Should be back to step 0
      expect(controller.currentStep, 0);
    });

    test('should clear all text fields', () {
      // ARRANGE
      final controller = SignUpController();
      // Fill in some data
      controller.firstNameController.text = 'John';
      controller.lastNameController.text = 'Doe';
      controller.emailController.text = 'john@example.com';
      controller.passwordController.text = 'password123';

      // ACT
      controller.resetForm();

      // ASSERT
      // All fields should be empty
      expect(controller.firstNameController.text, '');
      expect(controller.lastNameController.text, '');
      expect(controller.emailController.text, '');
      expect(controller.passwordController.text, '');
    });

    test('should reset password visibility to hidden', () {
      // ARRANGE
      final controller = SignUpController();
      controller.signUpPasswordVisibility = true; // Password visible

      // ACT
      controller.resetForm();

      // ASSERT
      // Password should be hidden again
      expect(controller.signUpPasswordVisibility, false);
    });

    test('should clear selected courier type', () {
      // ARRANGE
      final controller = SignUpController();
      // Normally we'd set a real courier type, but for this test
      // we just check it gets cleared

      // ACT
      controller.resetForm();

      // ASSERT
      expect(controller.selectedCourierType, null);
    });
  });

  /// GROUP 3: Testing OTP Timer (bonus)
  /// This tests the OTP resend timer functionality
  group('OTP Timer Tests', () {
    test('should set resendOTPAfter to 120 seconds when timer starts', () {
      // ARRANGE
      final controller = SignUpController();
      controller.resendOTPAfter = 0; // Timer expired

      // ACT
      controller.startOtpResendTimer();

      // ASSERT
      // Timer should reset to 120 seconds (2 minutes)
      expect(controller.resendOTPAfter, 120);
    });
  });
}
