import 'package:go_logistics_driver/utils/exports.dart';

class ProfileService extends CoreService {
  Future<ProfileService> init() async => this;

  Future<APIResponse> getProfileData() async {
    return await fetch("/api/profile/get-user-profile");
  }

  Future<APIResponse> fetchUserVehicleInfo() async {
    return await fetch("/api/profile/get-vehicle-info");
  }

  Future<APIResponse> getOtherUserProfile(dynamic data) async {
    return await fetchByParams("/api/profile/get-other-user-profile", data);
  }

  Future<APIResponse> updateProfile(dynamic data) async {
    return await update("/api/profile/update-user-profile", data);
  }

  Future<APIResponse> updateBio(dynamic data) async {
    return await update("/api/profile/update-bio", data);
  }

  Future<APIResponse> updateProfileImage(dynamic data) async {
    return await update("/api/profile/update-profile-image", data);
  }

  Future<APIResponse> updateLanguages(dynamic data) async {
    return await update("/api/profile/update-languages", data);
  }

  Future<APIResponse> updatePhoneNumber(dynamic data) async {
    return await update("/api/profile/update-phone-number", data);
  }

  Future<APIResponse> updateEmergencyPhoneNumber(dynamic data) async {
    return await update("/api/profile/update-emergency-phone-number", data);
  }

  Future<APIResponse> addVehicleInformation(dynamic data) async {
    return await send("/api/profile/add-vehicle-info", data);
  }

  Future<APIResponse> updateVehicleInformation(dynamic data) async {
    return await update("/api/profile/update-vehicle-info", data);
  }

  Future<APIResponse> updateAddress(dynamic data) async {
    return await update("/api/profile/update-address", data);
  }

  Future<APIResponse> updateOccupation(dynamic data) async {
    return await update("/api/profile/update-occupation", data);
  }

  Future<APIResponse> uploadIdentificationDocument(dynamic data) async {
    return await send("/api/profile/upload-id-document", data);
  }

  Future<APIResponse> generateTransactionOTP(dynamic data) async {
    return await send("/api/profile/generate-transaction-otp", data);
  }
}
