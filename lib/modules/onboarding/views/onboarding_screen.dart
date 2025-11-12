import 'package:flutter/services.dart';
import 'package:gorider/core/utils/exports.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Container(
          height: 1.sh,
          width: 1.sw,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(PngAssets.lightWatermark),
              fit: BoxFit.cover,
              opacity: 0.95,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top section with image
                Expanded(
                  flex: 6,
                  child: Container(
                    width: 1.sw,
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Hero Image
                        Container(
                          height: 1.sh * 0.52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.2),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                                spreadRadius: 0,
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage(PngAssets.onboardingImage1),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                      ],
                    ),
                  ),
                ),

                // Bottom section with text and buttons
                Expanded(
                  flex: 4,
                  child: Container(
                    width: 1.sw,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.backgroundColor.withOpacity(0.0),
                          AppColors.backgroundColor,
                          AppColors.backgroundColor,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Main Title
                        customText(
                          'Deliver Smarter,\nEarn Better',
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 27.sp,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          height: 1.2,
                        ),
                        SizedBox(height: 10.h),

                        // Subtitle
                        customText(
                          'Join thousands of riders earning on their own schedule with GoSharpSharp',
                          color: AppColors.obscureTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          height: 1.5,
                        ),
                        SizedBox(height: 20.h),

                        // Sign Up Button (Primary)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CustomButton(
                            onPressed: () {
                              Get.toNamed(Routes.SIGNUP_SCREEN);
                            },
                            backgroundColor: AppColors.primaryColor,
                            title: "Get Started",
                            fontColor: AppColors.whiteColor,
                            width: double.infinity,
                          ),
                        ),
                        SizedBox(height: 15.h),

                        // Login Button (Secondary)
                        CustomButton(
                          onPressed: () {
                            Get.toNamed(Routes.SIGN_IN);
                          },
                          backgroundColor: AppColors.transparent,
                          borderColor: AppColors.primaryColor,
                          title: "Already have an account? Login",
                          fontColor: AppColors.primaryColor,
                          width: double.infinity,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
