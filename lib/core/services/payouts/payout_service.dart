import 'package:gorider/core/utils/exports.dart';

class PayoutService extends CoreService {
  Future<PayoutService> init() async => this;

  /// Submit a new payout request
  Future<APIResponse> createPayoutRequest(dynamic data) async {
    return await send("/riders/payout/request", data);
  }

  /// Get all payout requests history with pagination
  Future<APIResponse> getPayoutHistory({
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    String endpoint = "/riders/payout/history?page=$page&per_page=$perPage";

    if (status != null && status.isNotEmpty) {
      endpoint += "&status=$status";
    }

    return await fetch(endpoint);
  }

  /// Get single payout request details
  Future<APIResponse> getPayoutRequestDetails(int payoutId) async {
    return await fetch("/riders/payout-requests/$payoutId");
  }

  /// Cancel a pending payout request
  Future<APIResponse> cancelPayoutRequest(int payoutId) async {
    return await send("/riders/payout-requests/$payoutId/cancel", {});
  }

  /// Get payout statistics/summary
  Future<APIResponse> getPayoutStatistics() async {
    return await fetch("/riders/payout-requests/statistics");
  }

  /// Get available payment methods for payouts
  Future<APIResponse> getPaymentMethods() async {
    return await fetch("/riders/payout-methods");
  }

  /// Get minimum payout amount and other limits
  Future<APIResponse> getPayoutLimits() async {
    return await fetch("/riders/payout-limits");
  }

  /// Resend payout request (if failed)
  Future<APIResponse> resendPayoutRequest(int payoutId) async {
    return await send("/riders/payout-requests/$payoutId/resend", {});
  }
}
