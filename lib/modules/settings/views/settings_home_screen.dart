

import 'package:go_logistics_driver/utils/exports.dart';

class SettingsHomeScreen extends StatelessWidget {
  const SettingsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        implyLeading: false,
        bgColor: AppColors.backgroundColor,
        title: "Settings",
        centerTitle: false,
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
                  CircleAvatar(
                    backgroundImage: const AssetImage(PngAssets.avatarIcon),radius: 40.r,
                  ),
                  SizedBox(height: 5.h,),
                  customText(
                    "Ayodeji Sebanjo",
                    color: AppColors.blackColor,
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.visible,
                  ),
                  SizedBox(height: 5.h,),
                  customText(
                    "ayoniyi28@gmail.com",
                    color: AppColors.obscureTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
              SectionBox(children: [
                SettingsItem(onPressed: (){
                  Get.to(const ProfileSettingsScreen());
                }, title: "Edit Profile",icon: SvgAssets.profileIcon,),
                SettingsItem(onPressed: (){  Get.to(const NotificationsHomeScreen());}, title: "Notification",icon: SvgAssets.notificationIcon,),
                SettingsItem(onPressed: (){
                  Get.to(const CurrentPasswordEntryScreen());
                }, title: "Change Password",icon: SvgAssets.passwordChangeIcon,),
                SettingsItem(onPressed: (){
                  Get.to( FaqScreen());
                }, title: "FAQS",icon: SvgAssets.faqsIcon,),
                SettingsItem(onPressed: (){}, title: "Help and Support",icon: SvgAssets.supportIcon,),
                SettingsItem(onPressed: (){}, title: "Privacy Policy",icon: SvgAssets.profileIcon,),
                SettingsItem(onPressed: (){}, title: "Language",icon: SvgAssets.languageIcon,),
                SettingsItem(onPressed: (){}, title: "Security",icon: SvgAssets.securityIcon,),
                SettingsItem(onPressed: (){
                  Get.to(const SignInScreen());
                }, title: "Logout",icon: SvgAssets.logoutIcon,isLogout: true,isLast: true,),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
