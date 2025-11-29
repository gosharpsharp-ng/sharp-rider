import 'dart:io';

import 'package:gorider/modules/dashboard/views/widgets/wallet_widget.dart';
import 'package:gorider/core/utils/exports.dart';
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
                              visible:
                                  settingsController.userProfile?.avatarUrl !=
                                          null &&
                                      settingsController
                                          .userProfile!.avatarUrl!.isNotEmpty,
                              replacement: CircleAvatar(
                                radius: 18.r,
                                backgroundColor: AppColors.backgroundColor,
                                child: customText(
                                  "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                                  fontSize: 14.sp,
                                ),
                              ),
                              child: CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    settingsController.userProfile?.avatarUrl ??
                                        '',
                                  ),
                                  radius: 18.r),
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
                  // Refresh profile first to get updated wallet balance
                  await Get.find<SettingsController>().getProfile();
                  // Sync wallet data from profile
                  Get.find<WalletController>().loadWalletFromProfile();
                  Get.find<WalletController>().getTransactions();
                  Get.find<DeliveriesController>().fetchDeliveries();
                  Get.find<NotificationsController>().getNotifications();
                },
                child: Column(
                  children: [
                    // Wallet Section
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: GetBuilder<WalletController>(
                          builder: (walletController) {
                        return WalletWidget(
                          balance: walletController.availableBalance,
                          title: "Wallet balance",
                          canWithdraw: true,
                        );
                      }),
                    ),

                    // Map with Go Online Overlay
                    Expanded(
                      child: GetBuilder<DashboardController>(
                        builder: (dashController) {
                          return GetBuilder<DeliveriesController>(
                            builder: (ordersController) {
                              return Stack(
                                children: [
                                  // Google Map
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.r),
                                      topRight: Radius.circular(20.r),
                                    ),
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: dashController.initialPosition,
                                        zoom: 16.5,
                                      ),
                                      style: dashController.currentMapStyle,
                                      markers: dashController.markers,
                                      circles: dashController.circles,
                                      myLocationEnabled: false,
                                      myLocationButtonEnabled: false,
                                      zoomControlsEnabled: true,
                                      zoomGesturesEnabled: true,
                                      scrollGesturesEnabled: true,
                                      rotateGesturesEnabled: true,
                                      tiltGesturesEnabled: true,
                                      mapToolbarEnabled: false,
                                      compassEnabled: true,
                                      liteModeEnabled: false,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        dashController.onMapCreated(controller);
                                      },
                                    ),
                                  ),

                                  // Map Style Toggle Button
                                  Positioned(
                                    top: 10.h,
                                    right: 10.w,
                                    child: GestureDetector(
                                      onTap: () {
                                        dashController.toggleMapStyle();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10.sp),
                                        decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(15),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          dashController.isLightMapStyle
                                              ? Icons.dark_mode_outlined
                                              : Icons.light_mode_outlined,
                                          color: AppColors.blackColor,
                                          size: 22.sp,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Go Online Widget Overlay
                                  Positioned(
                                    bottom: 20.h,
                                    left: 20.w,
                                    right: 20.w,
                                    child: Container(
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
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 25.sp,
                                        vertical: 15.sp,
                                      ),
                                      child: Column(
                                        children: [
                                          customText(
                                            ordersController.isOnline
                                                ? "You're online! Stay active to earn more."
                                                : "You're offline. Go online to start earning!",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.sp,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.visible,
                                          ),
                                          SizedBox(height: 8.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              customText(
                                                ordersController.isOnline
                                                    ? 'Go Offline'
                                                    : 'Go Online',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18.sp,
                                              ),
                                              SizedBox(width: 10.sp),
                                              Switch(
                                                activeColor:
                                                    AppColors.greenColor,
                                                value:
                                                    ordersController.isOnline,
                                                onChanged: (value) {
                                                  ordersController
                                                      .toggleOnlineStatus();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
