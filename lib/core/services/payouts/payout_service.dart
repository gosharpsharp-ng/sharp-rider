import 'package:gorider/core/utils/exports.dart';

class PayoutService extends CoreService {
  Future<PayoutService> init() async => this;

  /// Get payout history with pagination
  Future<APIResponse> getPayoutHistory({
    required int page,
    required int perPage,
    String? status,
  }) async {
    String url = "/me/payout/history?page=$page&per_page=$perPage";
    if (status != null && status.isNotEmpty) {
      url += "&status=$status";
    }
    return await fetch(url);
  }

  /// Get a single payout request by ID
  Future<APIResponse> getPayoutById(int id) async {
    return await fetch("/me/payout/$id");
  }

  /// Submit a new payout request
  Future<APIResponse> submitPayoutRequest(dynamic data) async {
    return await send("/me/wallet/payout", data);
  }

  /// Cancel a pending payout request
  Future<APIResponse> cancelPayoutRequest(int id) async {
    return await remove("/me/payout/$id", {});
  }

  /// Get payout statistics
  Future<APIResponse> getPayoutStats() async {
    return await fetch("/me/payout/stats");
  }
}
