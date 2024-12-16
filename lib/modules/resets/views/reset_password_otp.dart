import 'package:go_logistics_driver/utils/exports.dart';

class ResetPasswordOtpScreen extends StatelessWidget {
  ResetPasswordOtpScreen({super.key});
  TextEditingController pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: defaultAppBar(
          title: "Verify OTP", bgColor: AppColors.backgroundColor),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 20.sp),
          child: TitleSectionBox(
            title: "Enter the 4 digit OTP code sent to your email",
            backgroundColor: AppColors.whiteColor,
            children: [
              SizedBox(
                height: 25.sp,
              ),
              CustomPinInput(maxLength: 4, controller: pinController),
              SizedBox(
                height: 30.sp,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: customText("Didn’t get the code? Resend",
                        fontWeight: FontWeight.bold,
                        textAlign: TextAlign.start,
                        fontSize: 15.sp,
                        color: AppColors.blackColor),
                  ),
                  customText("Expires in 01:30",
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.start,
                      fontSize: 15.sp,
                      color: AppColors.blackColor),
                ],
              ),
              SizedBox(
                height: 50.sp,
              ),
              CustomButton(
                onPressed: () {
                  Get.to(NewPasswordScreen());
                },
                backgroundColor: AppColors.primaryColor,
                title: "Verify",
                fontColor: AppColors.whiteColor,
                width: double.infinity,
              ),
              SizedBox(
                height: 30.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
