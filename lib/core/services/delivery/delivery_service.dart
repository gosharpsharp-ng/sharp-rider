import 'package:gorider/core/utils/exports.dart';

class DeliveryService extends CoreService {
  Future<DeliveryService> init() async => this;

  Future<APIResponse> updateDeliveryStatus(dynamic data) async {
    return await send(
        "/riders/deliveries/${data['tracking_id'].toString()}?action=${data['action']}",
        null);
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
}
