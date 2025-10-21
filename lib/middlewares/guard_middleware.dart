import 'package:gorider/providers/auth_provider.dart';

import 'package:gorider/core/utils/exports.dart';

class AuthMiddleware extends GetMiddleware {
  final authService = Get.find<AuthProvider>();
  @override
  RouteSettings? redirect(String? route) {
    return authService.localStorage.hasData('token')
        ? null
        : const RouteSettings(name: Routes.SIGN_IN);
  }
}
