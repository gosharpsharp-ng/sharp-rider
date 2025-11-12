import 'package:gorider/core/utils/exports.dart';

class DeliveriesHistoryScreen extends StatelessWidget {
  const DeliveriesHistoryScreen({super.key});

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'all':
        return 'All';
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'picked':
        return 'Picked Up';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Deliveries",
          implyLeading: false,
        ),
        backgroundColor: AppColors.backgroundColor,
        body: RefreshIndicator(
          backgroundColor: AppColors.primaryColor,
          color: Colors.white,
          onRefresh: () async {
            await Get.find<DeliveriesController>().fetchDeliveries();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.h),
            height: 1.sh,
            width: 1.sw,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Status Filter Tabs
                  Container(
                    height: 45.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: ordersController.deliveryStatuses.length,
                      separatorBuilder: (context, index) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final status = ordersController.deliveryStatuses[index];
                        final isSelected = ordersController.selectedDeliveryStatus == status;
                        final deliveryCount = ordersController.getDeliveryCountByStatus(status);
                        final displayName = _getStatusDisplayName(status);

                        return InkWell(
                          onTap: () {
                            ordersController.setSelectedDeliveryStatus(status);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(25.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.greyColor.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                customText(
                                  displayName,
                                  color: isSelected
                                      ? AppColors.whiteColor
                                      : AppColors.blackColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                                if (deliveryCount > 0) ...[
                                  SizedBox(width: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.whiteColor
                                          : AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: customText(
                                      deliveryCount.toString(),
                                      color: isSelected
                                          ? AppColors.primaryColor
                                          : AppColors.whiteColor,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),
                  ordersController.fetchingDeliveries &&
                          ordersController.filteredDeliveries.isEmpty
                      ? SizedBox(
                          width: 1.sw,
                          height: 1.sh * 0.674,
                          child: SingleChildScrollView(
                            child: SkeletonLoaders.deliveryItem(count: 5),
                          ),
                        )
                      : ordersController.filteredDeliveries.isEmpty
                          ? SizedBox(
                              width: 1.sw,
                              height: 1.sh * 0.674,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_shipping_outlined,
                                    size: 64.sp,
                                    color: AppColors.greyColor.withOpacity(0.5),
                                  ),
                                  SizedBox(height: 16.h),
                                  customText(
                                    "No deliveries yet",
                                    fontSize: 16.sp,
                                    color: AppColors.greyColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  SizedBox(height: 8.h),
                                  customText(
                                    "Your delivery history will appear here",
                                    fontSize: 14.sp,
                                    color: AppColors.greyColor,
                                  ),
                                ],
                              ),
                            )
                      : Container(
                          width: 1.sw,
                          height: 1.sh * 0.674,
                          child: SingleChildScrollView(
                            controller:
                                ordersController.deliveriesScrollController,
                            child: Column(children: [
                              ...List.generate(
                                ordersController.filteredDeliveries.length,
                                (i) => DeliveryItemWidget(
                                  onSelected: () {
                                    ordersController.setSelectedDelivery(
                                        ordersController.filteredDeliveries[i]);
                                    // Navigate to tracking screen
                                    Get.toNamed(Routes.DELIVERY_TRACKING_SCREEN);
                                  },
                                  shipment: ordersController.filteredDeliveries[i],
                                ),
                              ),
                              Visibility(
                                visible: ordersController.fetchingDeliveries &&
                                    ordersController.allDeliveries.isNotEmpty,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: customText("Loading more...",
                                        color: AppColors.blueColor),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                    ordersController.allDeliveries.length ==
                                        ordersController.totalDeliveries,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: customText("No more data to load",
                                        color: AppColors.blueColor),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                  SizedBox(
                    height: 3.h,
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
