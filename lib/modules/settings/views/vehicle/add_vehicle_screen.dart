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
            title: settingsController.isEditingVehicle ? "Edit Bike" : "Add Bike",
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
                        title: "Bike Type",
                        label: "Select bike type",
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
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      CustomRoundedInputField(
                        title: "Brand",
                        label: "e.g. Honda, Suzuki",
                        showLabel: true,
                        hasTitle: true,
                        controller: settingsController.vehicleBrandController,
                      ),
                      CustomRoundedInputField(
                        title: "Model",
                        label: "e.g. CG125, Boxer",
                        showLabel: true,
                        hasTitle: true,
                        controller: settingsController.vehicleModelController,
                      ),
                      CustomRoundedInputField(
                        title: "Year",
                        label: "e.g. 2023",
                        showLabel: true,
                        hasTitle: true,
                        keyboardType: TextInputType.number,
                        controller: settingsController.vehicleYearController,
                      ),
                      CustomRoundedInputField(
                        title: "Registration Number",
                        label: "e.g. ABC123XY",
                        showLabel: true,
                        hasTitle: true,
                        controller: settingsController.vehicleRegNumController,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: CustomButton(
                      onPressed: () async {
                        if (settingsController.isEditingVehicle) {
                          await settingsController.updateVehicleInfo();
                        } else {
                          await settingsController.addVehicleInfo();
                        }
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
