import 'package:gorider/core/utils/exports.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      WebViewController webViewController =
          createWebViewController(successCallback: () {
        Get.back();
      });
      return Scaffold(
        appBar: defaultAppBar(
          implyLeading: false,
          bgColor: AppColors.backgroundColor,
          title: "Settings",
          centerTitle: false,
        ),
        body: Container(
          height: 1.sh,
          width: 1.sw,
          color: AppColors.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SectionBox(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  backgroundColor: AppColors.whiteColor,
                  children: [
                    Visibility(
                      visible:
                          settingsController.userProfile?.avatarUrl != null &&
                          settingsController.userProfile!.avatarUrl!.isNotEmpty,
                      replacement: Visibility(
                        visible: settingsController.userProfilePicture != null,
                        replacement: CircleAvatar(
                          radius: 55.r,
                          backgroundColor: AppColors.backgroundColor,
                          child: customText(
                            "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                            fontSize: 24.sp,
                          ),
                        ),
                        child: settingsController.userProfilePicture != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(
                                    settingsController.userProfilePicture!),
                                radius: 55.r,
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    const AssetImage(PngAssets.avatarIcon),
                                radius: 55.r,
                              ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            settingsController.userProfile?.avatarUrl ?? ''),
                        radius: 55.r,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    customText(
                      "${settingsController.userProfile?.fname ?? ""} ${settingsController.userProfile?.lname ?? ""}",
                      color: AppColors.blackColor,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.visible,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    customText(
                      settingsController.userProfile?.email ?? "",
                      color: AppColors.obscureTextColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
                SectionBox(children: [
                  SettingsItem(
                    onPressed: () {
                      settingsController.setProfileFields();
                      settingsController.toggleProfileEditState(false);
                      Get.toNamed(Routes.EDIT_PROFILE_SCREEN);
                    },
                    title: "Edit Profile",
                    icon: SvgAssets.userIcon,
                  ),
                  SettingsItem(
                    onPressed: () {
                      Get.toNamed(Routes.FUND_WALLET_AMOUNT_SCREEN);
                    },
                    title: "Fund Wallet",
                    icon: SvgAssets.walletIcon,
                  ),
                  SettingsItem(
                    onPressed: () {
                      Get.toNamed(Routes.BANK_DETAILS_SCREEN);
                    },
                    title: "Bank Details",
                    icon: SvgAssets.bankAccountIcon,
                  ),
                  SettingsItem(
                    onPressed: () {
                      Get.toNamed(Routes.TRANSACTIONS_SCREEN);
                    },
                    title: "Transaction History",
                    icon: SvgAssets.transactionsIcon,
                  ),
                  SettingsItem(
                    onPressed: () {
                      Get.toNamed(Routes.PAYOUT_HISTORY_SCREEN);
                    },
                    title: "Payout History",
                    icon: SvgAssets.payoutIcon,
                  ),
                  // SettingsItem(
                  //   onPressed: () {
                  //     Get.toNamed(Routes.RIDER_PERFORMANCE_SCREEN);
                  //   },
                  //   title: "Ride Performance",
                  //   icon: SvgAssets.deliveryIcon,
                  // ),
                  settingsController.userProfile?.vehicle == null
                      ? SettingsItem(
                          onPressed: () {
                            Get.toNamed(Routes.ADD_VEHICLE_SCREEN);
                          },
                          isShouting: true,
                          title: "Add Vehicle",
                          icon: SvgAssets.deliveryIcon,
                        )
                      : SettingsItem(
                          onPressed: () {
                            Get.toNamed(
                                Routes.VEHICLE_AND_LICENSE_DETAILS_SCREEN);
                          },
                          title: "Bike details",
                          icon: SvgAssets.bikeIcon,
                        ),
                  settingsController.vehicleLicense == null
                      ? SettingsItem(
                          onPressed: () {
                            Get.toNamed(Routes.ADD_LICENSE_SCREEN);
                          },
                          title: "Add License",
                          icon: SvgAssets.licenseIcon,
                        )
                      : const SizedBox.shrink(),
                  SettingsItem(
                    onPressed: () {
                      Get.toNamed(Routes.NOTIFICATIONS_HOME);
                    },
                    title: "Notification",
                    icon: SvgAssets.notificationIcon,
                  ),

                  SettingsItem(
                    onPressed: () {
                      Get.toNamed(Routes.CHANGE_PASSWORD_SCREEN);
                    },
                    title: "Change Password",
                    icon: SvgAssets.passwordChangeIcon,
                  ),
                  SettingsItem(
                    onPressed: () {
                      Get.toNamed(Routes.FAQS_SCREEN);
                    },
                    title: "FAQS",
                    icon: SvgAssets.faqsIcon,
                  ),
                  SettingsItem(
                    onPressed: () {
                      showWebViewDialog(context, controller: webViewController,
                          onDialogClosed: () {
                        Get.back();
                      },
                          title: "Help and Support",
                          url: "https://gosharpsharp.com/contact");
                    },
                    title: "Help and Support",
                    icon: SvgAssets.supportIcon,
                  ),

                  // SettingsItem(
                  //   onPressed: () {
                  //     showWebViewDialog(context, controller: webViewController,
                  //         onDialogClosed: () {
                  //       Get.back();
                  //     },
                  //         title: "Privacy Policy",
                  //         url: "https://gosharpsharp.com/privacy");
                  //   },
                  //   title: "Privacy Policy",
                  //   icon: SvgAssets.profileIcon,
                  // ),
                  // SettingsItem(
                  //   onPressed: () {},
                  //   title: "Language",
                  //   icon: SvgAssets.languageIcon,
                  // ),
                  // SettingsItem(
                  //   onPressed: () {},
                  //   title: "Security",
                  //   icon: SvgAssets.securityIcon,
                  // ),
                  SettingsItem(
                    onPressed: () {
                      settingsController.logout();
                    },
                    title: "Logout",
                    icon: SvgAssets.logoutIcon,
                    // isShouting: true,
                    // isLast: true,
                  ),
                  SettingsItem(
                    onPressed: () {
                      settingsController.deletePasswordController.clear();
                      settingsController.showAccountDeletionDialog();
                    },
                    title: "Delete Account",
                    icon: SvgAssets.deleteIcon,
                    // isShouting: true,
                    // isLast: true,
                  ),
                ]),
              ],
            ),
          ),
        ),
      );
    });
  }
}
