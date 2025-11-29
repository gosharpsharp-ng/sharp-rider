import 'package:gorider/core/utils/exports.dart';

class VehicleAndLicenseDetailsScreen extends StatelessWidget {
  const VehicleAndLicenseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Bike information",
        ),
        backgroundColor: AppColors.backgroundColor,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 15.sp),
          height: 1.sh,
          width: 1.sw,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 0.sp, vertical: 5.sp),
                  margin: EdgeInsets.symmetric(horizontal: 6.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.whiteColor),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TitleSectionBox(
                        title: "Bike Details",
                        backgroundColor: AppColors.backgroundColor,
                        trailing: settingsController.userProfile?.vehicle != null
                            ? InkWell(
                                onTap: () {
                                  settingsController.setVehicleFieldsForEdit();
                                  Get.toNamed(Routes.ADD_VEHICLE_SCREEN);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        SvgAssets.editIcon,
                                        height: 14.sp,
                                        width: 14.sp,
                                        colorFilter: ColorFilter.mode(
                                          AppColors.primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      customText(
                                        "Edit",
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : null,
                        children: [
                          VehicleDetailItem(
                            title: "Bike Type",
                            value: settingsController
                                    .userProfile?.vehicle?.courierType?.name ??
                                "",
                          ),
                          VehicleDetailItem(
                            title: "Registration Number",
                            value: settingsController
                                    .userProfile?.vehicle?.regNum ??
                                "",
                          ),
                          VehicleDetailItem(
                            title: "Status",
                            value: settingsController
                                    .userProfile?.vehicle?.status ??
                                "",
                          ),
                        ],
                      ),
                      TitleSectionBox(
                        title: "License Details",
                        backgroundColor: AppColors.backgroundColor,
                        trailing: settingsController.vehicleLicense != null
                            ? InkWell(
                                onTap: () {
                                  settingsController.setLicenseFieldsForEdit();
                                  Get.toNamed(Routes.ADD_LICENSE_SCREEN);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        SvgAssets.editIcon,
                                        height: 14.sp,
                                        width: 14.sp,
                                        colorFilter: ColorFilter.mode(
                                          AppColors.primaryColor,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      customText(
                                        "Edit",
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : null,
                        children: settingsController.vehicleLicense == null
                            ? [
                                SizedBox(
                                  height: 5.sp,
                                ),
                                InkWell(
                                  onTap: () {
                                    settingsController.isEditingLicense = false;
                                    settingsController.clearLicenseTextFields();
                                    Get.toNamed(Routes.ADD_LICENSE_SCREEN);
                                  },
                                  highlightColor: AppColors.transparent,
                                  splashColor: AppColors.transparent,
                                  child: customText("Add your license",
                                      color: AppColors.greenColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5.sp,
                                ),
                              ]
                            : [
                                VehicleDetailItem(
                                  title: "Number",
                                  value: settingsController
                                          .vehicleLicense?.number ??
                                      "",
                                ),
                                VehicleDetailItem(
                                  title: "Issue Date",
                                  value: settingsController.vehicleLicense?.issuedAt != null
                                      ? formatDate(settingsController.vehicleLicense!.issuedAt)
                                      : "",
                                ),
                                VehicleDetailItem(
                                  title: "Expiry Date",
                                  value: settingsController.vehicleLicense?.expiryDate != null
                                      ? formatDate(settingsController.vehicleLicense!.expiryDate)
                                      : "",
                                ),
                              ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
