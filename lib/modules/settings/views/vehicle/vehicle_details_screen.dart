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
                        children: settingsController.vehicleLicense == null
                            ? [
                                SizedBox(
                                  height: 5.sp,
                                ),
                                InkWell(
                                  onTap: () {
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
                                  value: settingsController
                                          .vehicleLicense?.issuedAt ??
                                      "",
                                ),
                                VehicleDetailItem(
                                  title: "Expiry Date",
                                  value: settingsController
                                          .vehicleLicense?.expiryDate ??
                                      "",
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
