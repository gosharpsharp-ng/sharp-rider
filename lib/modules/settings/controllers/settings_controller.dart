import 'dart:io';
import 'package:gorider/core/models/rider_profile_response.dart';
import 'package:gorider/core/models/rider_stats_model.dart';
import 'package:gorider/core/utils/exports.dart';
import 'package:intl/intl.dart';

class SettingsController extends GetxController {
  final profileService = serviceLocator<ProfileService>();
  final serviceManager = Get.put(DeliveryNotificationServiceManager());

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
  var reactiveUserProfile = Rxn<UserProfile>();
  RiderProfileResponse? riderProfileResponse;

  getProfile() async {
    setLoadingState(true);
    APIResponse response = await profileService.getProfile();
    setLoadingState(false);
    if (response.status == "success") {
      // Parse the full rider profile response
      riderProfileResponse = RiderProfileResponse.fromJson(response.data);
      userProfile = riderProfileResponse!.user;
      reactiveUserProfile.value = riderProfileResponse!.user;

      // Update the vehicle license from the response if available
      if (riderProfileResponse!.driverLicense != null) {
        vehicleLicense = riderProfileResponse!.driverLicense;
      }

      update();
      // Zego Cloud temporarily disabled
      // ZegoUIKitPrebuiltCallInvitationService().init(
      //   appID: int.parse(Secret.zegoCloudAppID),
      //   appSign: Secret.zegoCloudAppSign,
      //   userID: userProfile!.id.toString(),
      //   userName: "${userProfile?.fname ?? ""} ${userProfile?.lname ?? ""}",
      //   plugins: [ZegoUIKitSignalingPlugin()],
      //   notificationConfig: ZegoCallInvitationNotificationConfig(
      //       androidNotificationConfig: ZegoCallAndroidNotificationConfig(
      //         sound: null,
      //         showFullScreen: true,
      //       ),
      //       iOSNotificationConfig:
      //           ZegoCallIOSNotificationConfig(appName: "gosharpsharp_mobile")),
      // );
      setProfileFields();
    } else {
      if (getStorage.read('token') != null) {
        showToast(
            message: response.message, isError: response.status != "success");
      }
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

  bool isProfileEditable = false;
  toggleProfileEditState(bool value) {
    isProfileEditable = value;
    update();
  }

  final changePasswordFormKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  bool oldPasswordVisibility = false;

  toggleOldPasswordVisibility() {
    oldPasswordVisibility = !oldPasswordVisibility;
    update();
  }

  bool newPasswordVisibility = false;

  toggleNewPasswordVisibility() {
    newPasswordVisibility = !newPasswordVisibility;
    update();
  }

  bool confirmNewPasswordVisibility = false;

  toggleConfirmNewPasswordVisibility() {
    confirmNewPasswordVisibility = !confirmNewPasswordVisibility;
    update();
  }

  changePassword() async {
    if (changePasswordFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        "old_password": oldPasswordController.text,
        "new_password": newPasswordController.text
      };

      APIResponse response = await profileService.changePassword(data);

      setLoadingState(false);
      showToast(
          message: response.message, isError: response.status != "success");
      if (response.status == "success") {
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();
        update();
        Get.back();
      }
    }
  }

  bool _isLoadingNotification = false;
  get isLoadingNotification => _isLoadingNotification;
  setLoadingNotificationState(bool val) {
    _isLoadingNotification = val;
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
        toggleProfileEditState(false);
        Get.back();
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
  String? userProfilePictureBase64;

  // Sharp-vendor pattern: Pick, crop, convert to base64, upload
  pickUserProfilePicture({required bool pickFromCamera}) async {
    XFile? photo;
    if (pickFromCamera) {
      photo = await _picker.pickImage(source: ImageSource.camera);
    } else {
      photo = await _picker.pickImage(source: ImageSource.gallery);
    }
    if (photo != null) {
      try {
        setLoadingProfileAvatarState(true);

        // Crop the image
        final croppedPhoto = await cropImage(photo);

        // Convert to base64 for API upload
        userProfilePictureBase64 =
            await Base64ImageUtils.convertImageToBase64(croppedPhoto.path);

        // Keep file for local display
        userProfilePicture = File(croppedPhoto.path);
        update();

        // Upload to server with base64 (include fname and lname like gosharpsharp-mobile)
        dynamic data = {
          'avatar': userProfilePictureBase64,
          'fname': userProfile?.fname ?? fNameController.text,
          'lname': userProfile?.lname ?? lNameController.text,
        };
        APIResponse response = await profileService.updateProfile(data);

        if (response.status == "success") {
          getProfile();
          Get.back();
          showAnyBottomSheet(
              isControlled: false,
              child: const ProfileUpdateSuccessBottomSheet());
        } else {
          showToast(
              message: response.message, isError: response.status != "success");
        }
      } catch (e) {
        showToast(message: "Error updating avatar: $e", isError: true);
      } finally {
        setLoadingProfileAvatarState(false);
      }
    }
  }

  bool _isLoadingVehicle = false;
  get isLoadingVehicle => _isLoadingVehicle;
  setLoadingVehicleState(bool val) {
    _isLoadingVehicle = val;
    update();
  }

  bool _isLoadingCourierTypes = false;
  get isLoadingCourierTypes => _isLoadingCourierTypes;
  setLoadingCourierTypesState(bool val) {
    _isLoadingCourierTypes = val;
    update();
  }

  List<CourierTypeModel> courierTypes = [];
  getCourierTypes() async {
    setLoadingCourierTypesState(true);
    APIResponse response = await profileService.getCourierTypes();
    setLoadingCourierTypesState(false);
    if (response.status == "success") {
      // Handle both response formats: direct list or nested under 'data'
      List<dynamic> courierTypesList;
      if (response.data is List) {
        courierTypesList = response.data as List;
      } else if (response.data is Map && response.data['data'] != null) {
        courierTypesList = response.data['data'] as List;
      } else {
        courierTypesList = [];
      }
      courierTypes = courierTypesList
          .map((ct) => CourierTypeModel.fromJson(ct))
          .toList();
      update();
    }
  }

  // VehicleModel? vehicleModel;
  // getMyVehicle() async {
  //   // setLoadingVehicleState(true);
  //   APIResponse response = await profileService.getVehicle();
  //   // setLoadingVehicleState(false);
  //   if (response.status == "success") {
  //     if (response.data.isNotEmpty) {
  //       vehicleModel = VehicleModel.fromJson(response.data[0]);
  //     }

  //     update();
  //   }
  // }

  LicenseModel? vehicleLicense;
  getMyVehicleLicense() async {
    // setLoadingVehicleState(true);
    APIResponse response = await profileService.getLicense();
    // setLoadingVehicleState(false);
    if (response.status == "success") {
      if (response.data.isNotEmpty) {
        vehicleLicense = LicenseModel.fromJson(response.data[0]);
        update();
      }
    }
  }

  CourierTypeModel? selectedCourierType;
  setSelectedCourierType(CourierTypeModel cType) {
    selectedCourierType = cType;
    vehicleCourierTypeController.text = cType.name;
    update();
  }

  // Sharp-vendor pattern: Vehicle images with base64 encoding
  File? vehicleInteriorPhoto;
  File? vehicleExteriorPhoto;
  String? vehicleInteriorPhotoBase64;
  String? vehicleExteriorPhotoBase64;

  Future<void> pickVehicleInteriorPhoto({required bool pickFromCamera}) async {
    try {
      XFile? photo;
      if (pickFromCamera) {
        photo = await _picker.pickImage(source: ImageSource.camera);
      } else {
        photo = await _picker.pickImage(source: ImageSource.gallery);
      }

      if (photo != null) {
        final croppedPhoto = await cropImage(photo);
        final compressed = await ImageCompressionService.compressImage(
          XFile(croppedPhoto.path),
        );
        vehicleInteriorPhotoBase64 =
            await Base64ImageUtils.convertImageToBase64(compressed.path);
        vehicleInteriorPhoto = File(compressed.path);
        update();
      }
    } catch (e) {
      showToast(message: "Error picking image: $e", isError: true);
    }
  }

  Future<void> pickVehicleExteriorPhoto({required bool pickFromCamera}) async {
    try {
      XFile? photo;
      if (pickFromCamera) {
        photo = await _picker.pickImage(source: ImageSource.camera);
      } else {
        photo = await _picker.pickImage(source: ImageSource.gallery);
      }

      if (photo != null) {
        final croppedPhoto = await cropImage(photo);
        final compressed = await ImageCompressionService.compressImage(
          XFile(croppedPhoto.path),
        );
        vehicleExteriorPhotoBase64 =
            await Base64ImageUtils.convertImageToBase64(compressed.path);
        vehicleExteriorPhoto = File(compressed.path);
        update();
      }
    } catch (e) {
      showToast(message: "Error picking image: $e", isError: true);
    }
  }

  void removeVehicleInteriorPhoto() {
    vehicleInteriorPhoto = null;
    vehicleInteriorPhotoBase64 = null;
    update();
  }

  void removeVehicleExteriorPhoto() {
    vehicleExteriorPhoto = null;
    vehicleExteriorPhotoBase64 = null;
    update();
  }

  void clearVehicleTextFields() {
    vehicleCourierTypeController.clear();
    vehicleBrandController.clear();
    vehicleModelController.clear();
    vehicleRegNumController.clear();
    vehicleYearController.clear();
    vehicleInteriorPhoto = null;
    vehicleExteriorPhoto = null;
    vehicleInteriorPhotoBase64 = null;
    vehicleExteriorPhotoBase64 = null;
  }

  final vehicleFormKey = GlobalKey<FormState>();
  TextEditingController vehicleCourierTypeController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleRegNumController = TextEditingController();
  TextEditingController vehicleYearController = TextEditingController();
  final getStorage = GetStorage();

  // Sharp-vendor pattern: Complete vehicle data with images
  addVehicleInfo() async {
    if (vehicleFormKey.currentState!.validate()) {
      setLoadingVehicleState(true);

      try {
        dynamic data = {
          "courier_type_id": selectedCourierType!.id,
          "brand": vehicleBrandController.text,
          "model": vehicleModelController.text,
          "reg_num": vehicleRegNumController.text,
          "year": int.tryParse(vehicleYearController.text),
        };

        // Add interior photo if available (optional)
        if (vehicleInteriorPhotoBase64 != null) {
          data['interior_photo'] = vehicleInteriorPhotoBase64;
        }

        // Add exterior photo if available (optional)
        if (vehicleExteriorPhotoBase64 != null) {
          data['exterior_photo'] = vehicleExteriorPhotoBase64;
        }

        APIResponse response = await profileService.addVehicle(data);

        if (response.status == "success") {
          showToast(message: response.message);
          getProfile();
          // getMyVehicle();
          clearVehicleTextFields();
          Navigator.pop(Get.context!);
        } else {
          if (getStorage.read("token") != null) {
            showToast(
                message: response.message,
                isError: response.status != "success");
          }
        }
      } catch (e) {
        showToast(message: "Error adding vehicle: $e", isError: true);
      } finally {
        setLoadingVehicleState(false);
      }
    }
  }

  // Set vehicle fields from existing data for editing
  bool isEditingVehicle = false;
  setVehicleFieldsForEdit() {
    isEditingVehicle = true;
    final vehicle = userProfile?.vehicle;
    if (vehicle != null) {
      vehicleRegNumController.text = vehicle.regNum;
      vehicleBrandController.text = vehicle.brand ?? "";
      vehicleModelController.text = vehicle.model ?? "";
      vehicleYearController.text = vehicle.year?.toString() ?? "";
      if (vehicle.courierType != null) {
        // Find matching CourierTypeModel from courierTypes list
        selectedCourierType = courierTypes.firstWhereOrNull(
          (ct) => ct.id == vehicle.courierType!.id,
        );
        vehicleCourierTypeController.text = vehicle.courierType?.name ?? "";
      }
    }
    update();
  }

  // Update existing vehicle info
  updateVehicleInfo() async {
    if (vehicleFormKey.currentState!.validate()) {
      setLoadingVehicleState(true);

      try {
        dynamic data = {
          "reg_num": vehicleRegNumController.text,
        };

        // Add courier type if selected, otherwise use existing vehicle's courier type
        if (selectedCourierType != null) {
          data["courier_type_id"] = selectedCourierType!.id;
        } else if (userProfile?.vehicle?.courierTypeId != null) {
          data["courier_type_id"] = userProfile!.vehicle!.courierTypeId;
        }

        // Add brand if provided
        if (vehicleBrandController.text.isNotEmpty) {
          data["brand"] = vehicleBrandController.text;
        }

        // Add model if provided
        if (vehicleModelController.text.isNotEmpty) {
          data["model"] = vehicleModelController.text;
        }

        // Add year if provided
        if (vehicleYearController.text.isNotEmpty) {
          data["year"] = int.tryParse(vehicleYearController.text);
        }

        // Add interior photo if available (optional)
        if (vehicleInteriorPhotoBase64 != null) {
          data['interior_photo'] = vehicleInteriorPhotoBase64;
        }

        // Add exterior photo if available (optional)
        if (vehicleExteriorPhotoBase64 != null) {
          data['exterior_photo'] = vehicleExteriorPhotoBase64;
        }

        APIResponse response = await profileService.updateVehicle(data);

        if (response.status == "success") {
          showToast(message: response.message);
          getProfile();
          clearVehicleTextFields();
          isEditingVehicle = false;
          Navigator.pop(Get.context!);
        } else {
          showToast(
              message: response.message,
              isError: response.status != "success");
        }
      } catch (e) {
        showToast(message: "Error updating vehicle: $e", isError: true);
      } finally {
        setLoadingVehicleState(false);
      }
    }
  }

  selectLicenseIssueDate(context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime(3000),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                    fontFamily: "Comfortaa",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      licenseIssuedDateController
          .setText(DateFormat('yyyy-MM-dd').format(picked));
      update();
    }
  }

  selectLicenseExpiryDate(context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime(3000),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: TextStyle(
                    fontFamily: "Comfortaa",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold), // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      licenseExpiryDateController
          .setText(DateFormat('yyyy-MM-dd').format(picked));
      update();
    }
  }

  // Sharp-vendor pattern: License images with base64 encoding
  File? licenseFrontImage;
  File? licenseBackImage;
  String? licenseFrontImageBase64;
  String? licenseBackImageBase64;

  Future<void> pickLicenseFrontImage({required bool pickFromCamera}) async {
    try {
      XFile? photo;
      if (pickFromCamera) {
        photo = await _picker.pickImage(source: ImageSource.camera);
      } else {
        photo = await _picker.pickImage(source: ImageSource.gallery);
      }

      if (photo != null) {
        final croppedPhoto = await cropImage(photo);
        final compressed = await ImageCompressionService.compressImage(
          XFile(croppedPhoto.path),
        );
        licenseFrontImageBase64 = await Base64ImageUtils.convertImageToBase64(compressed.path);
        licenseFrontImage = File(compressed.path);
        update();
      }
    } catch (e) {
      showToast(message: "Error picking image: $e", isError: true);
    }
  }

  Future<void> pickLicenseBackImage({required bool pickFromCamera}) async {
    try {
      XFile? photo;
      if (pickFromCamera) {
        photo = await _picker.pickImage(source: ImageSource.camera);
      } else {
        photo = await _picker.pickImage(source: ImageSource.gallery);
      }

      if (photo != null) {
        final croppedPhoto = await cropImage(photo);
        final compressed = await ImageCompressionService.compressImage(
          XFile(croppedPhoto.path),
        );
        licenseBackImageBase64 = await Base64ImageUtils.convertImageToBase64(compressed.path);
        licenseBackImage = File(compressed.path);
        update();
      }
    } catch (e) {
      showToast(message: "Error picking image: $e", isError: true);
    }
  }

  void removeLicenseFrontImage() {
    licenseFrontImage = null;
    licenseFrontImageBase64 = null;
    update();
  }

  void removeLicenseBackImage() {
    licenseBackImage = null;
    licenseBackImageBase64 = null;
    update();
  }

  void clearLicenseTextFields() {
    licenseNumberController.clear();
    licenseIssuedDateController.clear();
    licenseExpiryDateController.clear();
    licenseFrontImage = null;
    licenseBackImage = null;
    licenseFrontImageBase64 = null;
    licenseBackImageBase64 = null;
  }

  final vehicleLicenseFormKey = GlobalKey<FormState>();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController licenseIssuedDateController = TextEditingController();
  TextEditingController licenseExpiryDateController = TextEditingController();

  // Sharp-vendor pattern: Complete license data with images
  addVehicleLicense() async {
    if (vehicleLicenseFormKey.currentState!.validate()) {
      setLoadingVehicleState(true);

      try {
        dynamic data = {
          "number": licenseNumberController.text,
          "issued_at": licenseIssuedDateController.text,
          "expiry_date": licenseExpiryDateController.text,
        };

        // Add front image if available (optional)
        if (licenseFrontImageBase64 != null) {
          data['front_img'] = licenseFrontImageBase64;
        }

        // Add back image if available (optional)
        if (licenseBackImageBase64 != null) {
          data['back_img'] = licenseBackImageBase64;
        }

        APIResponse response = await profileService.addLicense(data);

        if (response.status == "success") {
          showToast(message: response.message);
          clearLicenseTextFields();
          getMyVehicleLicense();
          getProfile();
          Navigator.pop(Get.context!);
        } else {
          showToast(
              message: response.message, isError: response.status != "success");
        }
      } catch (e) {
        showToast(message: "Error adding license: $e", isError: true);
      } finally {
        setLoadingVehicleState(false);
      }
    }
  }

  // Set license fields from existing data for editing
  bool isEditingLicense = false;
  setLicenseFieldsForEdit() {
    isEditingLicense = true;
    final license = vehicleLicense;
    if (license != null) {
      licenseNumberController.text = license.number ?? "";
      licenseIssuedDateController.text = license.issuedAt ?? "";
      licenseExpiryDateController.text = license.expiryDate ?? "";
    }
    update();
  }

  // Update existing license info
  updateVehicleLicense() async {
    if (vehicleLicenseFormKey.currentState!.validate()) {
      setLoadingVehicleState(true);

      try {
        dynamic data = {
          "number": licenseNumberController.text,
          "issued_at": licenseIssuedDateController.text,
          "expiry_date": licenseExpiryDateController.text,
        };

        // Add front image if available (optional)
        if (licenseFrontImageBase64 != null) {
          data['front_img'] = licenseFrontImageBase64;
        }

        // Add back image if available (optional)
        if (licenseBackImageBase64 != null) {
          data['back_img'] = licenseBackImageBase64;
        }

        APIResponse response = await profileService.updateLicense(data);

        if (response.status == "success") {
          showToast(message: response.message);
          clearLicenseTextFields();
          getMyVehicleLicense();
          getProfile();
          isEditingLicense = false;
          Navigator.pop(Get.context!);
        } else {
          showToast(
              message: response.message, isError: response.status != "success");
        }
      } catch (e) {
        showToast(message: "Error updating license: $e", isError: true);
      } finally {
        setLoadingVehicleState(false);
      }
    }
  }

  logout() async {
    GetStorage getStorage = GetStorage();
    DeliveryNotificationServiceManager serviceManager =
        DeliveryNotificationServiceManager();
    serviceManager.disposeServices();
    getStorage.remove('token');
    Get.offAllNamed(Routes.SIGN_IN);
    // Zego Cloud temporarily disabled
    // ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  bool deletePasswordVisibility = false;

  toggleDeletePasswordVisibility() {
    deletePasswordVisibility = !deletePasswordVisibility;
    update();
  }

  bool deletingAccount = false;
  final deleteAccountFormKey = GlobalKey<FormState>();
  TextEditingController deletePasswordController = TextEditingController();
  deleteAccount() async {
    if (deleteAccountFormKey.currentState!.validate()) {
      dynamic data = {"password": deletePasswordController.text};
      APIResponse res = await profileService.deleteAccount(data);
      if (res.status == "success") {
        GetStorage getStorage = GetStorage();
        getStorage.remove('token');
        Get.offAllNamed(Routes.SIGN_IN);
        DeliveryNotificationServiceManager serviceManager =
            DeliveryNotificationServiceManager();
        serviceManager.disposeServices();
        // Zego Cloud temporarily disabled
        // ZegoUIKitPrebuiltCallInvitationService().uninit();
      } else {
        showToast(message: "could not delete your account", isError: true);
      }
    }
  }

  showAccountDeletionDialog() async {
    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: customText("Delete Account",
            fontWeight: FontWeight.bold, fontSize: 18.sp),
        content: customText(
          "Are you sure you want to delete your account? This action is permanent and cannot be undone.",
          textAlign: TextAlign.left,
          overflow: TextOverflow.visible,
          fontSize: 16.sp,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: customText("Cancel",
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      color: AppColors.obscureTextColor),
                ),
              ),
              Expanded(
                child: CustomButton(
                  onPressed: () async {
                    Get.back();
                    Get.toNamed(Routes.DELETE_ACCOUNT_SCREEN); //  Close dialog
                  },
                  title: "Delete",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Rating Stats
  RatingStatsModel? ratingStats;
  bool _isFetchingRatingStats = false;
  get isFetchingRatingStats => _isFetchingRatingStats;
  DateTime? ratingStartDate;
  DateTime? ratingEndDate;

  setRatingDateRange(DateTime? start, DateTime? end) {
    ratingStartDate = start;
    ratingEndDate = end;
    update();
    getRatingStats();
  }

  clearRatingDateFilter() {
    ratingStartDate = null;
    ratingEndDate = null;
    update();
    getRatingStats();
  }

  getRatingStats() async {
    _isFetchingRatingStats = true;
    update();

    String? startDate;
    String? endDate;

    if (ratingStartDate != null && ratingEndDate != null) {
      startDate = DateFormat('yyyy-MM-dd').format(ratingStartDate!);
      endDate = DateFormat('yyyy-MM-dd').format(ratingEndDate!);
    }

    APIResponse response = await profileService.getRatingStats(
      startDate: startDate,
      endDate: endDate,
    );

    _isFetchingRatingStats = false;

    if (response.status == "success") {
      ratingStats = RatingStatsModel.fromJson(response.data);
    } else {
      ratingStats = null;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // Load profile when the controller is initialized
    getMyVehicleLicense();
    // getMyVehicle();
    getProfile();
  }
}
