import 'package:gorider/core/utils/exports.dart';

class DeliveryService extends CoreService {
  Future<DeliveryService> init() async => this;

  /// Trigger delivery actions (accept, pick, deliver)
  ///
  /// Endpoint: POST /riders/deliveries/{tracking_id}/trigger
  /// Body: { "action": "accepted"|"picked"|"delivered", "delivery_code": "..." }
  Future<APIResponse> triggerDeliveryAction({
    required String trackingId,
    required String action,
    String? deliveryCode,
  }) async {
    final Map<String, dynamic> body = {
      "action": action,
    };

    // Add delivery_code only for "delivered" action
    if (deliveryCode != null) {
      body["delivery_code"] = deliveryCode;
    }

    return await send(
      "/riders/deliveries/$trackingId/trigger",
      body,
    );
  }

  /// Legacy method for backward compatibility
  /// Will call the new trigger method with correct format
  @Deprecated('Use triggerDeliveryAction instead')
  Future<APIResponse> updateDeliveryStatus(dynamic data) async {
    return await triggerDeliveryAction(
      trackingId: data['tracking_id'].toString(),
      action: data['action'].toString(),
      deliveryCode: data['delivery_code']?.toString(),
    );
  }

  Future<APIResponse> getAllDeliveries(dynamic data) async {
    return await fetch(
        "/riders/deliveries?page=${data['page']}&per_page=${data['per_page']}");
  }

  Future<APIResponse> getDelivery(dynamic data) async {
    return await fetch("/riders/deliveries/${data['id']}");
  }

  Future<APIResponse> getRider(dynamic data) async {
    return await send("/api/auth/password-reset", data);
  }

  Future<APIResponse> searchDeliveries(dynamic data) async {
    return await fetch("/riders/deliveries?search=${data['search']}");
  }

  Future<APIResponse> verifyDeliveryOTP(dynamic data) async {
    return await send(
        "/riders/deliveries/${data['tracking_id']}/verify-otp",
        {"otp": data['otp']}
    );
  }
}
