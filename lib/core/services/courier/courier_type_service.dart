import 'package:gorider/core/services/core_service.dart';

import '../models/api_response.dart';

class CourierTypeService extends CoreService {
  /// Fetch active courier types with pagination
  /// GET /courier-types/active?page=1&per_page=10
  Future<APIResponse> getActiveCourierTypes({
    int page = 1,
    int perPage = 100,
  }) async {
    return await fetchByParams(
      '/courier-types/active',
      {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );
  }

  /// Fetch all courier types
  /// GET /courier-types
  Future<APIResponse> getAllCourierTypes() async {
    return await fetch('/courier-types/active');
  }

  /// Fetch a specific courier type by ID
  /// GET /courier-types/{id}
  Future<APIResponse> getCourierTypeById(int id) async {
    return await fetch('/courier-types/$id');
  }
}
