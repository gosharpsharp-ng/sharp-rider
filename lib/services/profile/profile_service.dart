import 'package:go_logistics_driver/utils/exports.dart';
class ProfileService extends CoreService {
  Future<ProfileService> init() async => this;

  Future<APIResponse> getProfile() async {
    return await fetch("/me");
  }

  Future<APIResponse> updateProfile(dynamic data) async {
    return await formUpdate("/me", data);
  }

}
