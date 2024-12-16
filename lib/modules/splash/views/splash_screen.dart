import 'package:go_logistics_driver/utils/exports.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
        return Scaffold(
          backgroundColor: AppColors.fadedPrimaryColor,
          appBar: flatAppBar(
              bgColor: AppColors.fadedPrimaryColor,
              navigationColor: AppColors.fadedPrimaryColor),
          body: SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 4,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(PngAssets.goSharpSharpIcon),
                        customText("GoSharpSharp",
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.sp,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 40.sp,
                  height: 40.sp,
                  child: const CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
                SizedBox(
                  height: 80.sp,
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  }




