import 'dart:io';
import 'package:go_logistics_driver/utils/exports.dart';
import 'package:intl/intl.dart';

class SettingsController extends GetxController {
  final profileService = serviceLocator<ProfileService>();
  final serviceManager = Get.put(ServiceManager());

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
      try {
        await serviceManager.initializeServices(userProfile!);
      } catch (e) {
        showToast(
            message: "Failed to initialize services: ${e.toString()}",
            isError: true);
      }
    } else {
      showToast(
          message: response.message, isError: response.status != "success");
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
      }
    }
  }

  bool _isLoadingNotification = false;
  get isLoadingNotification => _isLoadingNotification;
  setLoadingNotificationState(bool val) {
    _isLoadingNotification = val;
    update();
  }

  List<NotificationModel> notifications = [];
  NotificationModel? selectedNotification;
  setSelectedNotification(NotificationModel nt) {
    selectedNotification = nt;
    getNotifications();
    update();
  }

  getSingleNotification() async {
    dynamic data = {
      "id": selectedNotification!.id,
    };
    APIResponse response = await profileService.getNotificationById(data);
    selectedNotification = NotificationModel.fromJson(response.data[data]);
    if (response.status == "success") {
      setSelectedNotification(NotificationModel.fromJson(response.data[data]));
    }
  }

  getNotifications() async {
    setLoadingNotificationState(true);
    APIResponse response = await profileService.getNotifications();
    setLoadingNotificationState(false);
    if (response.status == "success") {
      notifications = (response.data['data'] as List)
          .map((nf) => NotificationModel.fromJson(nf))
          .toList();
      update();
    }
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
      print(response.data.toString());
      courierTypes = (response.data['data'] as List)
          .map((ct) => CourierTypeModel.fromJson(ct))
          .toList();
      update();
    }
  }

  VehicleModel? vehicleModel;
  getMyVehicle() async {
    // setLoadingVehicleState(true);
    APIResponse response = await profileService.getVehicle();
    // setLoadingVehicleState(false);
    if (response.status == "success") {
      print("************************************************************************************");
      print("${response.data}");
      print("************************************************************************************");
      if(response.data.isNotEmpty){
        vehicleModel = VehicleModel.fromJson(response.data[0]);
      }

      update();
    }
  }

  LicenseModel? vehicleLicense;
  getMyVehicleLicense() async {
    // setLoadingVehicleState(true);
    APIResponse response = await profileService.getLicense();
    // setLoadingVehicleState(false);
    if (response.status == "success") {
      print("********************************************************************************************************");
      print(response.data);
      print("********************************************************************************************************");
      if(response.data.isNotEmpty) {
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

  void clearVehicleTextFields() {
    vehicleCourierTypeController.clear();
    vehicleBrandController.clear();
    vehicleModelController.clear();
    vehicleRegNumController.clear();
    vehicleYearController.clear();
  }

  final vehicleFormKey = GlobalKey<FormState>();
  TextEditingController vehicleCourierTypeController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleRegNumController = TextEditingController();
  TextEditingController vehicleYearController = TextEditingController();
  addVehicleInfo() async {
    if (vehicleFormKey.currentState!.validate()) {
      setLoadingVehicleState(true);

      dynamic data = {
        "courier_type_id": selectedCourierType!.id,
        "brand": vehicleBrandController.text,
        "model": vehicleModelController.text,
        "reg_num": vehicleRegNumController.text,
        "year": vehicleYearController.text
      };
      APIResponse response = await profileService.addVehicle(data);

      setLoadingVehicleState(false);
      showToast(
          message: response.message, isError: response.status != "success");
      if (response.status == "success") {
        getMyVehicle();
        clearVehicleTextFields();
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

  void clearLicenseTextFields() {
    licenseNumberController.clear();
    licenseIssuedDateController.clear();
    licenseExpiryDateController.clear();
  }

  final vehicleLicenseFormKey = GlobalKey<FormState>();
  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController licenseIssuedDateController = TextEditingController();
  TextEditingController licenseExpiryDateController = TextEditingController();
  addVehicleLicense() async {
    if (vehicleLicenseFormKey.currentState!.validate()) {
      setLoadingVehicleState(true);

      dynamic data = {
        "number": licenseNumberController.text,
        "issued_at": licenseIssuedDateController.text,
        "expiry_date": licenseExpiryDateController.text,
      };
      APIResponse response = await profileService.addLicense(data);

      setLoadingVehicleState(false);
      showToast(
          message: response.message, isError: response.status != "success");
      if (response.status == "success") {
        clearLicenseTextFields();
        getMyVehicleLicense();
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Load profile when the controller is initialized
    getMyVehicleLicense();
    getMyVehicle();
    getProfile();
  }
}
