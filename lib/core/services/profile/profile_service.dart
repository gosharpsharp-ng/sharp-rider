import 'package:gorider/core/utils/exports.dart';

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

  Future<APIResponse> getNotifications(dynamic data) async {
    return await fetch(
        "/me/notifications?page=${data['page']}&per_page=${data['per_page']}");
  }

  Future<APIResponse> getRiderStats() async {
    return await fetch("/me/stats");
  }

  Future<APIResponse> getRiderRatingStats() async {
    return await fetch("/me/rate-stats");
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

  Future<APIResponse> deleteAccount(dynamic data) async {
    return await remove("/me", data);
  }

  // Bank Account Management
  Future<APIResponse> updateBankAccount(dynamic data) async {
    return await send("/riders/bank-account", data);
  }

  Future<APIResponse> getBankAccount() async {
    return await fetch("/riders/bank-account");
  }

  // Payout Management
  Future<APIResponse> getPayoutHistory(dynamic data) async {
    return await fetch(
      "/me/payout/history?page=${data['page']}&per_page=${data['per_page']}",
    );
  }

  Future<APIResponse> getPayoutById(dynamic data) async {
    return await fetch("/me/payout/${data['id']}");
  }

  Future<APIResponse> submitPayoutRequest(dynamic data) async {
    return await send("/me/wallet/payout", data);
  }

  // FAQ
  Future<APIResponse> getFAQs() async {
    return await fetch("/faqs");
  }

  Future<APIResponse> getFAQById(dynamic data) async {
    return await fetch("/faqs/${data['id']}");
  }

  // Transactions (additional methods beyond WalletsService)
  Future<APIResponse> getTransactionById(dynamic data) async {
    return await fetch("/me/transactions/${data['id']}");
  }
}
