import 'package:gorider/core/utils/exports.dart';

class WithdrawalSuccessBottomSheet extends StatelessWidget {
  const WithdrawalSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 300.h,
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 15.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            SvgAssets.successIcon,
            height: 45.h,
            width: 45.h,
          ),
          SizedBox(
            height: 10.h,
          ),
          customText(
            "Withdrawal successful",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            color: AppColors.primaryColor,
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: 20.h,
          ),
          customText(
              "Your money is on it's way to the bank account you provided",
              overflow: TextOverflow.visible,
              color: AppColors.blackColor,
              textAlign: TextAlign.center,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onPressed: () {
                Get.back();
              },
              // isBusy: signInProvider.isLoading,
              title: "Ok",
              width: 1.sw,
              backgroundColor: AppColors.primaryColor,
              fontColor: AppColors.whiteColor,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }
}
