import 'dart:io';

import 'package:go_logistics_driver/modules/dashboard/views/widgets/wallet_widget.dart';
import 'package:go_logistics_driver/utils/exports.dart';
import 'package:upgrader/upgrader.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (dashboardController) {
      return UpgradeAlert(
        barrierDismissible: false,
        showIgnore: false,
        showLater: false,
        showReleaseNotes: true,
        dialogStyle: Platform.isIOS
            ? UpgradeDialogStyle.cupertino
            : UpgradeDialogStyle.material,
        upgrader: Upgrader(
            messages: UpgraderMessages(code: "Kindly update your app")),
        child: Scaffold(
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
                    GetBuilder<SettingsController>(
                        builder: (settingsController) {
                      return Container(
                        color: AppColors.transparent,
                        child: Row(
                          children: [
                            Visibility(
                              visible: settingsController.userProfile?.avatar !=
                                  null,
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
                                    settingsController.userProfile?.avatar ??
                                        '',
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
                    GetBuilder<NotificationsController>(
                        builder: (notificationsController) {
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
                              notificationsController.fetchingNotifications
                                  ? ''
                                  : notificationsController
                                              .notifications.length >
                                          10
                                      ? '10+'
                                      : notificationsController
                                          .notifications.length
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
              width: 1.sw,
              color: AppColors.backgroundColor,
              child: RefreshIndicator(
                backgroundColor: AppColors.primaryColor,
                color: AppColors.whiteColor,
                onRefresh: () async {
                  Get.find<DeliveriesController>().fetchDeliveries();
                  Get.find<WalletController>().getWalletBalance();
                  Get.find<WalletController>().getTransactions();
                  Get.find<SettingsController>().getProfile();
                  Get.find<NotificationsController>().getNotifications();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      GetBuilder<WalletController>(builder: (walletController) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              WalletWidget(
                                balance: walletController
                                        .walletBalanceData?.availableBalance ??
                                    "0.0",
                                title: "Wallet balance",
                                canWithdraw: true,
                              ),
                              WalletWidget(
                                balance: walletController
                                        .walletBalanceData?.pendingBalance ??
                                    "0.0",
                                title: "Company commission",
                              ),
                              WalletWidget(
                                balance: walletController
                                        .walletBalanceData?.bonusBalance ??
                                    "0.0",
                                title: "Bonus balance",
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
                                  Get.find<WalletController>()
                                      .getTransactions();
                                  Get.to(const TransactionsScreen());
                                },
                                title: "Transaction history",
                              ),
                            ),
                            Expanded(
                              child: QuickDashboardLinkItem(
                                assetIconUrl: SvgAssets.bikeIcon,
                                onPressed: () {
                                  Get.find<DeliveriesController>()
                                      .getRiderStats();
                                  Get.find<DeliveriesController>()
                                      .getRiderRatingStats();
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
                      GetBuilder<DeliveriesController>(
                          builder: (ordersController) {
                        return Container(
                          width: 1.sw,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFFFF6E3),
                                  Color(0xFFFFFFFF),
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              ),
                              borderRadius: BorderRadius.circular(12.r)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.sp, vertical: 8.sp),
                          child: Column(
                            children: [
                              customText(
                                  ordersController.isOnline
                                      ? "You're online! Stay active to earn more or turn off the switch to take a break."
                                      : "You're offline. Turn on the switch to start earning and making deliveries!",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible),
                              GetBuilder<SettingsController>(
                                  builder: (settingsController) {
                                return Container(
                                  width: 1.sw,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      customText(
                                          ordersController.isOnline
                                              ? 'Go Offline'
                                              : 'Go Online',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.sp),
                                      SizedBox(
                                          width: 10
                                              .sp), // Space between text and switch
                                      Switch(
                                        activeColor: AppColors.greenColor,
                                        value: ordersController.isOnline,
                                        onChanged: (value) {
                                          ordersController.toggleOnlineStatus();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      }),
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
                      GetBuilder<DeliveriesController>(
                          builder: (ordersController) {
                        return Column(
                          children: [
                            ordersController.allDeliveries.isEmpty
                                ? Container(
                                    width: 1.sw,
                                    height: 1.sh * 0.4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      (i) => DeliveryItemWidget(
                                        onSelected: () {
                                          ordersController.setSelectedDelivery(
                                              ordersController
                                                  .allDeliveries[i]);
                                          Get.toNamed(Routes.DELIVERY_DETAILS);
                                        },
                                        shipment:
                                            ordersController.allDeliveries[i],
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
          ),
        ),
      );
    });
  }
}
