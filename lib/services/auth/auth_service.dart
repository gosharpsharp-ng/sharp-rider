import 'package:go_logistics_driver/utils/exports.dart';

class AuthenticationService extends CoreService {
  Future<AuthenticationService> init() async => this;

  Future<APIResponse> login(dynamic data) async {
    return await send("/api/auth/login", data);
  }

  Future<APIResponse> requestForgotPasswordOtp(dynamic data) async {
    return await send("/api/auth/password-reset/request-otp", data);
  }

  Future<APIResponse> verifyForgotPasswordOTP(dynamic data) async {
    return await send("/api/auth/password-reset/verify-otp", data);
  }

  Future<APIResponse> resetPassword(dynamic data) async {
    return await send("/api/auth/password-reset", data);
  }

  Future<APIResponse> requestSignupOtp(dynamic data) async {
    return await send("/api/auth/signup/request-otp", data);
  }

  Future<APIResponse> verifyPhoneOtp(dynamic data) async {
    return await send("/auth/verify/phone", data);
  }
  Future<APIResponse> sendOtp(dynamic data) async {
    return await fetch("/auth/get-otp?login=${data['login']}");
  }

  Future<APIResponse> verifyEmailOtp(dynamic data) async {
    return await send("/auth/verify/email", data);
  }

  Future<APIResponse> signup(dynamic data) async {
    return await send("/api/auth/signup", data);
  }
}
