import 'package:go_logistics_driver/utils/exports.dart';

class DeliveriesHistoryScreen extends StatelessWidget {
  const DeliveriesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Orders history",
          implyLeading: false,
        ),
        backgroundColor: AppColors.backgroundColor,
        body: RefreshIndicator(
          backgroundColor: AppColors.primaryColor,
          color: Colors.white,
          onRefresh: () async {
            Get.find<DeliveriesController>().fetchDeliveries();
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
                  CustomOutlinedClickableRoundedInputField(
                    label: "Enter tracking number e.g: Xd391B",
                    title: "Enter tracking number e.g: Xd391B",
                    isSearch: true,
                    color: AppColors.blackColor,
                    labelColor: AppColors.blackColor,
                    readOnly: true,
                    onPressed: () {
                      ordersController.resetDeliveriesSearchFields();
                      showAnyBottomSheet(child: SearchDeliveriesScreen());
                    },
                    prefixWidget: Container(
                        padding: EdgeInsets.all(12.sp),
                        child: SvgPicture.asset(
                          SvgAssets.searchIcon,
                        )),
                    suffixWidget: IconButton(
                      icon: const Icon(Icons.filter_list_alt),
                      onPressed: () {
                        ordersController.resetDeliveriesSearchFields();
                        showAnyBottomSheet(child: SearchDeliveriesScreen());
                      },
                    ),
                    // controller: signInProvider.emailController,
                  ),

                  // SizedBox(
                  //   width: 1.sw,
                  //   child: SingleChildScrollView(
                  //     child: Row(
                  //       children: [
                  //         OrderTabChip(
                  //           onSelected: () {},
                  //           title: "All",
                  //           isSelected: true,
                  //         ),
                  //         OrderTabChip(
                  //           onSelected: () {},
                  //           title: "Pending",
                  //           isSelected: false,
                  //         ),
                  //         OrderTabChip(
                  //           onSelected: () {},
                  //           title: "In transit",
                  //           isSelected: false,
                  //         ),
                  //         OrderTabChip(
                  //           onSelected: () {},
                  //           title: "Delivered",
                  //           isSelected: false,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ordersController.allDeliveries.isEmpty
                      ? Container(
                          width: 1.sw,
                          height: 1.sh * 0.674,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              customText(
                                ordersController.fetchingDeliveries
                                    ? "Loading..."
                                    : "No deliveries yet",
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
                                ordersController.allDeliveries.length,
                                (i) => DeliveryItemWidget(
                                  onSelected: () {
                                    ordersController.setSelectedDelivery(
                                        ordersController.allDeliveries[i]);
                                    Get.toNamed(Routes.DELIVERY_DETAILS);
                                  },
                                  shipment: ordersController.allDeliveries[i],
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
