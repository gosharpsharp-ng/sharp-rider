import 'package:gorider/core/utils/exports.dart';

class AuthenticationService extends CoreService {
  Future<AuthenticationService> init() async => this;

  Future<APIResponse> login(dynamic data) async {
    return await send("/auth/rider/login", data);
  }

  Future<APIResponse> requestForgotPasswordOtp(dynamic data) async {
    return await send("/auth/rider/password-reset/request-otp", data);
  }

  Future<APIResponse> verifyForgotPasswordOTP(dynamic data) async {
    return await send("/auth/rider/password-reset/verify-otp", data);
  }

  Future<APIResponse> resetPassword(dynamic data) async {
    return await send("/auth/rider/reset/password", data);
  }

  Future<APIResponse> verifyPhoneOtp(dynamic data) async {
    return await send("/auth/rider/verify-phone", data);
  }

  Future<APIResponse> sendOtp(dynamic data) async {
    return await fetch("/auth/get-otp?identifier=${data['identifier']}");
  }

  Future<APIResponse> verifyEmailOtp(dynamic data) async {
    return await send("/auth/verify", data);
  }

  /// Rider onboarding/registration endpoint
  /// POST /auth/rider/onboard
  Future<APIResponse> riderOnboard(dynamic data) async {
    return await send("/auth/rider/onboard", data);
  }

  /// Rider login endpoint
  /// POST /auth/rider/login
  Future<APIResponse> riderLogin(dynamic data) async {
    return await send("/auth/rider/login", data);
  }

  Future<APIResponse> getUserProfile(dynamic data) async {
    return await send("/riders/profile", data);
  }

  Future<APIResponse> updateUserProfile(dynamic data) async {
    return await update("/riders/profile", data);
  }
}
