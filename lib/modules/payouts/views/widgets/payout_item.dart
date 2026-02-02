import 'package:gorider/core/utils/exports.dart';

class PayoutItem extends StatelessWidget {
  final PayoutRequest payoutRequest;
  final Function onTap;

  const PayoutItem({
    super.key,
    required this.payoutRequest,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          children: [
            // Payout Icon with Status Color
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                _getStatusIcon(),
                color: _getStatusColor(),
                size: 24.sp,
              ),
            ),

            SizedBox(width: 12.w),

            // Payout Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: customText(
                          payoutRequest.ref,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      customText(
                        formatToCurrency(payoutRequest.amountDouble),
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Satoshi",
                        fontSize: 16.sp,
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: customText(
                          payoutRequest.paymentMethodDisplayText,
                          color: AppColors.greyColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      customText(
                        payoutRequest.formattedRequestedAt,
                        color: AppColors.greyColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: _getStatusColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: _getStatusColor().withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: customText(
                          payoutRequest.statusDisplayText,
                          color: _getStatusColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.greyColor.withOpacity(0.6),
                        size: 14.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (payoutRequest.status.toLowerCase()) {
      case 'pending':
        return AppColors.amberColor;
      case 'approved':
        return AppColors.blueColor;
      case 'processed':
        return AppColors.primaryColor;
      case 'completed':
        return AppColors.forestGreenColor;
      case 'rejected':
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.greyColor;
    }
  }

  IconData _getStatusIcon() {
    switch (payoutRequest.status.toLowerCase()) {
      case 'pending':
        return Icons.schedule;
      case 'approved':
        return Icons.check_circle_outline;
      case 'processed':
        return Icons.sync;
      case 'completed':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel_outlined;
      case 'cancelled':
        return Icons.block;
      default:
        return Icons.help_outline;
    }
  }
}
