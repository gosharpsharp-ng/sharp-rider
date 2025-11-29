import 'package:gorider/core/utils/exports.dart';
import 'package:skeletonizer/skeletonizer.dart';

class VehicleCategoryBottomSheet extends StatelessWidget {
  const VehicleCategoryBottomSheet({super.key});

  // Get icon for courier type based on name
  IconData _getIconForType(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('bike') || lowerName.contains('motorcycle')) {
      return Icons.two_wheeler;
    } else if (lowerName.contains('car') || lowerName.contains('sedan')) {
      return Icons.directions_car;
    } else if (lowerName.contains('van') || lowerName.contains('mini')) {
      return Icons.airport_shuttle;
    } else if (lowerName.contains('truck') || lowerName.contains('lorry')) {
      return Icons.electric_bike;
    } else if (lowerName.contains('bicycle')) {
      return Icons.pedal_bike;
    }
    return Icons.electric_bike_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.sp),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.two_wheeler,
                      color: AppColors.primaryColor,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          "Select Vehicle Type",
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                        SizedBox(height: 2.h),
                        customText(
                          "Choose your vehicle category",
                          fontSize: 13.sp,
                          color: AppColors.greyColor,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.all(8.sp),
                      decoration: BoxDecoration(
                        color: AppColors.greyColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.greyColor,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Divider
            Divider(
              height: 1,
              color: AppColors.greyColor.withOpacity(0.15),
            ),

            // List Content
            Flexible(
              child: settingsController.isLoadingCourierTypes
                  ? _buildSkeletonLoader()
                  : settingsController.courierTypes.isEmpty
                      ? _buildEmptyState(settingsController)
                      : _buildCourierTypeList(settingsController),
            ),

            // Bottom safe area padding
            SizedBox(height: MediaQuery.of(context).padding.bottom + 10.h),
          ],
        ),
      );
    });
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.greyColor.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48.sp,
                  height: 48.sp,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Bone.text(words: 1, fontSize: 16.sp),
                      SizedBox(height: 4.h),
                      Bone.text(words: 3, fontSize: 12.sp),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(SettingsController controller) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.sp),
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.two_wheeler_outlined,
                size: 48.sp,
                color: AppColors.greyColor,
              ),
            ),
            SizedBox(height: 16.h),
            customText(
              "No vehicle types available",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 8.h),
            customText(
              "Please try again later",
              fontSize: 14.sp,
              color: AppColors.greyColor,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: () => controller.getCourierTypes(),
              icon: Icon(
                Icons.refresh,
                color: AppColors.whiteColor,
                size: 18.sp,
              ),
              label: customText(
                "Retry",
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourierTypeList(SettingsController controller) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: controller.courierTypes.length,
      itemBuilder: (context, index) {
        final courierType = controller.courierTypes[index];
        final isSelected =
            courierType.name == controller.vehicleCourierTypeController.text;

        return GestureDetector(
          onTap: () {
            controller.setSelectedCourierType(courierType);
            Get.back();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryColor.withOpacity(0.08)
                  : AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.greyColor.withOpacity(0.2),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 52.sp,
                  height: 52.sp,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [
                              AppColors.primaryColor,
                              AppColors.primaryColor.withOpacity(0.8),
                            ]
                          : [
                              AppColors.primaryColor.withOpacity(0.15),
                              AppColors.primaryColor.withOpacity(0.08),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    _getIconForType(courierType.name),
                    color: isSelected
                        ? AppColors.whiteColor
                        : AppColors.primaryColor,
                    size: 26.sp,
                  ),
                ),

                SizedBox(width: 14.w),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        courierType.name,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.blackColor,
                      ),
                      if (courierType.description.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        customText(
                          courierType.description,
                          fontSize: 13.sp,
                          color: AppColors.greyColor,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // Selection Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24.sp,
                  height: 24.sp,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.greyColor.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: AppColors.whiteColor,
                          size: 16.sp,
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
