
import 'package:go_logistics_driver/utils/exports.dart';

class VehicleAndLicenseDetailsScreen extends StatelessWidget {
  const VehicleAndLicenseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Vehicle details",
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
                        title: "Vehicle Details",
                        backgroundColor: AppColors.backgroundColor,
                        children: [
                          VehicleDetailItem(
                            title: "Brand",
                            value: settingsController.vehicleModel?.brand ?? "",
                          ),
                          VehicleDetailItem(
                            title: "Model",
                            value: settingsController.vehicleModel?.model ?? "",
                          ),
                          VehicleDetailItem(
                            title: "Registration Number",
                            value:
                                settingsController.vehicleModel?.regNum ?? "",
                          ),
                          VehicleDetailItem(
                            title: "Year",
                            value: settingsController.vehicleModel?.year
                                    .toString() ??
                                "",
                          ),
                        ],
                      ),
                      TitleSectionBox(
                        title: "License Details",
                        backgroundColor: AppColors.backgroundColor,
                        children:  settingsController.vehicleLicense==null?[]:[
                          VehicleDetailItem(
                            title: "Number",
                            value: settingsController.vehicleLicense?.number ?? "",
                          ),
                          VehicleDetailItem(
                            title: "Issue Date",
                            value: settingsController.vehicleLicense?.issuedAt ?? "",
                          ),
                          VehicleDetailItem(
                            title: "Expiry Date",
                            value:
                            settingsController.vehicleLicense?.expiryDate ?? "",
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
