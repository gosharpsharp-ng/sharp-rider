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
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      height: 0.7.sh,
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.greyColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        AppColors.primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.account_balance,
                    color: AppColors.whiteColor,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        "Select Bank",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                      SizedBox(height: 2.h),
                      customText(
                        "Choose your preferred bank",
                        fontSize: 13.sp,
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Get.back(),
                  borderRadius: BorderRadius.circular(20.r),
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
          ),

          SizedBox(height: 20.h),

          // Search field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: AppColors.greyColor.withOpacity(0.15),
                ),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (val) => onSearch(val),
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.blackColor,
                ),
                decoration: InputDecoration(
                  hintText: "Search bank name...",
                  hintStyle: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.greyColor,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.greyColor,
                    size: 22.sp,
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            searchController.clear();
                            onSearch('');
                          },
                          child: Icon(
                            Icons.clear_rounded,
                            color: AppColors.greyColor,
                            size: 20.sp,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Divider
          Divider(
            height: 1,
            color: AppColors.greyColor.withOpacity(0.15),
          ),

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
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                itemCount: banks.length,
                itemBuilder: (context, index) {
                  final bank = banks[index];
                  return _BankListItem(
                    bank: bank,
                    onTap: () {
                      onBankSelected(bank);
                      Get.back();
                    },
                  );
                },
              );
            }),
          ),

          // Bottom safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(14.sp),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.greyColor.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48.sp,
                  height: 48.sp,
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Bone.text(
                    words: 2,
                    fontSize: 16.sp,
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.greyColor,
                  size: 22.sp,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({required VoidCallback onReload}) {
    final hasSearchQuery = searchController.text.isNotEmpty;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.sp),
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasSearchQuery
                    ? Icons.search_off_rounded
                    : Icons.account_balance_outlined,
                size: 56.sp,
                color: AppColors.greyColor,
              ),
            ),
            SizedBox(height: 20.h),
            customText(
              hasSearchQuery ? "No banks found" : "Unable to load banks",
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
            SizedBox(height: 8.h),
            customText(
              hasSearchQuery
                  ? "Try searching with a different name"
                  : "Please check your connection and try again",
              fontSize: 14.sp,
              color: AppColors.greyColor,
              textAlign: TextAlign.center,
            ),
            if (!hasSearchQuery) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: onReload,
                icon: Icon(
                  Icons.refresh_rounded,
                  color: AppColors.whiteColor,
                  size: 20.sp,
                ),
                label: customText(
                  "Try Again",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.whiteColor,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Individual bank list item with beautiful styling
class _BankListItem extends StatelessWidget {
  const _BankListItem({
    required this.bank,
    required this.onTap,
  });

  final BankModel bank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.greyColor.withOpacity(0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Bank Icon with gradient background
            Container(
              width: 48.sp,
              height: 48.sp,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.15),
                    AppColors.primaryColor.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: customText(
                  _getBankInitials(bank.name),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),

            SizedBox(width: 14.w),

            // Bank name
            Expanded(
              child: customText(
                bank.name,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.blackColor,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(width: 8.w),

            // Arrow icon
            Container(
              padding: EdgeInsets.all(6.sp),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.primaryColor,
                size: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get initials from bank name (first 2 letters)
  String _getBankInitials(String name) {
    if (name.isEmpty) return "BK";

    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }
}
