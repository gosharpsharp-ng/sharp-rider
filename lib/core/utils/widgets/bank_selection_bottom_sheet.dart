import 'package:gorider/core/utils/exports.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BankSelectionBottomSheet extends StatelessWidget {
  const BankSelectionBottomSheet({
    super.key,
    required this.onBankSelected,
    required this.banks,
    required this.isLoading,
    required this.searchController,
    required this.onSearch,
    required this.onReload,
  });

  final Function(BankModel) onBankSelected;
  final List<BankModel> banks;
  final bool isLoading;
  final TextEditingController searchController;
  final Function(String) onSearch;
  final VoidCallback onReload;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 20.sp,
        bottom: 12.sp,
        left: 14.sp,
        right: 14.sp,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      height: 0.6.sh,
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: customText(
                  "Select Bank",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                ),
              ),
              InkWell(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: AppColors.greyColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: AppColors.greyColor,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Search field
          CustomOutlinedRoundedInputField(
            labelColor: AppColors.blackColor,
            cursorColor: AppColors.blackColor,
            label: "Search bank name",
            controller: searchController,
            prefixWidget: const Icon(
              Icons.search,
              color: AppColors.greyColor,
            ),
            onChanged: (val) {
              onSearch(val.toString());
            },
          ),
          SizedBox(height: 16.h),

          // Bank list
          Expanded(
            child: Builder(builder: (context) {
              // Show skeleton loader when loading
              if (isLoading) {
                return _buildSkeletonLoader();
              }

              // Show empty/error state
              if (banks.isEmpty) {
                return _buildEmptyState(onReload: onReload);
              }

              // Show bank list
              return ListView.separated(
                itemCount: banks.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: AppColors.greyColor.withOpacity(0.2),
                ),
                itemBuilder: (context, index) {
                  final bank = banks[index];
                  return InkWell(
                    onTap: () {
                      onBankSelected(bank);
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 14.h,
                        horizontal: 8.w,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.sp,
                            height: 40.sp,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.account_balance,
                              color: AppColors.primaryColor,
                              size: 20.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: customText(
                              bank.name,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blackColor,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: AppColors.greyColor,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
            child: Row(
              children: [
                Container(
                  width: 40.sp,
                  height: 40.sp,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Bone.text(
                    words: 2,
                    fontSize: 16.sp,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.greyColor,
                  size: 20.sp,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({required VoidCallback onReload}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.sp,
            height: 80.sp,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_outlined,
              size: 40.sp,
              color: AppColors.greyColor,
            ),
          ),
          SizedBox(height: 16.h),
          customText(
            "No banks found",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          SizedBox(height: 8.h),
          customText(
            "Unable to load bank list",
            fontSize: 14.sp,
            color: AppColors.greyColor,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: onReload,
            icon: Icon(
              Icons.refresh,
              color: AppColors.whiteColor,
              size: 18.sp,
            ),
            label: customText(
              "Retry",
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.whiteColor,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
