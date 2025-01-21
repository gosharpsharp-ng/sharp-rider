import 'package:go_logistics_driver/utils/exports.dart';
import 'package:lottie/lottie.dart';

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
                      customText("GoRider",
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.sp,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible),
                    ],
                  ),
                ),
              ),
              Lottie.asset(
                'assets/json/loading.json',
                width: 40,
                height: 40,
                fit: BoxFit.fill,
              ),
              SizedBox(
                height: 80.sp,
              ),
            ],
          ),
        ),
      );
    });
  }
}
