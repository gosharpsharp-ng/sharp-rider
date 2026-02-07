import 'package:gorider/core/utils/exports.dart';

class ProfileService extends CoreService {
  Future<ProfileService> init() async => this;

  Future<APIResponse> getProfile() async {
    return await fetch("/riders/profile");
  }

  Future<APIResponse> getCourierTypes() async {
    return await fetch("/courier-types");
  }

  Future<APIResponse> updateProfile(dynamic data) async {
    return await update("/riders/profile", data);
  }

  Future<APIResponse> getNotifications(dynamic data) async {
    return await fetch(
        "/riders/notifications?page=${data['page']}&per_page=${data['per_page']}");
  }

  Future<APIResponse> getRiderStats() async {
    return await fetch("/riders/stats");
  }

  Future<APIResponse> getRiderRatingStats() async {
    return await fetch("/riders/rate-stats");
  }

  Future<APIResponse> getNotificationById(dynamic data) async {
    return await fetch("/riders/notifications/${data['id']}");
  }

  Future<APIResponse> addVehicle(dynamic data) async {
    return await update("/riders/profile", {"vehicle": data});
  }

  Future<APIResponse> updateVehicle(dynamic data) async {
    return await update("/riders/profile", {"vehicle": data});
  }

  Future<APIResponse> getVehicle() async {
    return await fetch("/riders/vehicle");
  }

  Future<APIResponse> addLicense(dynamic data) async {
    return await send("/riders/driver-license", data);
  }

  Future<APIResponse> updateLicense(dynamic data) async {
    return await update("/riders/profile", {"license": data});
  }

  Future<APIResponse> getLicense() async {
    return await fetch("/riders/driver-license");
  }

  Future<APIResponse> changePassword(dynamic data) async {
    return await send("/auth/change-password", data);
  }

  Future<APIResponse> deleteAccount(dynamic data) async {
    return await remove("/riders/profile", data);
  }

  // Bank Account Management
  Future<APIResponse> getBankAccount() async {
    return await fetch("/riders/bank-account");
  }

  Future<APIResponse> updateBankAccount(dynamic data) async {
    return await send("/riders/bank-account", data);
  }

  // Payout Management
  Future<APIResponse> getPayoutHistory(dynamic data) async {
    return await fetch(
      "/riders/payout/history?page=${data['page']}&per_page=${data['per_page']}",
    );
  }

  Future<APIResponse> getPayoutById(dynamic data) async {
    return await fetch("/riders/payout/${data['id']}");
  }

  Future<APIResponse> submitPayoutRequest(dynamic data) async {
    return await send("/riders/wallet/payout", data);
  }

  // Wallet funding
  Future<APIResponse> fundWallet(dynamic data) async {
    return await send("/riders/wallet/fund", data);
  }

  // FAQ
  Future<APIResponse> getFAQs() async {
    return await fetch("/faqs");
  }

  Future<APIResponse> getFAQById(dynamic data) async {
    return await fetch("/faqs/${data['id']}");
  }

  // Rating stats
  Future<APIResponse> getRatingStats(
      {String? startDate, String? endDate}) async {
    String url = "/riders/stats/ratings";
    if (startDate != null && endDate != null) {
      url += "?start_date=$startDate&end_date=$endDate";
    }
    return await fetch(url);
  }
}
