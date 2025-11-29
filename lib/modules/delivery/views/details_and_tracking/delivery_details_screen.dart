import 'package:gorider/core/utils/exports.dart';

class DeliveryDetailsScreen extends StatefulWidget {
  const DeliveryDetailsScreen({super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  final deliveriesController = Get.find<DeliveriesController>();

  Future<void> _refreshDeliveryDetails() async {
    await deliveriesController.getDelivery();
  }

  bool get _isActiveDelivery {
    final status = deliveriesController.selectedDelivery?.status?.toLowerCase();
    return ['accepted', 'picked'].contains(status);
  }

  void _navigateToTracking() async {
    final serviceManager = Get.find<DeliveryNotificationServiceManager>();
    final controller = deliveriesController;

    if (Get.isRegistered<LocationService>()) {
      await Get.find<LocationService>().joinParcelTrackingRoom(
        trackingId: controller.selectedDelivery?.trackingId ?? "",
      );
      Get.find<LocationService>().startEmittingParcelLocation(
        deliveryModel: controller.selectedDelivery!,
      );
    } else {
      await serviceManager.initializeServices(
        controller.settingsController.userProfile!,
      );
      await Get.find<LocationService>().joinParcelTrackingRoom(
        trackingId: controller.selectedDelivery?.trackingId ?? "",
      );
      Get.find<LocationService>().startEmittingParcelLocation(
        deliveryModel: controller.selectedDelivery!,
      );
    }
    Get.toNamed(Routes.DELIVERY_TRACKING_SCREEN);
  }

  // Helper to get sender name (prefer sender, fallback to user)
  String _getSenderName(DeliveryModel delivery) {
    // Prefer sender.displayName (handles both name and fname/lname formats)
    if (delivery.sender != null) {
      return delivery.sender!.displayName;
    }
    // Fallback to user
    if (delivery.user != null) {
      return delivery.user!.displayName;
    }
    return "";
  }

  // Helper to get sender initials
  String _getSenderInitials(DeliveryModel delivery) {
    final name = _getSenderName(delivery);
    if (name.isEmpty) return "";
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return "${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}".toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  // Helper to get sender phone (prefer sender, fallback to user)
  String _getSenderPhone(DeliveryModel delivery) {
    return delivery.sender?.phone ?? delivery.user?.phone ?? "";
  }

  // Helper to get receiver initials
  String _getReceiverInitials(DeliveryModel delivery) {
    final name = delivery.receiver?.name ?? "";
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (controller) {
      final delivery = controller.selectedDelivery;
      final isLoading = controller.fetchingDeliveries;

      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Delivery Details",
        ),
        backgroundColor: AppColors.backgroundColor,
        bottomNavigationBar: (isLoading || delivery == null)
            ? null
            : _isActiveDelivery
                ? Container(
                    padding: EdgeInsets.all(16.sp),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: CustomButton(
                      onPressed: _navigateToTracking,
                      title: "Continue Delivery",
                      width: 1.sw,
                      backgroundColor: AppColors.primaryColor,
                      fontColor: AppColors.whiteColor,
                    ),
                  )
                : null,
        body: isLoading
            ? SkeletonLoaders.deliveryDetails()
            : delivery == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.sp,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(height: 16.h),
                        customText(
                          "Failed to load delivery details",
                          fontSize: 16.sp,
                          color: AppColors.greyColor,
                        ),
                        SizedBox(height: 16.h),
                        TextButton(
                          onPressed: _refreshDeliveryDetails,
                          child: customText(
                            "Tap to retry",
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    backgroundColor: AppColors.primaryColor,
                    color: Colors.white,
                    onRefresh: _refreshDeliveryDetails,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16.sp),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Status + Amount
                          _buildStatusHeader(delivery),
                          SizedBox(height: 12.h),

                          // Tracking ID - using shared widget
                          DeliveryTrackingIdWidget(
                            trackingId: delivery.trackingId ?? '',
                            backgroundColor: AppColors.whiteColor,
                          ),
                          SizedBox(height: 16.h),

                          // Pickup & Dropoff Locations Card - using shared widget
                          DeliveryLocationsCard(
                            pickupAddress: delivery.originLocation.displayName,
                            dropoffAddress: delivery.destinationLocation.displayName,
                          ),
                          SizedBox(height: 16.h),

                          // Sender & Receiver Card - using shared widget
                          DeliveryContactCard(
                            senderName: _getSenderName(delivery),
                            senderInitials: _getSenderInitials(delivery),
                            senderPhone: _getSenderPhone(delivery),
                            senderAvatar: delivery.user?.avatarUrl,
                            receiverName: delivery.receiver?.name ?? "",
                            receiverInitials: _getReceiverInitials(delivery),
                            receiverPhone: delivery.receiver?.phone ?? "",
                          ),
                          SizedBox(height: 16.h),

                          // Delivery Items
                          if (delivery.items != null &&
                              delivery.items!.isNotEmpty) ...[
                            _buildDeliveryItems(delivery),
                            SizedBox(height: 16.h),
                          ],

                          // Delivery Summary
                          _buildDeliverySummary(delivery),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
      );
    });
  }

  Widget _buildStatusHeader(DeliveryModel delivery) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 12.sp,
              vertical: 6.sp,
            ),
            decoration: BoxDecoration(
              color: getStatusColor(delivery.status),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: customText(
              delivery.status?.capitalizeFirst ?? "",
              fontWeight: FontWeight.w600,
              color: getStatusTextColor(delivery.status),
              fontSize: 13.sp,
            ),
          ),
          customText(
            formatToCurrency(double.tryParse(delivery.cost ?? '0') ?? 0),
            fontWeight: FontWeight.w700,
            fontSize: 18.sp,
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryItems(DeliveryModel delivery) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            "Delivery Items",
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 12.h),
          ...delivery.items!.map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Container(
                    width: 50.sp,
                    height: 50.sp,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: item.image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: CachedNetworkImage(
                              imageUrl: item.image!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.obscureTextColor,
                            size: 24.sp,
                          ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText(
                          item.name ?? "Item",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blackColor,
                        ),
                        if (item.category != null)
                          customText(
                            item.category!,
                            fontSize: 12.sp,
                            color: AppColors.obscureTextColor,
                          ),
                      ],
                    ),
                  ),
                  if (item.quantity != null)
                    customText(
                      "x${item.quantity}",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliverySummary(DeliveryModel delivery) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            "Distance",
            (delivery.distance?.isNotEmpty ?? false) ? "${delivery.distance} km" : "--",
          ),
          SizedBox(height: 12.h),
          _buildSummaryRow(
            "Date",
            "${formatDate(delivery.createdAt ?? '')} ${formatTime(delivery.createdAt ?? '')}",
          ),
          SizedBox(height: 12.h),
          const Divider(height: 1, color: AppColors.backgroundColor),
          SizedBox(height: 12.h),
          _buildSummaryRow(
            "Total Amount",
            formatToCurrency(double.tryParse(delivery.cost ?? '0') ?? 0),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          label,
          fontSize: isTotal ? 15.sp : 13.sp,
          fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
          color: isTotal ? AppColors.blackColor : AppColors.obscureTextColor,
        ),
        customText(
          value,
          fontSize: isTotal ? 16.sp : 14.sp,
          fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
          color: isTotal ? AppColors.primaryColor : AppColors.blackColor,
        ),
      ],
    );
  }
}
