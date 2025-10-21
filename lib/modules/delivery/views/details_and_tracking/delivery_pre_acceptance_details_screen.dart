import 'package:gorider/core/utils/exports.dart';

class DeliveryPreAcceptanceDetailsScreen extends StatelessWidget {
  const DeliveryPreAcceptanceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Order request",
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
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TitleSectionBox(
                        backgroundColor: AppColors.backgroundColor,
                        title: "Sender",
                        children: [
                          DeliverySummaryDetailItem(
                            titleIconAsset: SvgAssets.profileIcon,
                            title: "Sender",
                            value: "Chinonye Nnamdi",
                          ),
                          DeliverySummaryDetailItem(
                            titleIconAsset: SvgAssets.locationIcon,
                            title: "Pick up address",
                            value:
                                "Shop 7, Alaba international market, Alaba market Lagos.",
                          ),
                        ],
                      ),
                      TitleSectionBox(
                        backgroundColor: AppColors.backgroundColor,
                        title: "Receiver",
                        children: [
                          DeliverySummaryDetailItem(
                            titleIconAsset: SvgAssets.profileIcon,
                            title: "Receiver",
                            value: "James Abiodun",
                          ),
                          DeliverySummaryDetailItem(
                            titleIconAsset: SvgAssets.locationIcon,
                            title: "Drop off address",
                            value:
                                "Shop 7, Alaba international market, Alaba market Lagos.",
                          ),
                        ],
                      ),
                      TitleSectionBox(
                        backgroundColor: AppColors.backgroundColor,
                        title: "Order information",
                        children: [
                          DeliverySummaryDetailItem(
                            title: "Item name",
                            value: "Electronics",
                          ),
                          DeliverySummaryDetailItem(
                            title: "Category",
                            value: "Electronics",
                          ),
                          DeliverySummaryDetailItem(
                            isVertical: false,
                            title: "Quantity",
                            value: "4",
                          ),
                          DeliverySummaryDetailItem(
                            titleIconAsset: SvgAssets.ridesIcon,
                            title: "Courier type",
                            value: "Bike",
                          ),
                          OrderSummaryStatusDetailItem(
                            title: "Status",
                            value: "In transit",
                          ),
                          DeliverySummaryDetailItem(
                            title: "Total amount",
                            value: "#7,000",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    onPressed: () {
                      Get.to(const DeliveryPackageInformationUploadScreen());
                    },
                    // isBusy: signInProvider.isLoading,
                    title: "Accept and Pick up order",
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
      );
    });
  }
}
