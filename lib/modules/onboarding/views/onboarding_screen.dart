import 'package:go_logistics_driver/utils/exports.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fadedSecondaryColor,
      appBar: flatAppBar(
          bgColor: AppColors.fadedSecondaryColor,
          navigationColor: AppColors.deepPrimaryColor),
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    color: AppColors.fadedSecondaryColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 10.w, bottom: 20.h, right: 10.w, top: 20.h),
                    color: AppColors.deepPrimaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30.h,
                        ),
                        customText(
                          "Welcome to GoSharpSharp Logistics",
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        customText(
                          "Deliver and get paid",
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            Get.toNamed(Routes.SIGN_IN);
                          },
                          backgroundColor: AppColors.fadedPrimaryColor,
                          title: "Login",
                          fontColor: AppColors.primaryColor,
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            Get.toNamed(Routes.SIGNUP_SCREEN);
                          },
                          backgroundColor: AppColors.primaryColor,
                          title: "Sign up",
                          fontColor: AppColors.whiteColor,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 1.sw,
              height: 1.sh * 0.57,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      filterQuality: FilterQuality.low,
                      image: AssetImage(
                        PngAssets.onboardingImage2,
                      ),
                      fit: BoxFit.cover)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Container(
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(25)),
                  //     child: Image.asset(PngAssets.onboardingImage2,
                  //         height: 1.sh * 0.57)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
