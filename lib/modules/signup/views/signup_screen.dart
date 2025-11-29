import 'package:gorider/core/utils/exports.dart';
import 'package:gorider/modules/signup/views/steps/personal_info_step.dart';
import 'package:gorider/modules/signup/views/steps/vehicle_info_step.dart';
import 'package:gorider/modules/signup/views/steps/license_info_step.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: _getStepTitle(controller.currentStep),
            implyLeading: controller.currentStep > 0,
            // leadingWidget: controller.currentStep > 0
            //     ? IconButton(
            //         icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
            //         onPressed: () {
            //           controller.previousStep();
            //         },
            //       )
            //     : null,
          ),
          body: IndexedStack(
            index: controller.currentStep,
            children: const [
              PersonalInfoStep(),
              VehicleInfoStep(),
              LicenseInfoStep(),
            ],
          ),
        );
      },
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return "Step 1";
      case 1:
        return "Step 2";
      case 2:
        return "Step 3";
      default:
        return "";
    }
  }
}
