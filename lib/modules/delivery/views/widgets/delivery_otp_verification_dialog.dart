import 'package:gorider/core/utils/exports.dart';

class DeliveryOTPVerificationDialog extends StatefulWidget {
  final String trackingId;
  final VoidCallback onVerificationSuccess;

  const DeliveryOTPVerificationDialog({
    super.key,
    required this.trackingId,
    required this.onVerificationSuccess,
  });

  @override
  State<DeliveryOTPVerificationDialog> createState() =>
      _DeliveryOTPVerificationDialogState();
}

class _DeliveryOTPVerificationDialogState
    extends State<DeliveryOTPVerificationDialog> {
  final TextEditingController otpController = TextEditingController();
  final deliveriesController = Get.find<DeliveriesController>();
  bool isVerifying = false;

  Future<void> _verifyOTP() async {
    if (otpController.text.length < 4) {
      showToast(message: "Please enter the complete OTP code", isError: true);
      return;
    }

    setState(() {
      isVerifying = true;
    });

    try {
      final response = await deliveriesController.deliveryService.verifyDeliveryOTP({
        'tracking_id': widget.trackingId,
        'otp': otpController.text,
      });

      if (response.status == "success") {
        showToast(message: "Delivery verified successfully!", isError: false);
        Get.back(); // Close dialog
        widget.onVerificationSuccess();
      } else {
        showToast(
            message: response.message.isNotEmpty ? response.message : "Invalid OTP code",
            isError: true);
      }
    } catch (e) {
      showToast(message: "Error verifying OTP: ${e.toString()}", isError: true);
    } finally {
      setState(() {
        isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.sp,
      height: 56.sp,
      textStyle: TextStyle(
        fontSize: 20.sp,
        color: AppColors.blackColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.backgroundColor,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primaryColor, width: 2),
      borderRadius: BorderRadius.circular(12.r),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.primaryColor.withOpacity(0.1),
        border: Border.all(color: AppColors.primaryColor),
      ),
    );

    return PopScope(
      canPop: !isVerifying,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon at the top
              Container(
                width: 80.sp,
                height: 80.sp,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFC107), // Yellow color
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.lock_outline,
                    size: 50.sp,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              customText(
                'Verify Delivery',
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
              SizedBox(height: 12.h),

              // Description
              customText(
                'Enter the verification code provided by the receiver to complete delivery',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.obscureTextColor,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              SizedBox(height: 32.h),

              // OTP Input
              Pinput(
                controller: otpController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                onCompleted: (pin) => _verifyOTP(),
                keyboardType: TextInputType.number,
                enabled: !isVerifying,
              ),
              SizedBox(height: 32.h),

              // Action buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: InkWell(
                      onTap: isVerifying ? null : () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE5E5), // Light red
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: customText(
                            'Cancel',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD32F2F), // Red text
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Verify button
                  Expanded(
                    child: InkWell(
                      onTap: isVerifying ? null : _verifyOTP,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32), // Dark green
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: isVerifying
                              ? SizedBox(
                                  width: 20.sp,
                                  height: 20.sp,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.whiteColor),
                                  ),
                                )
                              : customText(
                                  'Verify',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.whiteColor,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}
