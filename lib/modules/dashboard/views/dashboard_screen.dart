import 'package:go_logistics_driver/utils/exports.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      return Scaffold(
        appBar: flatAppBar(
          bgColor: AppColors.backgroundColor,
          navigationColor: AppColors.backgroundColor,
        ),
        backgroundColor: AppColors.backgroundColor,
        body: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(55.sp),
            child: Container(
              width: 1.sw,
              color: AppColors.backgroundColor,
              padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GetBuilder<SettingsController>(builder: (settingsController) {
                    return Container(
                      color: AppColors.transparent,
                      child: Row(
                        children: [
                          Visibility(
                            visible:
                                settingsController.userProfile?.avatar != null,
                            replacement: CircleAvatar(
                              radius: 22.r,
                              backgroundColor: AppColors.backgroundColor,
                              child: customText(
                                "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                                fontSize: 14.sp,
                              ),
                            ),
                            child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  settingsController.userProfile?.avatar ?? '',
                                ),
                                radius: 22.r),
                          ),
                          SizedBox(
                            width: 8.sp,
                          ),
                          customText(
                              "Hi ${settingsController.userProfile?.fname ?? ''}",
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600),
                        ],
                      ),
                    );
                  }),
                  GetBuilder<SettingsController>(builder: (settingsController) {
                    return InkWell(
                      splashColor: AppColors.transparent,
                      highlightColor: AppColors.transparent,
                      onTap: () {
                        Get.toNamed(Routes.NOTIFICATIONS_HOME);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.sp),
                        child: Badge(
                          textColor: AppColors.whiteColor,
                          backgroundColor: AppColors.redColor,
                          isLabelVisible: true,
                          label: customText(
                            settingsController.isLoadingNotification
                                ? ''
                                : settingsController.notifications.length > 10
                                    ? '10+'
                                    : settingsController.notifications.length
                                        .toString(),
                            fontSize: 12.sp,
                          ),
                          child: SvgPicture.asset(
                            SvgAssets.notificationIcon,
                            color: AppColors.obscureTextColor,
                            height: 20.sp,
                            width: 20.sp,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  GetBuilder<WalletController>(builder: (walletController) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      padding: EdgeInsets.symmetric(
                          vertical: 18.sp, horizontal: 15.sp),
                      decoration: BoxDecoration(
                          color: AppColors.deepPrimaryColor,
                          borderRadius: BorderRadius.circular(14.r)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              customText("Go-wallet balance",
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                  overflow: TextOverflow.visible),
                              SizedBox(
                                width: 10.w,
                              ),
                              InkWell(
                                highlightColor: AppColors.transparent,
                                onTap: () {
                                  walletController
                                      .toggleWalletBalanceVisibility();
                                },
                                child: Icon(
                                  walletController.walletBalanceVisibility
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.whiteColor,
                                  size: 18.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              customText(
                                  walletController.walletBalanceVisibility
                                      ? formatToCurrency(double.parse(
                                          walletController
                                                  .walletBalanceData?.balance ??
                                              "0.0"))
                                      : "*****",
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily!,
                                  fontSize: 24.sp,
                                  overflow: TextOverflow.visible),
                              CustomGreenTextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.WITHDRAWAL_AMOUNT_SCREEN);
                                },
                                bgColor: AppColors.primaryColor,
                                title: '',
                                child: Center(
                                    child: Row(
                                  children: [
                                    customText(
                                      "Withdraw",
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                    ),
                                    SizedBox(width: 12.sp),
                                    SvgPicture.asset(SvgAssets.downArrowIcon),
                                  ],
                                )),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: 1.sw,
                    child: Row(
                      children: [
                        Expanded(
                          child: QuickDashboardLinkItem(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFF6E3),
                                Color(0xFFFFFFFF),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            assetIconUrl: SvgAssets.walletIcon,
                            onPressed: () {
                              Get.to(const TransactionsScreen());
                            },
                            title: "Transaction history",
                          ),
                        ),
                        Expanded(
                          child: QuickDashboardLinkItem(
                            assetIconUrl: SvgAssets.courierIcon,
                            onPressed: () {
                              Get.to(const PerformanceScreen());
                            },
                            title: "Ride performance",
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFE3EDFF),
                                Color(0xFFFFFFFF),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: customText("Your deliveries",
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                            color: AppColors.blackColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  GetBuilder<OrdersController>(builder: (ordersController) {
                    return Column(
                      children: [
                        ordersController.allShipments.isEmpty
                            ? Container(
                                width: 1.sw,
                                height: 1.sh * 0.6,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customText(
                                      ordersController.fetchingShipments
                                          ? "Loading..."
                                          : "No shipments yet",
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: List.generate(
                                  ordersController.allShipments.length,
                                  (i) => OrderItemWidget(
                                    onSelected: () {
                                      ordersController.setSelectedShipment(
                                          ordersController.allShipments[i]);
                                      Get.toNamed(Routes.ORDER_DETAILS);
                                    },
                                    shipment: ordersController.allShipments[i],
                                  ),
                                ),
                              ),
                      ],
                    );
                  }),
                  SizedBox(
                    height: 15.h,
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
