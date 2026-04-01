import 'package:gorider/core/utils/exports.dart';

class SignupSuccessScreen extends StatelessWidget {
  const SignupSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                SvgPicture.asset(
                  SvgAssets.successIcon,
                  height: 90.sp,
                  width: 90.sp,
                ),

                SizedBox(height: 32.h),

                customText(
                  'Registration Successful!',
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 14.h),

                customText(
                  'Your account has been created and verified. You can now log in and start earning.',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.normal,
                  color: AppColors.obscureTextColor,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                ),

                const Spacer(),

                CustomButton(
                  onPressed: () => Get.offAllNamed(Routes.SIGN_IN),
                  title: 'Proceed to Login',
                  width: double.infinity,
                  backgroundColor: AppColors.primaryColor,
                  fontColor: AppColors.whiteColor,
                ),

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
