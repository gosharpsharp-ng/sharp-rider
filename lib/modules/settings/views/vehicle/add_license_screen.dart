import 'package:gorider/core/utils/exports.dart';

class AddLicenseScreen extends StatelessWidget {
  const AddLicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Form(
        key: settingsController.vehicleLicenseFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            implyLeading: true,
            bgColor: AppColors.backgroundColor,
            title: settingsController.isEditingLicense ? "Edit License" : "Add License",
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
                      CustomRoundedInputField(
                        title: "License number",
                        label: "License number",
                        showLabel: true,
                        hasTitle: true,
                        controller: settingsController.licenseNumberController,
                      ),
                      ClickableCustomRoundedInputField(
                        title: "Issue date",
                        label: "Issue date",
                        showLabel: true,
                        hasTitle: true,
                        readOnly: true,
                        controller:
                            settingsController.licenseIssuedDateController,
                        onPressed: () {
                          settingsController.selectLicenseIssueDate(context);
                        },
                        suffixWidget: IconButton(
                          onPressed: () {
                            settingsController.selectLicenseIssueDate(context);
                          },
                          icon: SvgPicture.asset(
                            SvgAssets.calendarIcon,
                            // h: 20.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      ClickableCustomRoundedInputField(
                        title: "Expiry date",
                        label: "Expiry date",
                        showLabel: true,
                        hasTitle: true,
                        controller:
                            settingsController.licenseExpiryDateController,
                        onPressed: () {
                          settingsController.selectLicenseExpiryDate(context);
                        },
                        suffixWidget: IconButton(
                          onPressed: () {
                            settingsController.selectLicenseExpiryDate(context);
                          },
                          icon: SvgPicture.asset(
                            SvgAssets.calendarIcon,
                            // h: 20.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: CustomButton(
                      onPressed: () {
                        if (settingsController.isEditingLicense) {
                          settingsController.updateVehicleLicense();
                        } else {
                          settingsController.addVehicleLicense();
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
