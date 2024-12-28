
import 'package:go_logistics_driver/utils/exports.dart';



class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Form(
        key: settingsController.profileUpdateFormKey,
        child: Scaffold(
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
                      Visibility(
                        visible: settingsController.userProfile?.avatar != null,
                        replacement: Visibility(
                          visible: settingsController.userProfilePicture != null,
                          replacement: CircleAvatar(
                            radius: 55.r,
                            backgroundColor: AppColors.backgroundColor,
                            child: customText(
                              "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                              fontSize: 24.sp,
                            ),
                          ),
                          child: settingsController.userProfilePicture != null
                              ? CircleAvatar(
                            backgroundImage: FileImage(settingsController.userProfilePicture!),
                            radius: 55.r,
                          )
                              : CircleAvatar(
                            backgroundImage: const AssetImage(PngAssets.avatarIcon),
                            radius: 55.r,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage:  NetworkImage(settingsController.userProfile!.avatar??''),
                          radius: 55.r,
                        ),
                      ),
                      SizedBox(
                        height: 8.sp,
                      ),
                      EditIcon(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return CustomImagePickerBottomSheet(
                                  title: "Change Profile Photo",
                                  takePhotoFunction: () {
                                    settingsController.pickUserProfilePicture(
                                        pickFromCamera: true);
                                  },
                                  selectFromGalleryFunction: () {
                                    settingsController.pickUserProfilePicture(
                                        pickFromCamera: false);
                                  },
                                  deleteFunction: () {},
                                );
                              });
                        },
                        isLoading: settingsController.isUpdatingAvatar,
                        title: "Change",
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomRoundedInputField(
                        title: "First name",
                        label: "John",
                        showLabel: true,
                        hasTitle: true,
                        controller: settingsController.fNameController,
                      ),
                      CustomRoundedInputField(
                        title: "Last name",
                        label: "Does",
                        showLabel: true,
                        hasTitle: true,
                        controller: settingsController.lNameController,
                      ),
                      CustomRoundedInputField(
                        title: "Email",
                        label: "johndoe@gmail.com",
                        showLabel: true,
                        hasTitle: true,
                        readOnly: true,
                        controller: settingsController.emailController,
                        // controller: signInProvider.emailController,
                      ),
                      CustomRoundedPhoneInputField(
                        title: "Phone number",
                        label: "7061046672",
                        showLabel: true,
                        hasTitle: true,
                        readOnly: true,
                        validator: (phone) {
                          if (phone == null || phone.completeNumber.isEmpty) {
                            return "Phone number is required";
                          }
                          // Regex: `+` followed by 1 to 3 digits (country code), then 10 digits (phone number)
                          final regex = RegExp(r'^\+234[1-9]\d{9}$');
                          if (!regex.hasMatch(phone.completeNumber)) {
                            return "Phone number must start with +234 and be 10 digits long";
                          }

                          return null; // Valid phone number
                        },
                        controller: settingsController.phoneController,
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
                        settingsController.updateUserProfile();
                      },
                      // isBusy: signInProvider.isLoading,
                      title: "Save",
                      width: 1.sw,
                      isBusy: settingsController.isLoading,
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
        ),
      );
    });
  }
}
