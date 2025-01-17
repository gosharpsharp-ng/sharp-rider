import 'package:go_logistics_driver/utils/exports.dart';

class VehicleCategoryBottomSheet extends StatelessWidget {
  const VehicleCategoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Container(
        height: 1.sh * 0.53,
        width: 1.sw,
        margin: EdgeInsets.only(top: 5.sp),
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
        child: Column(
          children: [
            customText("Select Vehicle Type",
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: AppColors.primaryColor),
            Container(
              height: 1.sh * 0.46,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      settingsController.courierTypes.length,
                          (index) => InkWell(
                        child: Column(
                          mainAxisAlignment:settingsController.isLoadingCourierTypes?MainAxisAlignment.center: MainAxisAlignment.start,
                          children:  settingsController.isLoadingCourierTypes? [customText("Loading...")]: [

                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.sp, vertical: 2.sp),
                              height: 45.sp,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.sp, vertical: 6.sp),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: customText(
                                        settingsController
                                            .courierTypes[index].name,
                                        fontSize: 18.sp,
                                        color:  settingsController
                                            .courierTypes[index].name ==
                                            settingsController
                                                .vehicleCourierTypeController.text
                                            ? AppColors.primaryColor
                                            : AppColors.blackColor),
                                  ),
                                  settingsController
                                      .courierTypes[index].name ==
                                      settingsController
                                          .vehicleCourierTypeController.text
                                      ? Icon(
                                    Icons.check_circle_outline,
                                    color: AppColors.primaryColor,
                                    size: 20.sp,
                                  )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                            Divider(
                              color: AppColors.primaryColor.withOpacity(0.1),
                            )
                          ],
                        ),
                        onTap: () {
                          settingsController.setSelectedCourierType(
                              settingsController.courierTypes[index]);
                          Get.back();
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
