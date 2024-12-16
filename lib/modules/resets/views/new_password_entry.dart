import 'package:go_logistics_driver/utils/exports.dart';
class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

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
            title:  "Your new password must be different from the previous password!",
            children: [
              SizedBox(
                height: 25.sp,
              ),
              CustomRoundedInputField(
                label: "New Password",
                title: "New Password",
                hasTitle: true,
                showLabel: true,
                obscureText: true,
                isRequired: true,
                suffixWidget: InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.visibility,
                      size: 25.sp,
                    )),
              ),
              SizedBox(
                height: 18.sp,
              ),
              CustomRoundedInputField(
                label: "Confirm Password",
                title: "Confirm Password",
                showLabel: true,
                hasTitle: true,
                isRequired: true,
                obscureText: true,
                suffixWidget: InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.visibility,
                      size: 25.sp,
                    )),
              ),
              SizedBox(
                height: 32.sp,
              ),
              CustomButton(
                onPressed: () {
                  // Get.to(LoginScreen());
                },
                backgroundColor: AppColors.primaryColor,
                title: "Reset Password",
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
