import 'dart:io';
import 'package:go_logistics_driver/utils/exports.dart';



class SettingsController extends GetxController {
  final profileService = serviceLocator<ProfileService>();

  // Initial values for comparison
  String? initialFName;
  String? initialLName;
  String? initialEmail;
  String? initialPhone;
  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  UserProfile? userProfile;
  getProfile() async {
    setLoadingState(true);
    APIResponse response = await profileService.getProfile();

    setLoadingState(false);
    if (response.status == "success") {
      userProfile = UserProfile.fromJson(response.data);
      update();
      setProfileFields();
    }else{
      showToast(message: response.message, isError: response.status != "success");
    }
  }

  setProfileFields() {
    // Store initial values
    initialFName = userProfile?.fname ?? "";
    initialLName = userProfile?.lname ?? "";
    initialEmail = userProfile?.email ?? "";
    initialPhone = userProfile?.phone ?? "";

    fNameController.text = initialFName!;
    lNameController.text = initialLName!;
    emailController.text = initialEmail!;
    phoneController.text = initialPhone!;
    update();
  }

  final profileUpdateFormKey = GlobalKey<FormState>();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  updateUserProfile() async {
    if (profileUpdateFormKey.currentState!.validate()) {
      setLoadingState(true);
      Map<String, dynamic> updatedData = {};
      if (fNameController.text != initialFName) {
        updatedData['fname'] = fNameController.text;
      }
      if (lNameController.text != initialLName) {
        updatedData['lname'] = lNameController.text;
      }

      APIResponse response = await profileService.updateProfile(updatedData);

      setLoadingState(false);
      if (response.status == "success") {
        getProfile();
        showAnyBottomSheet(
            isControlled: false,
            child: const ProfileUpdateSuccessBottomSheet());
      } else {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  bool isUpdatingAvatar = false;
  setLoadingProfileAvatarState(bool val) {
    isUpdatingAvatar = val;
    update();
  }

  final ImagePicker _picker = ImagePicker();
  File? userProfilePicture;
  pickUserProfilePicture({required bool pickFromCamera}) async {
    XFile? photo;
    if (pickFromCamera) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (photo != null) {
      final croppedPhoto = await cropImage(photo);
      userProfilePicture = File(croppedPhoto.path);
      update();
      setLoadingProfileAvatarState(true);
      dynamic data = {'avatar': userProfilePicture};
      APIResponse response = await profileService.updateProfile(data);
      if (response.status == "success") {
        getProfile();
        showAnyBottomSheet(
            isControlled: false,
            child: const ProfileUpdateSuccessBottomSheet());
      } else {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
    setLoadingProfileAvatarState(false);
  }

  @override
  void onInit() {
    super.onInit();
    // Load profile when the controller is initialized
    getProfile();
  }
}
