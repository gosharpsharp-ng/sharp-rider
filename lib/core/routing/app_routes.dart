// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  // Auth & Onboarding
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const SIGN_IN = '/sign_in';
  static const SIGNUP_SCREEN = '/signup_screen';
  static const SIGNUP_OTP_SCREEN = '/signup_otp_screen';
  static const SIGNUP_SUCCESS_SCREEN = '/signup_success_screen';

  // Password Reset
  static const RESET_PASSWORD_EMAIL_ENTRY_SCREEN = '/reset_password_email_entry_screen';
  static const RESET_PASSWORD_NEW_PASSWORD_SCREEN = '/reset_password_new_password_screen';
  static const RESET_PASSWORD_OTP_SCREEN = '/reset_password_otp_screen';
  static const RESET_PASSWORD_SUCCESS_SCREEN = '/reset_password_success_screen';

  // Permissions
  static const LOCATION_PERMISSION_SCREEN = '/location_permission_screen';

  // Main App
  static const APP_NAVIGATION = '/app_navigation';
  static const DASHBOARD = '/dashboard';

  // Deliveries
  static const DELIVERIES_HOME = '/deliveries_home';
  static const DELIVERY_DETAILS = '/delivery_details';
  static const DELIVERY_INVOICE_DETAILS = '/delivery_invoice_details';
  static const DELIVERY_SEARCH_SCREEN = '/delivery_search_screen';
  static const DELIVERY_TRACKING_SCREEN = '/delivery_tracking_screen';
  static const DELIVERY_PRE_ACCEPTANCE_DETAILS = '/delivery_pre_acceptance_details';
  static const DELIVERY_ITEM_INPUT_SCREEN = '/delivery_item_input_screen';
  static const DELIVERY_PAYMENT_OPTIONS_SCREEN = '/delivery_payment_options_screen';
  static const DELIVERY_SUMMARY_SCREEN = '/delivery_summary_screen';
  static const DELIVERY_PACKAGE_INFORMATION_UPLOAD_SCREEN = '/delivery_package_information_upload_screen';
  static const DELIVERY_ACCEPTANCE_RESULT_SCREEN = '/delivery_acceptance_result_screen';

  // Notifications
  static const NOTIFICATIONS_HOME = '/notifications_home';
  static const NOTIFICATIONS_DETAILS = '/notifications_details';

  // Settings & Profile
  static const SETTINGS_HOME_SCREEN = '/settings_home_screen';
  static const PROFILE_SETTINGS_SCREEN = '/profile_settings_screen';
  static const EDIT_PROFILE_SCREEN = '/edit_profile_screen';
  static const CHANGE_PASSWORD_SCREEN = '/change_password_screen';
  static const DELETE_ACCOUNT_SCREEN = '/delete_account_screen';
  static const FAQS_SCREEN = '/faqs_screen';

  // Vehicle & License
  static const ADD_VEHICLE_SCREEN = '/add_vehicle_screen';
  static const UPDATE_VEHICLE_SCREEN = '/update_vehicle_screen';
  static const ADD_LICENSE_SCREEN = '/add_license_screen';
  static const UPDATE_LICENSE_SCREEN = '/update_license_screen';
  static const VEHICLE_AND_LICENSE_DETAILS_SCREEN = '/vehicle_and_license_details_screen';

  // Wallet & Transactions
  static const WALLETS_HOME_SCREEN = '/wallets_home_screen';
  static const TRANSACTIONS_SCREEN = '/transactions_screen';
  static const TRANSACTION_DETAILS_SCREEN = '/transaction_details_screen';
  static const BANK_DETAILS_SCREEN = '/bank_details_screen';
  static const ADD_WITHDRAWAL_ACCOUNT_SCREEN = '/add_withdrawal_account_screen';
  static const WITHDRAWAL_AMOUNT_SCREEN = '/withdrawal_amount_screen';
  static const FUND_WALLET_AMOUNT_SCREEN = '/fund_wallet_amount_screen';
  static const FUND_WALLET_SUCCESS_SCREEN = '/fund_wallet_success_screen';
  static const FUND_WALLET_FAILURE_SCREEN = '/fund_wallet_failure_screen';

  // Payouts
  static const PAYOUT_HISTORY_SCREEN = '/payout_history_screen';
  static const PAYOUT_REQUEST_SCREEN = '/payout_request_screen';
  static const PAYOUT_DETAILS_SCREEN = '/payout_details_screen';

  // Performance & Reviews
  static const RIDER_PERFORMANCE_SCREEN = '/rider_performance_screen';
  static const RATINGS_AND_REVIEWS_HOME = '/ratings_and_reviews_home';
}
