import 'package:go_logistics_driver/utils/exports.dart';

class ProfileService extends CoreService {
  Future<ProfileService> init() async => this;

  Future<APIResponse> getProfile() async {
    return await fetch("/me");
  }
  Future<APIResponse> getCourierTypes() async {
    return await fetch("/courier-types");
  }

  Future<APIResponse> updateProfile(dynamic data) async {
    return await formUpdate("/me", data);
  }

  Future<APIResponse> getNotifications() async {
    return await fetch("/me/notifications");
  }

  Future<APIResponse> getNotificationById(dynamic data) async {
    return await fetch("/me/notifications/${data['id']}");
  }

  Future<APIResponse> addVehicle(dynamic data) async {
    return await send("/me/vehicle", data);
  }

  Future<APIResponse> getVehicle() async {
    return await fetch("/me/vehicle");
  }

  Future<APIResponse> addLicense(dynamic data) async {
    return await send("/me/driver-license", data);
  }

  Future<APIResponse> getLicense() async {
    return await fetch("/me/driver-license");
  }

  Future<APIResponse> changePassword(dynamic data) async {
    return await send("/auth/change-password", data);
  }
}
