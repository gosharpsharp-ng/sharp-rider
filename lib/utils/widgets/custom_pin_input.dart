import 'package:go_logistics_driver/utils/exports.dart';


class CustomPinInput extends StatelessWidget {
  final String? title;
  final int maxLength;
  final TextEditingController controller;

  final Function(String)? onDone;
  final Function(String)? onChanged;

  const CustomPinInput({
    super.key,
    this.title,
    this.onDone,
    required this.maxLength,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title == null
            ? const SizedBox()
            : Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Text(
                  title!,
                  style: GoogleFonts.dmSans(
                    color: AppColors.obscureTextColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                )),
        Pinput(
          androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
          defaultPinTheme: PinTheme(
            width: 48.h,
            height: 48.h,
            textStyle: GoogleFonts.dmSans(
              color: AppColors.blackColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.disabledColor, width: 1.h),
            ),
          ),
          followingPinTheme: PinTheme(
              width: 48.h,
              height: 48.h,
              textStyle: GoogleFonts.dmSans(
                color: AppColors.blackColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.blackColor.withOpacity(0.5), width: 1.h))),
          submittedPinTheme: PinTheme(
            width: 48.h,
            height: 48.h,
            textStyle: GoogleFonts.dmSans(
              color: AppColors.blackColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.disabledColor, width: 1.h),
            ),
          ),
          focusedPinTheme: PinTheme(
              width: 48.h,
              height: 48.h,
              textStyle: GoogleFonts.dmSans(
                color: AppColors.blackColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.primaryColor,
                    width: 1.h,
                  ))),
          length: maxLength,
          onCompleted: onDone,
          controller: controller,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
        )
      ],
    );
  }
}
