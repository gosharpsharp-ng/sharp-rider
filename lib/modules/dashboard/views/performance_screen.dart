import 'package:go_logistics_driver/utils/exports.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: flatAppBar(
        bgColor: AppColors.backgroundColor,
        navigationColor: AppColors.backgroundColor,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Scaffold(
        appBar: defaultAppBar(
            title: "Performance", bgColor: AppColors.backgroundColor),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 3.sp),
          height: 1.sh,
          width: 1.sw,
          color: AppColors.backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: 1.sw,
                  child: const Row(
                    children: [
                      Expanded(
                        child: PerformanceBox(
                          assetIconUrl: SvgAssets.parcelIcon,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFF6E3),
                              Color(0xFFFFFFFF),
                            ],
                              begin: Alignment
                                  .topRight,
                              end: Alignment
                                  .bottomLeft,
                          ),
                          title: "Total Orders",
                          value: "930",
                          iconColor: AppColors.foundationColor,
                          iconBoxColor: AppColors.foundationBgColor,
                        ),
                      ),
                      Expanded(
                        child: PerformanceBox(
                          assetIconUrl: SvgAssets.courierIcon,
                          title: "Distance Traveled",
                          value: "10572km",
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFE3EDFF),
                              Color(0xFFFFFFFF),
                            ],
                            begin: Alignment
                                .topRight,
                            end: Alignment
                                .bottomLeft,
                          ),
                          iconColor: AppColors.blueColor,
                          iconBoxColor: AppColors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  width: 1.sw,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 18.sp, horizontal: 15.sp),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFE7FFE3),
                          Color(0xFFFFFFFF),
                        ],
                        begin: Alignment
                            .topCenter,
                        end: Alignment
                            .bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(14.r)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText("Total income",
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                          overflow: TextOverflow.visible),
                      SizedBox(
                        height: 20.h,
                      ),
                      customText("₦71,800.34",
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: GoogleFonts.montserrat().fontFamily!,
                          fontSize: 25.sp,
                          overflow: TextOverflow.visible),
                    ],
                  ),
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
