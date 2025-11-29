import 'package:gorider/core/utils/exports.dart';

class WithdrawalPinBottomSheet extends StatelessWidget {
  WithdrawalPinBottomSheet({super.key});
  TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh * 0.3,
      width: 1.sw,
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 10.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.h,
          ),
          customText("Pay ₦15,000.00",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              fontFamily: GoogleFonts.inter().fontFamily!,
              color: AppColors.blackColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.w700),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomPinInput(
                        maxLength: 4,
                        controller: pinController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "OTP is required";
                          } else if (val.length < 4) {
                            return "OTP is not complete";
                          } else {
                            return null;
                          }
                        },
                        onDone: (val) {
                          showAnyBottomSheet(
                              child: WithdrawalSuccessBottomSheet());
                        },
                      ),
                    ],
                  )),
              InkWell(
                onTap: () {},
                child: const Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.primaryColor,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          InkWell(
            onTap: () {},
            child: customText("Forgot PIN?",
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                fontFamily: GoogleFonts.inter().fontFamily!,
                color: AppColors.primaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}
