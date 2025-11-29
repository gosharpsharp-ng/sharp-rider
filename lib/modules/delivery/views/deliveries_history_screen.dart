import 'package:gorider/core/utils/exports.dart';

class DeliveriesHistoryScreen extends StatelessWidget {
  const DeliveriesHistoryScreen({super.key});

  String _getStatusDisplayName(String status) {
    switch (status.toLowerCase()) {
      case 'all':
        return 'All';
      case 'accepted':
        return 'Accepted';
      case 'picked':
        return 'Picked Up';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
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
        body: Column(
          children: [
            // Status Filter Tabs - Fixed at top
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.h),
              color: AppColors.backgroundColor,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 45.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: ordersController.deliveryStatuses.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        final status = ordersController.deliveryStatuses[index];
                        final isSelected =
                            ordersController.selectedDeliveryStatus == status;
                        final deliveryCount =
                            ordersController.getDeliveryCountByStatus(status);
                        final displayName = _getStatusDisplayName(status);

                        return InkWell(
                          onTap: () async {
                            ordersController.setSelectedDeliveryStatus(status);
                            // Reload deliveries when switching tabs
                            await ordersController.fetchDeliveries();
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
                  SizedBox(height: 15.h),
                ],
              ),
            ),

            // Scrollable delivery list with RefreshIndicator
            Expanded(
              child: RefreshIndicator(
                backgroundColor: AppColors.primaryColor,
                color: Colors.white,
                onRefresh: () async {
                  await ordersController.fetchDeliveries();
                },
                child: ordersController.fetchingDeliveries &&
                        ordersController.filteredDeliveries.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 15.sp),
                        children: [
                          SkeletonLoaders.deliveryItem(count: 5),
                        ],
                      )
                    : ordersController.filteredDeliveries.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: 1.sh * 0.5,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.electric_bike_sharp,
                                        size: 64.sp,
                                        color: AppColors.greyColor
                                            .withOpacity(0.5),
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
                                      SizedBox(height: 16.h),
                                      customText(
                                        "Pull down to refresh",
                                        fontSize: 12.sp,
                                        color: AppColors.greyColor
                                            .withOpacity(0.7),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            controller:
                                ordersController.deliveriesScrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 15.sp),
                            itemCount:
                                ordersController.filteredDeliveries.length + 1,
                            itemBuilder: (context, index) {
                              if (index ==
                                  ordersController.filteredDeliveries.length) {
                                // Footer item
                                if (ordersController.fetchingDeliveries &&
                                    ordersController.allDeliveries.isNotEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: customText("Loading more...",
                                          color: AppColors.blueColor),
                                    ),
                                  );
                                } else if (ordersController
                                        .allDeliveries.length ==
                                    ordersController.totalDeliveries) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: customText("",
                                          color: AppColors.blueColor),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }

                              return DeliveryItemWidget(
                                onSelected: () {
                                  ordersController.setSelectedDelivery(
                                      ordersController
                                          .filteredDeliveries[index]);
                                  // Navigate to details screen - it will fetch details on init
                                  Get.toNamed(Routes.DELIVERY_DETAILS);
                                },
                                shipment:
                                    ordersController.filteredDeliveries[index],
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
