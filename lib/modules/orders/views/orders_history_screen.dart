import 'package:go_logistics_driver/modules/orders/views/widgets/order_tab_chip.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(builder: (ordersController) {
      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Orders history",
          implyLeading: false,
        ),
        backgroundColor: AppColors.backgroundColor,
        body: Container(
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
                  height: 1.sh * 0.6,
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
                    : Column(
                  children: List.generate(
                    ordersController.allDeliveries.length,
                        (i) => OrderItemWidget(
                      onSelected: () {
                        ordersController.setSelectedDelivery(
                            ordersController.allDeliveries[i]);
                        Get.toNamed(Routes.ORDER_DETAILS);
                      },
                      shipment: ordersController.allDeliveries[i],
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
