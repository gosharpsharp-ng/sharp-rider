import 'package:go_logistics_driver/utils/exports.dart';

class SearchDeliveriesScreen extends StatelessWidget {
  const SearchDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(builder: (ordersController) {
      return Form(
        key: ordersController.deliveriesSearchFormKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 5.h),
          height: 1.sh,
          width: 1.sw,
          color: AppColors.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                CustomOutlinedRoundedInputField(
                  label: "Enter tracking number e.g: Xd391B",
                  isSearch: true,
                  autoFocus: true,
                  color: AppColors.obscureTextColor,
                  hasTitle: true,
                  prefixWidget: Container(
                      padding: EdgeInsets.all(12.sp),
                      child: SvgPicture.asset(
                        SvgAssets.searchIcon,
                      )),
                  suffixWidget: CustomGreenTextButton(
                    title: "Go",
                    isLoading: ordersController.searchingShipments,
                    onPressed: () {
                      ordersController.searchShipments();
                    },
                  ),
                  // controller: signInProvider.emailController,
                ),
                SizedBox(
                  height: 15.h,
                ),
                const SectionHeader(
                  title: "Results",
                ),
                SizedBox(
                  height: 10.h,
                ),
                ordersController.shipmentSearchResults.isEmpty
                    ? Container(
                  width: 1.sw,
                  height: 1.sh * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customText(
                        ordersController.searchingShipments
                            ? "Loading..."
                            : "Enter your search query above",
                      ),
                    ],
                  ),
                )
                    : Column(
                  children: List.generate(
                    ordersController.shipmentSearchResults.length,
                        (i) => OrderItemWidget(
                      onSelected: () {
                        Get.back();
                        ordersController.setSelectedShipment(
                            ordersController.shipmentSearchResults[i]);
                        Get.toNamed(
                            Routes.ORDER_DETAILS);
                      },
                      shipment: ordersController.shipmentSearchResults[i],
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
