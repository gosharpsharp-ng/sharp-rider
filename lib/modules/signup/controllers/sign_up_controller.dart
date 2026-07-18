import 'dart:developer';
import 'dart:io';
import 'package:gorider/core/utils/exports.dart';
import 'package:gorider/core/models/registration_request_model.dart';
import 'package:gorider/core/services/courier/courier_type_service.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/phone_number.dart';

class SignUpController extends GetxController {
  final authService = serviceLocator<AuthenticationService>();
  final courierTypeService = serviceLocator<CourierTypeService>();
  final ImagePicker _picker = ImagePicker();

  // Current step in the registration process (0-based)
  int currentStep = 0;

  // Flag to indicate if OTP verification is from login flow
  bool isFromLoginFlow = false;

  void setStep(int step) {
    currentStep = step;
    update();
  }

  void nextStep() {
    // Only 3 steps (0, 1, 2), so max is 2
    if (currentStep < 2) {
      log('📍 Next step called - Current: $currentStep');
      currentStep++;
      log('✅ Moving to step: $currentStep');
      update();
    } else {
      log('⚠️ Already at last step, cannot go forward');
    }
  }

  void previousStep() {
    log('📍 Previous step called - Current: $currentStep');
    if (currentStep > 0) {
      currentStep--;
      log('✅ Moving to step: $currentStep');
      update();
    } else {
      log('⚠️ Already at first step, cannot go back');
    }
  }

  // ==================== STEP 1: Personal Information ====================
  final signUpFormKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  PhoneNumber? phoneNumber;
  PhoneNumber? filledPhoneNumber;

  void setPhoneNumber(PhoneNumber number) {
    phoneNumber = number;
    phoneNumberController.text = number.number;
    print(
        "************************************************************************************");
    print(phoneNumberController.text);
    print(
        "************************************************************************************");
    update();
  }

  void setFilledPhoneNumber(PhoneNumber number) {
    filledPhoneNumber = number;
    update();
  }

  bool signUpPasswordVisibility = false;
  void togglePasswordVisibility() {
    signUpPasswordVisibility = !signUpPasswordVisibility;
    update();
  }

  bool signUpConfirmPasswordVisibility = false;
  void toggleConfirmPasswordVisibility() {
    signUpConfirmPasswordVisibility = !signUpConfirmPasswordVisibility;
    update();
  }

  // ==================== STEP 2: Vehicle Information ====================
  final step2FormKey = GlobalKey<FormState>();

  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleYearController = TextEditingController();
  TextEditingController vehicleRegNumController = TextEditingController();

  CourierTypeModel? selectedCourierType;
  List<CourierTypeModel> courierTypes = [];
  bool isLoadingCourierTypes = false;

  File? vehicleInteriorPhoto;
  File? vehicleExteriorPhoto;
  String? vehicleInteriorPhotoBase64;
  String? vehicleExteriorPhotoBase64;

  void setSelectedCourierType(CourierTypeModel? courierType) {
    selectedCourierType = courierType;
    update();
  }

  Future<void> fetchCourierTypes() async {
    isLoadingCourierTypes = true;
    update();

    try {
      APIResponse response = await courierTypeService.getAllCourierTypes();
      print("Courier Types Response - Status: ${response.status}");
      print("Courier Types Response - Data: ${response.data}");
      print("Courier Types Response - Message: ${response.message}");

      if (response.status == "success" && response.data != null) {
        if (response.data is List) {
          courierTypes = (response.data as List)
              .map((item) =>
                  CourierTypeModel.fromJson(item as Map<String, dynamic>))
              .toList();
          print("Successfully loaded ${courierTypes.length} courier types");
        } else {
          print("Response data is not a List: ${response.data.runtimeType}");
          showToast(
            message: "Invalid data format for courier types",
            isError: true,
          );
        }
      } else {
        print("Failed to load courier types: ${response.message}");
        showToast(
          message: response.message.isNotEmpty ? response.message : "Failed to load courier types",
          isError: true,
        );
      }
    } catch (e, stackTrace) {
      print("Error loading courier types: $e");
      print("Stack trace: $stackTrace");
      showToast(
        message: "Error loading courier types: $e",
        isError: true,
      );
    } finally {
      isLoadingCourierTypes = false;
      update();
    }
  }

  // Sharp-vendor pattern: Pick image from camera or gallery
  Future<void> pickVehicleInteriorPhoto({required bool pickFromCamera}) async {
    try {
      XFile? photo;
      if (pickFromCamera) {
        photo = await _picker.pickImage(source: ImageSource.camera);
      } else {
        photo = await _picker.pickImage(source: ImageSource.gallery);
      }

      if (photo != null) {
        // Crop the image
        final croppedPhoto = await cropImage(photo);

        // Compress the image
        final compressed = await ImageCompressionService.compressImage(
          XFile(croppedPhoto.path),
        );

        // Convert to base64
        vehicleInteriorPhotoBase64 = await Base64ImageUtils.convertImageToBase64(compressed.path);
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
        // Crop the image
        final croppedPhoto = await cropImage(photo);

        // Compress the image
        final compressed = await ImageCompressionService.compressImage(
          XFile(croppedPhoto.path),
        );

        // Convert to base64
        vehicleExteriorPhotoBase64 = await Base64ImageUtils.convertImageToBase64(compressed.path);
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

  // ==================== STEP 3: License Information ====================
  final step3FormKey = GlobalKey<FormState>();

  TextEditingController licenseNumberController = TextEditingController();
  TextEditingController licenseExpiryController = TextEditingController();
  TextEditingController licenseIssuedController = TextEditingController();

  File? licenseFrontImage;
  File? licenseBackImage;
  String? licenseFrontImageBase64;
  String? licenseBackImageBase64;

  DateTime? licenseExpiryDate;
  DateTime? licenseIssuedDate;

  Future<void> selectLicenseExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: licenseExpiryDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null) {
      licenseExpiryDate = picked;
      licenseExpiryController.text = DateFormat('yyyy-MM-dd').format(picked);
      update();
    }
  }

  Future<void> selectLicenseIssuedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          licenseIssuedDate ?? DateTime.now().subtract(const Duration(days: 365)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      licenseIssuedDate = picked;
      licenseIssuedController.text = DateFormat('yyyy-MM-dd').format(picked);
      update();
    }
  }

  // Sharp-vendor pattern: Pick license images with crop and compress
  Future<void> pickLicenseFrontImage({required bool pickFromCamera}) async {
    try {
      XFile? photo;
      if (pickFromCamera) {
        photo = await _picker.pickImage(source: ImageSource.camera);
      } else {
        photo = await _picker.pickImage(source: ImageSource.gallery);
      }

      if (photo != null) {
        // Crop the image
        final croppedPhoto = await cropImage(photo);

        // Compress the image
        final compressed = await ImageCompressionService.compressImage(
          XFile(croppedPhoto.path),
        );

        // Convert to base64
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
        // Crop the image
        final croppedPhoto = await cropImage(photo);

        // Compress the image
        final compressed = await ImageCompressionService.compressImage(
          XFile(croppedPhoto.path),
        );

        // Convert to base64
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

  // ==================== OTP Verification ====================
  final signOTPFormKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();

  Timer? _otpResendTimer;
  int resendOTPAfter = 120;
  String remainingTime = "";

  void startOtpResendTimer() {
    resendOTPAfter = 120;
    remainingTime = getFormattedResendOTPTime(resendOTPAfter);
    const oneSec = Duration(seconds: 1);
    _otpResendTimer = Timer.periodic(oneSec, (Timer timer) {
      if (resendOTPAfter > 0) {
        resendOTPAfter--;
        remainingTime = getFormattedResendOTPTime(resendOTPAfter);
        update();
      } else {
        _otpResendTimer?.cancel();
        update();
      }
    });
  }

  // ==================== Loading States ====================
  bool isLoading = false;
  void setLoadingState(bool val) {
    isLoading = val;
    update();
  }

  bool isResendingOtp = false;
  void setIsResendingOTPState(bool val) {
    isResendingOtp = val;
    update();
  }



  // ==================== Step Validation ====================
  bool validateStep1() {
    if (!signUpFormKey.currentState!.validate()) {
      return false;
    }
    if (phoneNumber == null && phoneNumberController.text.isEmpty) {
      showToast(message: "Please enter a valid phone number", isError: true);
      return false;
    }
    if (passwordController.text != cPasswordController.text) {
      showToast(message: "Passwords do not match", isError: true);
      return false;
    }
    return true;
  }

  bool validateStep2() {
    if (!step2FormKey.currentState!.validate()) {
      return false;
    }
    if (selectedCourierType == null) {
      showToast(message: "Please select a courier type", isError: true);
      return false;
    }
    return true;
  }

  bool validateStep3() {
    if (!step3FormKey.currentState!.validate()) {
      return false;
    }
    if (licenseExpiryDate == null) {
      showToast(message: "Please select license expiry date", isError: true);
      return false;
    }
    if (licenseIssuedDate == null) {
      showToast(message: "Please select license issued date", isError: true);
      return false;
    }
    return true;
  }

  // ==================== Registration Submission ====================
  Future<void> submitRegistration() async {
    if (!validateStep1() || !validateStep2() || !validateStep3()) {
      return;
    }

    setLoadingState(true);

    try {
      // Build registration request
      final vehicleData = VehicleRegistrationData(
        brand: vehicleBrandController.text,
        model: vehicleModelController.text,
        year: int.parse(vehicleYearController.text),
        regNum: vehicleRegNumController.text,
        interiorPhoto: vehicleInteriorPhotoBase64,
        exteriorPhoto: vehicleExteriorPhotoBase64,
        courierTypeId: selectedCourierType!.id,
      );

      final licenseData = LicenseRegistrationData(
        number: licenseNumberController.text,
        frontImg: licenseFrontImageBase64,
        backImg: licenseBackImageBase64,
        expiryDate: licenseExpiryController.text,
        issuedAt: licenseIssuedController.text,
      );

      final registrationRequest = RiderRegistrationRequest(
        fname: firstNameController.text,
        lname: lastNameController.text,
        email: emailController.text,
        phone: filledPhoneNumber!.completeNumber,
        password: passwordController.text,
        vehicle: vehicleData,
        license: licenseData,
      );
      dynamic data = {
        'fname': registrationRequest.fname,
        'lname': registrationRequest.lname,
        'email': registrationRequest.email,
        'phone': registrationRequest.phone,
        'password': registrationRequest.password,
        'vehicle': {
          'brand': registrationRequest.vehicle.brand,
          'model': registrationRequest.vehicle.model,
          'year': registrationRequest.vehicle.year,
          'reg_num': registrationRequest.vehicle.regNum,
          // 'interior_photo': registrationRequest.vehicle.interiorPhoto,
          // 'exterior_photo': registrationRequest.vehicle.exteriorPhoto,
          'courier_type_id': registrationRequest.vehicle.courierTypeId,
        },
        'license': {
          'number': registrationRequest.license.number,
          // 'front_img': registrationRequest.license.frontImg,
          // 'back_img': registrationRequest.license.backImg,
          'expiry_date': registrationRequest.license.expiryDate,
          'issued_at': registrationRequest.license.issuedAt,
        },
      };
      print(
          "******************************************************************************************************************************");
      log(data.toString());
      print(
          "******************************************************************************************************************************");

      // Submit to API
      log('🌐 Sending registration request to API...');
      APIResponse response = await authService.riderOnboard(data);
      log('✅ API call completed, processing response...');

      // ==================== REGISTRATION RESPONSE LOGGING ====================
      log('========================================');
      log('📋 REGISTRATION RESPONSE');
      log('========================================');
      log('Status: ${response.status}');
      log('Message: ${response.message}');
      log('Data Type: ${response.data.runtimeType}');
      log('Data: ${response.data}');
      log('========================================');
      // ======================================================================

      if (response.status == "success") {
        log('✅ Registration successful - navigating to OTP screen');
        // Send OTP for email verification (silently)
        await sendOtp();
        // Navigate to OTP screen - Use Get.toNamed instead of Get.offAndToNamed to keep controller alive
        Get.toNamed(Routes.SIGNUP_OTP_SCREEN);
      } else {
        log('❌ Registration failed - showing error to user');
        // Use error sheet instead of toast to avoid overlay errors
        showErrorSheet(
          title: "Registration Failed",
          message: response.message,
          buttonText: "Try Again",
          onButtonPressed: () {
            Get.back(); // Close the error sheet
          },
        );
      }
    } catch (e, stackTrace) {
      log('========================================');
      log('❌ REGISTRATION EXCEPTION');
      log('========================================');
      log('Error: $e');
      log('Stack trace: $stackTrace');
      log('========================================');

      // Use error sheet instead of toast to avoid overlay errors
      showErrorSheet(
        title: "Registration Error",
        message: "An unexpected error occurred. Please try again.\n\nError: $e",
        buttonText: "Close",
        onButtonPressed: () {
          Get.back(); // Close the error sheet
        },
      );
    } finally {
      setLoadingState(false);
    }
  }

  // ==================== OTP Functions ====================
  Future<void> sendOtp({bool showMessage = false}) async {
    debugPrint('\n🟢 ===== SEND OTP CALLED =====');
    debugPrint('📧 Email: ${emailController.text}');
    debugPrint('🔔 Show message: $showMessage');
    debugPrint('🟢 ====================================\n');

    setIsResendingOTPState(true);
    dynamic data = {
      'identifier': emailController.text,
    };
    APIResponse response = await authService.sendOtp(data);

    debugPrint('\n📩 ===== SEND OTP RESPONSE =====');
    debugPrint('✅ Status: ${response.status}');
    debugPrint('💬 Message: ${response.message}');
    debugPrint('📩 ====================================\n');

    // Only show toast if explicitly requested (e.g., manual resend)
    if (showMessage) {
      showToast(message: response.message, isError: response.status != "success");
    }

    setIsResendingOTPState(false);
    if (response.status == "success") {
      startOtpResendTimer();
    }
  }

  Future<void> verifyOtp() async {
    if (signOTPFormKey.currentState!.validate()) {
      setLoadingState(true);
      try {
        dynamic data = {
          'otp': otpController.text,
          'identifier': emailController.text,
        };
        APIResponse response = await authService.verifyEmailOtp(data);

        debugPrint('\n🎯 ===== VERIFY OTP RESPONSE =====');
        debugPrint('✅ Status: ${response.status}');
        debugPrint('💬 Message: ${response.message}');
        debugPrint('🎯 ====================================\n');

        if (response.status == "success") {
          debugPrint('✅ Email verification successful!');

          if (isFromLoginFlow) {
            // LOGIN FLOW: Don't show toast (would interfere with Get.back)
            // Success dialog will be shown in SignInController
            debugPrint('🔙 LOGIN FLOW: Returning to login screen with result: true');
            debugPrint('⚠️ Skipping toast to avoid navigation conflict');

            // Navigate back with result immediately
            Get.back(result: true);

            debugPrint('✅ Get.back() executed with result: true');
          } else {
            // SIGNUP FLOW: Navigate to success screen
            debugPrint('📱 SIGNUP FLOW: Going to success screen via offAllNamed');
            Get.offAllNamed(Routes.SIGNUP_SUCCESS_SCREEN);
          }
        } else {
          // Show error sheet for verification failures (more visible than toast)
          debugPrint('❌ Verification failed: ${response.message}');
          showErrorSheet(
            title: "Verification Failed",
            message: response.message,
            buttonText: "Try Again",
            onButtonPressed: () {
              Get.back(); // Close error sheet
            },
          );
        }
      } catch (e) {
        debugPrint('❌ Exception during OTP verification: $e');
        showErrorSheet(
          title: "Verification Error",
          message: "An unexpected error occurred. Please try again.\n\nError: $e",
          buttonText: "Close",
          onButtonPressed: () {
            Get.back(); // Close error sheet
          },
        );
      } finally {
        setLoadingState(false);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCourierTypes();
  }

  /// Reset the entire signup form to initial state
  void resetForm() {
    // Reset step
    currentStep = 0;

    // Clear all text controllers
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    cPasswordController.clear();
    vehicleBrandController.clear();
    vehicleModelController.clear();
    vehicleYearController.clear();
    vehicleRegNumController.clear();
    licenseNumberController.clear();
    licenseExpiryController.clear();
    licenseIssuedController.clear();
    otpController.clear();

    // Reset selections
    selectedCourierType = null;
    filledPhoneNumber = null;

    // Clear images
    vehicleInteriorPhotoBase64 = null;
    vehicleExteriorPhotoBase64 = null;
    licenseFrontImageBase64 = null;
    licenseBackImageBase64 = null;

    // Reset states
    isLoading = false;
    signUpPasswordVisibility = false;
    signUpConfirmPasswordVisibility = false;

    update();
  }

  @override
  void onClose() {
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    cPasswordController.dispose();
    vehicleBrandController.dispose();
    vehicleModelController.dispose();
    vehicleYearController.dispose();
    vehicleRegNumController.dispose();
    licenseNumberController.dispose();
    licenseExpiryController.dispose();
    licenseIssuedController.dispose();
    otpController.dispose();

    // Cancel timer if active
    if (_otpResendTimer?.isActive ?? false) {
      _otpResendTimer?.cancel();
    }

    super.onClose();
  }
}
