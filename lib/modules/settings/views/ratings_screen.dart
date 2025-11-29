import 'package:gorider/core/utils/exports.dart';

class RatingsScreen extends StatefulWidget {
  const RatingsScreen({super.key});

  @override
  State<RatingsScreen> createState() => _RatingsScreenState();
}

class _RatingsScreenState extends State<RatingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SettingsController>().getRatingStats();
    });
  }

  void _showDateFilterBottomSheet(BuildContext context) {
    final controller = Get.find<SettingsController>();
    DateTime? tempStartDate = controller.ratingStartDate;
    DateTime? tempEndDate = controller.ratingEndDate;

    showAnyBottomSheet(
      child: StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.all(20.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customText(
                      "Filter by Date",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                    InkWell(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        size: 24.sp,
                        color: AppColors.greyColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Start Date
                customText(
                  "Start Date",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: tempStartDate ??
                          DateTime.now().subtract(const Duration(days: 30)),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.primaryColor,
                              onPrimary: AppColors.whiteColor,
                              onSurface: AppColors.blackColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setModalState(() {
                        tempStartDate = picked;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          tempStartDate != null
                              ? "${tempStartDate!.day}/${tempStartDate!.month}/${tempStartDate!.year}"
                              : "Select start date",
                          fontSize: 14.sp,
                          color: tempStartDate != null
                              ? AppColors.blackColor
                              : AppColors.greyColor,
                        ),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 20.sp,
                          color: AppColors.greyColor,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // End Date
                customText(
                  "End Date",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackColor,
                ),
                SizedBox(height: 8.h),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: tempEndDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.primaryColor,
                              onPrimary: AppColors.whiteColor,
                              onSurface: AppColors.blackColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setModalState(() {
                        tempEndDate = picked;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          tempEndDate != null
                              ? "${tempEndDate!.day}/${tempEndDate!.month}/${tempEndDate!.year}"
                              : "Select end date",
                          fontSize: 14.sp,
                          color: tempEndDate != null
                              ? AppColors.blackColor
                              : AppColors.greyColor,
                        ),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 20.sp,
                          color: AppColors.greyColor,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          controller.clearRatingDateFilter();
                          Get.back();
                        },
                        title: "Clear",
                        backgroundColor: AppColors.backgroundColor,
                        fontColor: AppColors.blackColor,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          if (tempStartDate != null && tempEndDate != null) {
                            if (tempEndDate!.isBefore(tempStartDate!)) {
                              showToast(
                                  message: "End date must be after start date",
                                  isError: true);
                              return;
                            }
                            controller.setRatingDateRange(
                                tempStartDate, tempEndDate);
                            Get.back();
                          } else {
                            showToast(
                                message: "Please select both dates",
                                isError: true);
                          }
                        },
                        title: "Apply",
                        backgroundColor: AppColors.primaryColor,
                        fontColor: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (controller) {
        final stats = controller.ratingStats;
        final isLoading = controller.isFetchingRatingStats;

        return Scaffold(
          appBar: defaultAppBar(
            title: "Ratings",
            centerTitle: true,
            actionItem: IconButton(
              onPressed: () => _showDateFilterBottomSheet(context),
              icon: Stack(
                children: [
                  Icon(
                    Icons.filter_list_rounded,
                    color: AppColors.blackColor,
                    size: 24.sp,
                  ),
                  if (controller.ratingStartDate != null)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8.sp,
                        height: 8.sp,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          backgroundColor: AppColors.backgroundColor,
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await controller.getRatingStats();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date Range Indicator
                        if (controller.ratingStartDate != null &&
                            controller.ratingEndDate != null)
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 16.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.date_range,
                                  size: 18.sp,
                                  color: AppColors.primaryColor,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: customText(
                                    "${controller.ratingStartDate!.day}/${controller.ratingStartDate!.month}/${controller.ratingStartDate!.year} - ${controller.ratingEndDate!.day}/${controller.ratingEndDate!.month}/${controller.ratingEndDate!.year}",
                                    fontSize: 13.sp,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                InkWell(
                                  onTap: () =>
                                      controller.clearRatingDateFilter(),
                                  child: Icon(
                                    Icons.close,
                                    size: 18.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Average Rating Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.sp),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryColor.withOpacity(0.8)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Column(
                            children: [
                              customText(
                                "Average Rating",
                                fontSize: 14.sp,
                                color:
                                    AppColors.whiteColor.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 12.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  customText(
                                    stats?.averageRating?.toStringAsFixed(1) ?? '0.0',
                                    fontSize: 48.sp,
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: customText(
                                      "/5",
                                      fontSize: 20.sp,
                                      color: AppColors.whiteColor
                                          .withOpacity(0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              RatingBarIndicator(
                                rating: stats?.averageRating?.toDouble() ?? 0.0,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 28.sp,
                                direction: Axis.horizontal,
                              ),
                              SizedBox(height: 8.h),
                              customText(
                                "${stats?.totalRatings ?? 0} ratings",
                                fontSize: 14.sp,
                                color:
                                    AppColors.whiteColor.withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Stats Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                title: "Total Orders",
                                value: "${stats?.totalOrders ?? 0}",
                                icon: Icons.electric_bike_outlined,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: _buildStatCard(
                                title: "Completed",
                                value: "${stats?.completedOrders ?? 0}",
                                icon: Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // Rating Breakdown
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.sp),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customText(
                                "Rating Breakdown",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blackColor,
                              ),
                              SizedBox(height: 16.h),
                              _buildRatingBar(
                                  5,
                                  stats?.ratingBreakdown?.fiveStar ?? 0,
                                  stats?.totalRatings ?? 0),
                              SizedBox(height: 10.h),
                              _buildRatingBar(
                                  4,
                                  stats?.ratingBreakdown?.fourStar ?? 0,
                                  stats?.totalRatings ?? 0),
                              SizedBox(height: 10.h),
                              _buildRatingBar(
                                  3,
                                  stats?.ratingBreakdown?.threeStar ?? 0,
                                  stats?.totalRatings ?? 0),
                              SizedBox(height: 10.h),
                              _buildRatingBar(
                                  2,
                                  stats?.ratingBreakdown?.twoStar ?? 0,
                                  stats?.totalRatings ?? 0),
                              SizedBox(height: 10.h),
                              _buildRatingBar(
                                  1,
                                  stats?.ratingBreakdown?.oneStar ?? 0,
                                  stats?.totalRatings ?? 0),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),

                        // Rating Percentage Card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.sp),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12.sp),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Icon(
                                  Icons.percent,
                                  color: AppColors.primaryColor,
                                  size: 24.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customText(
                                      "Rating Percentage",
                                      fontSize: 14.sp,
                                      color: AppColors.greyColor,
                                    ),
                                    SizedBox(height: 4.h),
                                    customText(
                                      "${stats?.ratingPercentage?.toStringAsFixed(1) ?? '0'}%",
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.blackColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(height: 12.h),
          customText(
            value,
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 4.h),
          customText(
            title,
            fontSize: 12.sp,
            color: AppColors.greyColor,
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int count, int total) {
    double percentage = total > 0 ? (count / total) : 0;

    return Row(
      children: [
        SizedBox(
          width: 20.w,
          child: customText(
            "$stars",
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.blackColor,
          ),
        ),
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 16.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColors.greyColor.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 8.h,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        SizedBox(
          width: 40.w,
          child: customText(
            "$count",
            fontSize: 14.sp,
            color: AppColors.greyColor,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
