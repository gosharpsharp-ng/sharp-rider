import 'package:gorider/modules/settings/views/widgets/vehicle_category_bottom_sheet.dart';
import 'package:gorider/core/utils/exports.dart';

class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Form(
        key: settingsController.vehicleFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            implyLeading: true,
            bgColor: AppColors.backgroundColor,
            title: "Add Bike",
            centerTitle: false,
          ),
          body: Container(
            height: 1.sh,
            width: 1.sw,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SectionBox(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    backgroundColor: AppColors.whiteColor,
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      ClickableCustomRoundedInputField(
                        title: "Courier Type",
                        label: "Express",
                        showLabel: true,
                        hasTitle: true,
                        onPressed: () {
                          if (settingsController.courierTypes.isEmpty) {
                            settingsController.getCourierTypes();
                          }

                          showAnyBottomSheet(
                              child: const VehicleCategoryBottomSheet());
                        },
                        isRequired: true,
                        readOnly: true,
                        controller:
                            settingsController.vehicleCourierTypeController,
                        suffixWidget: IconButton(
                          onPressed: () {
                            if (settingsController.courierTypes.isEmpty) {
                              settingsController.getCourierTypes();
                            }
                            showAnyBottomSheet(
                                child: const VehicleCategoryBottomSheet());
                          },
                          icon: SvgPicture.asset(
                            SvgAssets.downChevronIcon,
                            // h: 20.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      // CustomRoundedInputField(
                      //   title: "Brand",
                      //   label: "Toyota",
                      //   showLabel: true,
                      //   hasTitle: true,
                      //   controller: settingsController.vehicleBrandController,
                      // ),
                      // CustomRoundedInputField(
                      //   title: "Vehicle model",
                      //   label: "Corolla",
                      //   showLabel: true,
                      //   // readOnly: !settingsController.isProfileEditable,
                      //   hasTitle: true,
                      //   controller: settingsController.vehicleModelController,
                      // ),
                      CustomRoundedInputField(
                        title: "Registration number",
                        label: "12X45YX",
                        showLabel: true,
                        hasTitle: true,
                        controller: settingsController.vehicleRegNumController,
                        // controller: signInProvider.emailController,
                      ),
                      // CustomRoundedInputField(
                      //   title: "Year",
                      //   label: "2022",
                      //   showLabel: true,
                      //   hasTitle: true,
                      //   keyboardType: TextInputType.number,
                      //   controller: settingsController.vehicleYearController,
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: CustomButton(
                      onPressed: () async {
                        await settingsController.addVehicleInfo();
                      },
                      isBusy: settingsController.isLoadingVehicle,
                      title: "Save",
                      width: 1.sw,
                      backgroundColor: AppColors.primaryColor,
                      fontColor: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
