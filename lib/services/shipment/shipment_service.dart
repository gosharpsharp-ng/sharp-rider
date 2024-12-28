import 'package:go_logistics_driver/utils/exports.dart';

class ShipmentService extends CoreService {
  Future<ShipmentService> init() async => this;

  Future<APIResponse> createShipment(dynamic data) async {
    return await send("/shipments", data);
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
}
