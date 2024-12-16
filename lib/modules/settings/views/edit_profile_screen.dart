
import 'package:go_logistics_driver/utils/exports.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(
        implyLeading: true,
        bgColor: AppColors.backgroundColor,
        title: "Edit Profile",
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

                  SizedBox(
                    height: 15.h,
                  ),
                  CircleAvatar(
                    backgroundImage: const AssetImage(PngAssets.avatarIcon),
                    radius: 55.r,
                  ),
                  SizedBox(
                    height: 8.sp,
                  ),
                  EditIcon(onPressed: () {
                    // showModalBottomSheet(
                    //     context: context,
                    //     shape: const RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.vertical(
                    //         top: Radius.circular(25.0),
                    //       ),
                    //     ),
                    //     builder: (BuildContext context) {
                    //       return CustomImagePickerBottomSheet(
                    //         title: "Change Profile Photo",
                    //         takePhotoFunction: () {
                    //           profileProvider.pickUserProfilePicture(
                    //               pickFromCamera: true);
                    //         },
                    //         selectFromGalleryFunction: () {
                    //           profileProvider.pickUserProfilePicture(
                    //               pickFromCamera: false);
                    //         },
                    //         deleteFunction: () {},
                    //       );
                    //     });
                  }, isLoading: false,title: "Change",),
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
                  ),  const CustomRoundedInputField(
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
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  onPressed: () {
                    showAnyBottomSheet(
                        isControlled: false,
                        child: ProfileUpdateSuccessBottomSheet());
                  },
                  // isBusy: signInProvider.isLoading,
                  title: "Save",
                  width: 1.sw,
                  backgroundColor: AppColors.primaryColor,
                  fontColor: AppColors.whiteColor,
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
