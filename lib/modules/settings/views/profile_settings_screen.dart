import 'package:go_logistics_driver/utils/exports.dart';

class ProfileSettingsScreen extends StatelessWidget {
  const ProfileSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        implyLeading: true,
        bgColor: AppColors.backgroundColor,
        title: "Profile",
        centerTitle: false,
        actionItem:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          child: EditIcon(onPressed: () {
            Get.to(EditProfileScreen());
          }),
        )
      ),
      body: Container(
        height: 1.sh,
        width: 1.sw,
        color: AppColors.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SectionBox(
                crossAxisAlignment: CrossAxisAlignment.center,
                backgroundColor: AppColors.whiteColor,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),

                  SizedBox(
                    height: 15.h,
                  ),
                  CircleAvatar(
                    backgroundImage: const AssetImage(PngAssets.avatarIcon),
                    radius: 55.r,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  const CustomRoundedInputField(
                    title: "First name",
                    label: "John",
                    showLabel: true,
                    hasTitle: true,
                    readOnly: true,
                    // controller: signInProvider.emailController,
                  ),
                  const CustomRoundedInputField(
                    title: "Last name",
                    label: "Does",
                    showLabel: true,
                    hasTitle: true,
                    readOnly: true,
                    // controller: signInProvider.emailController,
                  ),
                  const CustomRoundedInputField(
                    title: "Email",
                    label: "johndoe@gmail.com",
                    showLabel: true,
                    hasTitle: true,
                    readOnly: true,
                    // controller: signInProvider.emailController,
                  ),
                  const CustomRoundedInputField(
                    title: "Date of Birth",
                    label: "23-01-1991",
                    showLabel: true,
                    hasTitle: true,
                    readOnly: true,
                    // controller: signInProvider.emailController,
                  ),
                  const CustomRoundedInputField(
                    title: "Address",
                    label: "Jos, Plateau State Nigeria",
                    showLabel: true,
                    hasTitle: true,
                    readOnly: true,
                    // controller: signInProvider.emailController,
                  ),
                  const CustomRoundedInputField(
                    title: "Phone number",
                    label: "7061046672",
                    showLabel: true,
                    isPhone: true,
                    hasTitle: true,
                    readOnly: true,
                    // controller: signInProvider.emailController,
                  ),
                  ClickableCustomRoundedInputField(
                    title: "Gender",
                    label: "Select",
                    showLabel: true,
                    hasTitle: true,
                    readOnly: true,
                    suffixWidget: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        SvgAssets.downChevronIcon,
                        // h: 20.sp,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    // controller: signInProvider.emailController,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
