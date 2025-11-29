import 'package:gorider/core/utils/exports.dart';

class DeliveryAcceptanceResultScreen extends StatelessWidget {
  const DeliveryAcceptanceResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final bool isSuccess = args?['isSuccess'] ?? false;
    final String message = args?['message'] ?? '';
    final String trackingId = args?['trackingId'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Status Icon
              Container(
                width: 120.sp,
                height: 120.sp,
                decoration: BoxDecoration(
                  color: isSuccess
                      ? const Color(0xFF2E7D32).withOpacity(0.1)
                      : const Color(0xFFD32F2F).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    size: 80.sp,
                    color: isSuccess
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFD32F2F),
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Title
              customText(
                isSuccess ? 'Delivery Accepted!' : 'Acceptance Failed',
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isSuccess
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFD32F2F),
              ),
              SizedBox(height: 16.h),

              // Message
              customText(
                message,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.obscureTextColor,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // Tracking ID Card
              if (trackingId.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      customText(
                        'Tracking ID',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.obscureTextColor,
                      ),
                      SizedBox(height: 8.h),
                      customText(
                        trackingId,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // Action Button
              if (isSuccess)
                CustomButton(
                  onPressed: () {
                    Get.offNamed(Routes.DELIVERY_TRACKING_SCREEN);
                  },
                  title: 'View Delivery',
                  backgroundColor: const Color(0xFF2E7D32),
                )
              else
                CustomButton(
                  onPressed: () {
                    Get.back();
                  },
                  title: 'Go Back',
                  backgroundColor: AppColors.greyColor,
                ),

              SizedBox(height: 16.h),

              // Secondary action for success
              if (isSuccess)
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.APP_NAVIGATION);
                  },
                  child: customText(
                    'Back to Home',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
