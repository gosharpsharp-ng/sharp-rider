import 'package:gorider/core/utils/exports.dart';

class TransactionDetailSummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isVertical;

  const TransactionDetailSummaryItem({
    super.key,
    this.title = "",
    this.value = "",
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: AppColors.whiteColor,
      ),
      child: isVertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  title,
                  color: AppColors.obscureTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
                SizedBox(height: 8.h),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontFamily: title == "Amount"
                      ? GoogleFonts.inter().fontFamily!
                      : "Satoshi",
                  fontSize: 14.sp,
                  fontWeight:
                      title == "Amount" ? FontWeight.w600 : FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(
                  title,
                  color: AppColors.obscureTextColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                ),
                Flexible(
                  child: customText(
                    value,
                    color: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontFamily: title == "Amount"
                        ? GoogleFonts.inter().fontFamily!
                        : "Satoshi",
                    fontWeight:
                        title == "Amount" ? FontWeight.w600 : FontWeight.w500,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
    );
  }
}

class TransactionDetailSummaryTypeItem extends StatelessWidget {
  final String title;
  final String value;

  const TransactionDetailSummaryTypeItem({
    super.key,
    this.title = "",
    this.value = "",
  });

  @override
  Widget build(BuildContext context) {
    final isWithdrawal = value.toLowerCase() == 'withdrawal';
    final color = isWithdrawal ? AppColors.redColor : AppColors.primaryColor;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: AppColors.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          customText(
            title,
            color: AppColors.obscureTextColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isWithdrawal ? Icons.arrow_upward : Icons.arrow_downward,
                  color: color,
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                customText(
                  value,
                  color: color,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionDetailSummaryStatusItem extends StatelessWidget {
  final String title;
  final String value;

  const TransactionDetailSummaryStatusItem({
    super.key,
    this.title = "",
    this.value = "",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
        color: AppColors.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          customText(
            title,
            color: AppColors.obscureTextColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
          Container(
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: _getStatusColor().withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getStatusIcon(),
                  color: _getStatusColor(),
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                customText(
                  value,
                  color: _getStatusColor(),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (value.toLowerCase()) {
      case 'successful':
      case 'completed':
      case 'success':
        return AppColors.forestGreenColor;
      case 'pending':
        return AppColors.amberColor;
      case 'processing':
        return AppColors.primaryColor;
      case 'failed':
      case 'rejected':
      case 'cancelled':
        return AppColors.redColor;
      default:
        return AppColors.greyColor;
    }
  }

  IconData _getStatusIcon() {
    switch (value.toLowerCase()) {
      case 'successful':
      case 'completed':
      case 'success':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'processing':
        return Icons.sync;
      case 'failed':
        return Icons.error_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      case 'cancelled':
        return Icons.block;
      default:
        return Icons.help_outline;
    }
  }
}
