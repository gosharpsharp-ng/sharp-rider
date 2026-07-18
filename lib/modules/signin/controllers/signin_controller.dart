import 'package:gorider/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:gorider/core/services/analytics_service.dart';
import 'package:gorider/core/services/push_notification_service.dart';

class SignInController extends GetxController {
  final authService = serviceLocator<AuthenticationService>();
  final signInFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  bool signInPasswordVisibility = false;

  togglePasswordVisibility() {
    signInPasswordVisibility = !signInPasswordVisibility;
    update();
  }

  bool signInWithEmail = true;

  toggleSignInWithEmail() {
    signInWithEmail = !signInWithEmail;
    loginController.clear();
    update();
  }

  TextEditingController loginController = TextEditingController();

  setPhoneNumber(PhoneNumber num) {
    loginController.text = num.number;
    update();
  }

  PhoneNumber? filledPhoneNumber;
  setFilledPhoneNumber(PhoneNumber num) {
    filledPhoneNumber = num;
    update();
  }

  String? loginErrorMessage;

  TextEditingController passwordController = TextEditingController();
  signIn() async {
    loginErrorMessage = null;
    update();

    if (signInFormKey.currentState!.validate()) {
      setLoadingState(true);
      try {
        dynamic data = {
          'login': signInWithEmail
              ? loginController.text
              : filledPhoneNumber?.completeNumber ?? '',
          'password': passwordController.text,
          "as_rider": true
        };
        APIResponse response = await authService.login(data);

        if (response.status.toLowerCase() == "success") {
          print(
              "*****************************************************************************");
          print(
              "Login successful - Token: ${response.data['access_token'] ?? response.data['auth_token']}");
          print(
              "*****************************************************************************");

          loginController.clear();
          passwordController.clear();
          filledPhoneNumber = null;
          update();
          final getStorage = GetStorage();
          // Try both possible token field names
          final token =
              response.data['access_token'] ?? response.data['auth_token'];
          getStorage.write("token", token);

          // Register device token for push notifications
          await PushNotificationService().registerTokenIfAvailable();

          // Set Analytics user ID
          final userProfile = response.data['user'];
          if (userProfile != null && userProfile['id'] != null) {
            await AnalyticsService().setUserId(userProfile['id'].toString());
            await AnalyticsService().setUserProperty('user_type', 'rider');
          }

          // Initialize controllers like sharp-vendor does
          Get.put(SettingsController());
          Get.put(DeliveriesController());
          Get.toNamed(Routes.APP_NAVIGATION);
        } else {
          // Check if error is about email verification
          if (_isEmailVerificationError(response.message)) {
            _showEmailVerificationDialog();
          } else {
            loginErrorMessage = response.message;
            update();
          }
        }
      } catch (e) {
        print("Error during sign in: $e");
        loginErrorMessage = "An unexpected error occurred. Please try again.";
        update();
      } finally {
        // Always reset loading state, even if an error occurs
        setLoadingState(false);
      }
    }
  }

  // Check if error message is about email verification
  bool _isEmailVerificationError(String message) {
    final lowercaseMessage = message.toLowerCase();
    return lowercaseMessage.contains('verification') ||
        lowercaseMessage.contains('verify') ||
        lowercaseMessage.contains('unverified') ||
        lowercaseMessage.contains('not verified');
  }

  // Show dialog asking user to verify email
  void _showEmailVerificationDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.mark_email_unread_outlined,
              color: AppColors.primaryColor,
              size: 28.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: customText(
                'Email Verification Required',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText(
              'Your email hasn\'t been verified yet. Please verify your email to continue.',
              fontSize: 14.sp,
              color: AppColors.blackColor,
              maxLines: 5,
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: 20.sp,
                    color: AppColors.primaryColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: customText(
                      loginController.text,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: customText(
              'Cancel',
              fontSize: 14.sp,
              color: AppColors.greyColor,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _sendVerificationOtp();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: customText(
              'Verify Email Now',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Send OTP for email verification
  Future<void> _sendVerificationOtp() async {
    // Show loading dialog
    Get.dialog(
      Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 0.7.sw,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primaryColor),
                SizedBox(height: 16.h),
                Text(
                  'Sending OTP...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      // Send OTP to user's email
      final response = await authService.sendOtp({
        'identifier': loginController.text,
      });

      // Close loading dialog
      Get.back();

      if (response.status == "success") {
        // Navigate to OTP verification screen (reuse signup OTP screen)
        // First, set up a temporary SignUpController with the email
        final signUpController = Get.put(SignUpController());
        signUpController.emailController.text = loginController.text;
        signUpController.isFromLoginFlow = true; // Mark as coming from login

        // Start the OTP resend timer (OTP was already sent above)
        signUpController.startOtpResendTimer();

        debugPrint('🚀 Navigating to OTP screen from login flow');
        debugPrint('✅ isFromLoginFlow set to: ${signUpController.isFromLoginFlow}');

        final result = await Get.toNamed(Routes.SIGNUP_OTP_SCREEN);

        debugPrint('\n⬅️ ===== RETURNED FROM OTP SCREEN =====');
        debugPrint('📦 Result: $result');
        debugPrint('🔍 Result type: ${result.runtimeType}');
        debugPrint('✅ Result == true: ${result == true}');
        debugPrint('✅ Result is bool: ${result is bool}');
        debugPrint('⬅️ ====================================\n');

        // Clean up the temporary controller
        Get.delete<SignUpController>();

        // If verification was successful, show success message
        if (result == true) {
          debugPrint('✅✅✅ SUCCESS! Showing verification success dialog');
          _showVerificationSuccessDialog();
        } else {
          debugPrint('❌❌❌ FAILED! Result was not true');
          debugPrint('💡 Result value: $result');
        }
      } else {
        showToast(
          message: response.message,
          isError: true,
        );
      }
    } catch (e) {
      // Close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      debugPrint('Error sending verification OTP: $e');
      showToast(
        message: 'Failed to send verification code. Please try again.',
        isError: true,
      );
    }
  }

  // Show success dialog after email verification
  void _showVerificationSuccessDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 32.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: customText(
                'Verified!',
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
          ],
        ),
        content: customText(
          'Your email has been verified successfully. You can now log in.',
          fontSize: 14.sp,
          color: AppColors.blackColor,
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: customText(
              'OK',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.whiteColor,
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
