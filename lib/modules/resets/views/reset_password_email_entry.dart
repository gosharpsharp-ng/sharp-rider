
import 'package:go_logistics_driver/utils/exports.dart';


class ResetPasswordEmailEntry extends StatelessWidget {
  const ResetPasswordEmailEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar:defaultAppBar(title: "Reset password",bgColor: AppColors.backgroundColor),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 20.sp),
          child: TitleSectionBox(
            backgroundColor: AppColors.whiteColor,
       title: "Enter your email address",
            children: [

              SizedBox(
                height: 20.sp,
              ),

              const CustomRoundedInputField(
                label: "Email",
                title: "Email",
                hasTitle: true,
                showLabel: true,
                isRequired: true,
              ),
              SizedBox(
                height: 40.sp,
              ),
              CustomButton(
                onPressed: () {
                  Get.to(ResetPasswordOtpScreen());
                },
                backgroundColor: AppColors.primaryColor,
                title: "Continue",
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
