import 'package:gorider/core/utils/exports.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BankDetailsScreen extends StatefulWidget {
  const BankDetailsScreen({super.key});

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  bool _isLoading = true;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadBankDetails();
  }

  Future<void> _loadBankDetails() async {
    if (_hasInitialized) return;
    _hasInitialized = true;

    final settingsController = Get.find<SettingsController>();

    // If profile is not loaded, fetch it
    if (settingsController.userProfile == null) {
      await settingsController.getProfile();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (settingsController) {
        final bankAccount = settingsController.userProfile?.bankAccount;

        return Scaffold(
          appBar: defaultAppBar(
            implyLeading: true,
            bgColor: AppColors.backgroundColor,
            title: "Bank Details",
            centerTitle: false,
          ),
          body: Container(
            height: 1.sh,
            width: 1.sw,
            color: AppColors.backgroundColor,
            child: _isLoading
                ? _buildSkeletonLoader()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        // Bank Account Details Section
                        if (bankAccount != null) ...[
                          SectionBox(
                            backgroundColor: AppColors.whiteColor,
                            children: [
                              SizedBox(height: 10.h),
                              // Bank Icon
                              Container(
                                width: 70.sp,
                                height: 70.sp,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withAlpha(10),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    SvgAssets.bankAccountIcon,
                                    width: 35.sp,
                                    height: 35.sp,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.primaryColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // Bank Name
                              _buildDetailRow(
                                label: "Bank Name",
                                value: bankAccount.bankName,
                              ),
                              SizedBox(height: 16.h),

                              // Account Number
                              _buildDetailRow(
                                label: "Account Number",
                                value: bankAccount.bankAccountNumber,
                              ),
                              SizedBox(height: 16.h),

                              // Account Name
                              _buildDetailRow(
                                label: "Account Name",
                                value: bankAccount.bankAccountName,
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // Update Bank Account Button
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.sp),
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(
                                    Routes.ADD_WITHDRAWAL_ACCOUNT_SCREEN);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.primaryColor,
                                      size: 20.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    customText(
                                      "Update Bank Account",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          // No Bank Account State
                          SizedBox(height: 50.h),
                          Container(
                            padding: EdgeInsets.all(30.sp),
                            margin: EdgeInsets.symmetric(horizontal: 20.sp),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 80.sp,
                                  height: 80.sp,
                                  decoration: const BoxDecoration(
                                    color: AppColors.backgroundColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      SvgAssets.bankAccountIcon,
                                      width: 40.sp,
                                      height: 40.sp,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.greyColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                customText(
                                  "No Bank Account Added",
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                                SizedBox(height: 8.h),
                                customText(
                                  "Add your bank account details to receive payouts",
                                  fontSize: 14.sp,
                                  color: AppColors.obscureTextColor,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 24.h),
                                CustomButton(
                                  onPressed: () {
                                    Get.toNamed(
                                        Routes.ADD_WITHDRAWAL_ACCOUNT_SCREEN);
                                  },
                                  title: "Add Bank Account",
                                  width: double.infinity,
                                  backgroundColor: AppColors.primaryColor,
                                  fontColor: AppColors.whiteColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonLoader() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SectionBox(
              backgroundColor: AppColors.whiteColor,
              children: [
                SizedBox(height: 10.h),
                // Bank Icon Skeleton
                Container(
                  width: 70.sp,
                  height: 70.sp,
                  decoration: const BoxDecoration(
                    color: AppColors.backgroundColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 20.h),

                // Bank Name Skeleton
                _buildDetailRow(
                  label: "Bank Name",
                  value: "First Bank of Nigeria",
                ),
                SizedBox(height: 16.h),

                // Account Number Skeleton
                _buildDetailRow(
                  label: "Account Number",
                  value: "1234567890",
                ),
                SizedBox(height: 16.h),

                // Account Name Skeleton
                _buildDetailRow(
                  label: "Account Name",
                  value: "John Doe Example",
                ),
                SizedBox(height: 20.h),
              ],
            ),
            SizedBox(height: 24.h),

            // Update Button Skeleton
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: AppColors.primaryColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    customText(
                      "Update Bank Account",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(
            label,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.obscureTextColor,
          ),
          Flexible(
            child: customText(
              value,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
