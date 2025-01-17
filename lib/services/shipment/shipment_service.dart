import 'package:go_logistics_driver/utils/exports.dart';

class ShipmentService extends CoreService {
  Future<ShipmentService> init() async => this;

  Future<APIResponse> updateShipmentStatus(dynamic data) async {
    return await send(
        "/shipments/${data['tracking_id'].toString()}?action=${data['action']}",
        null);
  }
  Future<APIResponse> getAllShipment() async {
    return await fetch("/shipments");
  }

  Future<APIResponse> getShipment(dynamic data) async {
    return await fetch("/shipments/${data['id']}");
  }

  Future<APIResponse> getRider(dynamic data) async {
    return await send("/api/auth/password-reset", data);
  }
  Future<APIResponse> searchShipments(dynamic data) async {
    return await fetch("/shipments?search=${data['search']}");
  }
}
