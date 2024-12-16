import 'package:go_logistics_driver/utils/exports.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                Container(
                  color: AppColors.transparent,
                  child: Row(
                    children: [
                      CircleAvatar(
                        // backgroundImage: CachedNetworkImageProvider(
                        //   profileProvider.userProfile?.profileImage ?? '',
                        // ),
                        backgroundImage: const AssetImage(
                          PngAssets.avatarIcon,
                        ),
                        radius: 22.r,
                        // backgroundImage: CachedNetworkImageProvider(
                        //   profileProvider.userProfile?.profileImage ?? '',
                        // ),
                        child: Image.asset(
                          PngAssets.avatarIcon,
                        ),
                      ),
                      SizedBox(
                        width: 8.sp,
                      ),
                      customText("Hi Andrew",
                          fontSize: 20.sp, fontWeight: FontWeight.w600),
                    ],
                  ),
                ),
                InkWell(
                  splashColor: AppColors.transparent,
                  highlightColor: AppColors.transparent,
                  onTap: () {
                    Get.to(const NotificationsHomeScreen());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.sp),
                    child: Badge(
                      textColor: AppColors.whiteColor,
                      backgroundColor: AppColors.redColor,
                      isLabelVisible: true,
                      label: customText("4"),
                      child: SvgPicture.asset(
                        SvgAssets.notificationIcon,
                        color: AppColors.obscureTextColor,
                        height: 25.sp,
                        width: 25.sp,
                      ),
                    ),
                  ),
                ),
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
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 18.sp, horizontal: 15.sp),
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
                          Icon(
                            Icons.visibility_off,
                            color: AppColors.whiteColor,
                            size: 18.sp,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText("₦71,800.34",
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                              fontFamily: GoogleFonts.montserrat().fontFamily!,
                              fontSize: 24.sp,
                              overflow: TextOverflow.visible),
                          CustomGreenTextButton(
                            onPressed: () {
                              Get.to(const WithdrawalAmountScreen());
                            },
                            bgColor: AppColors.primaryColor,
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
                ),
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
                            begin: Alignment
                                .topRight,
                            end: Alignment
                                .bottomLeft,
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
                      child: customText("Ready for pickup near you",
                          fontWeight: FontWeight.w500,
                          fontSize: 18.sp,
                          color: AppColors.blackColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                ...List.generate(
                  14,
                  (i) => const OrderItemWidget(),
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
