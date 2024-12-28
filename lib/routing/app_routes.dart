// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const SIGN_IN = _Paths.SIGN_IN;
  static const SIGNUP_SCREEN = _Paths.SIGNUP_SCREEN;
  static const SIGNUP_OTP_SCREEN = _Paths.SIGNUP_OTP_SCREEN;
  static const SIGNUP_SUCCESS_SCREEN = _Paths.SIGNUP_SUCCESS_SCREEN;
  static const RESET_PASSWORD_EMAIL_ENTRY_SCREEN =
      _Paths.RESET_PASSWORD_EMAIL_ENTRY_SCREEN;
  static const RESET_PASSWORD_NEW_PASSWORD_SCREEN =
      _Paths.RESET_PASSWORD_NEW_PASSWORD_SCREEN;
  static const RESET_PASSWORD_OTP_SCREEN = _Paths.RESET_PASSWORD_OTP_SCREEN;
  static const RESET_PASSWORD_SUCCESS_SCREEN =
      _Paths.RESET_PASSWORD_SUCCESS_SCREEN;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const ONBOARDING_BUSINESS_OPERATIONS =
      _Paths.ONBOARDING_BUSINESS_OPERATIONS;
  static const ONBOARDING_BANK_INFORMATION = _Paths.ONBOARDING_BANK_INFORMATION;
  static const APP_NAVIGATION = _Paths.APP_NAVIGATION;
  static const MENU_DETAILS = _Paths.MENU_DETAILS;
  static const ADD_MENU = _Paths.ADD_MENU;
  static const EDIT_MENU = _Paths.EDIT_MENU;
  static const MENU_HOME = _Paths.MENU_HOME;
  static const ORDERS_HOME = _Paths.ORDERS_HOME;
  static const ORDER_DETAILS = _Paths.ORDER_DETAILS;
  static const ORDER_INVOICE_DETAILS = _Paths.ORDER_INVOICE_DETAILS;
  static const ORDER_SEARCH_SCREEN = _Paths.ORDER_SEARCH_SCREEN;
  static const ORDER_TRACKING_SCREEN = _Paths.ORDER_TRACKING_SCREEN;
  static const ORDER_PRE_ACCEPTANCE_DETAILS =
      _Paths.ORDER_PRE_ACCEPTANCE_DETAILS;
  static const ORDER_ITEM_INPUT_SCREEN = _Paths.ORDER_ITEM_INPUT_SCREEN;
  static const ORDER_PAYMENT_OPTIONS_SCREEN =
      _Paths.ORDER_PAYMENT_OPTIONS_SCREEN;
  static const ORDER_SUMMARY_SCREEN = _Paths.ORDER_SUMMARY_SCREEN;
  static const ORDER_PACKAGE_INFORMATION_UPLOAD_SCREEN =
      _Paths.ORDER_PACKAGE_INFORMATION_UPLOAD_SCREEN;
  static const NOTIFICATIONS_HOME = _Paths.NOTIFICATIONS_HOME;
  static const NOTIFICATIONS_DETAILS = _Paths.NOTIFICATIONS_DETAILS;
  static const RATINGS_AND_REVIEWS_HOME = _Paths.RATINGS_AND_REVIEWS_HOME;
  static const SETTINGS_HOME_SCREEN = _Paths.SETTINGS_HOME_SCREEN;
  static const PROFILE_SETTINGS_SCREEN = _Paths.PROFILE_SETTINGS_SCREEN;
  static const EDIT_PROFILE_SCREEN = _Paths.EDIT_PROFILE_SCREEN;
  static const CURRENT_PASSWORD_ENTRY_SCREEN =
      _Paths.CURRENT_PASSWORD_ENTRY_SCREEN;
  static const NEW_PASSWORD_ENTRY_SCREEN = _Paths.NEW_PASSWORD_ENTRY_SCREEN;
  static const FAQS_SCREEN = _Paths.FAQS_SCREEN;
  static const WALLETS_HOME_SCREEN = _Paths.WALLETS_HOME_SCREEN;
  static const TRANSACTIONS_SCREEN = _Paths.TRANSACTIONS_SCREEN;
  static const TRANSACTION_DETAILS_SCREEN = _Paths.TRANSACTION_DETAILS_SCREEN;
  static const ADD_WITHDRAWAL_ACCOUNT_SCREEN =
      _Paths.ADD_WITHDRAWAL_ACCOUNT_SCREEN;
  static const WITHDRAWAL_AMOUNT_SCREEN = _Paths.WITHDRAWAL_AMOUNT_SCREEN;
}

abstract class _Paths {
  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const SIGN_IN = '/sign_in';
  static const SIGNUP_SCREEN = '/signup_screen';
  static const SIGNUP_OTP_SCREEN = '/signup_otp_screen';
  static const SIGNUP_SUCCESS_SCREEN = '/signup_success_screen';
  static const RESET_PASSWORD_EMAIL_ENTRY_SCREEN =
      '/reset_password_email_entry_screen';
  static const RESET_PASSWORD_NEW_PASSWORD_SCREEN =
      '/reset_password_new_password_screen';
  static const RESET_PASSWORD_OTP_SCREEN = '/reset_password_otp_screen';
  static const RESET_PASSWORD_SUCCESS_SCREEN = '/reset_password_success_screen';
  static const DASHBOARD = '/dashboard';
  static const ONBOARDING_BUSINESS_OPERATIONS =
      '/onboarding_business_operations';
  static const ONBOARDING_BANK_INFORMATION = '/onboarding_bank_information';
  static const APP_NAVIGATION = '/app_navigation';
  static const MENU_DETAILS = '/menu_details';
  static const ADD_MENU = '/add_menu';
  static const EDIT_MENU = '/edit_menu';
  static const MENU_HOME = '/menu_home';

  static const ORDERS_HOME = '/orders_home';
  static const ORDER_DETAILS = '/order_details';
  static const ORDER_PRE_ACCEPTANCE_DETAILS = '/order_pre_acceptance_details';
  static const ORDER_PACKAGE_INFORMATION_UPLOAD_SCREEN =
      '/order_package_information_upload_screen';
  static const ORDER_TRACKING_SCREEN = '/order_tracking_screen';
  static const ORDER_SEARCH_SCREEN = '/order_search_screen';
  static const ORDER_INVOICE_DETAILS = '/order_invoice_details';
  static const ORDER_ITEM_INPUT_SCREEN = '/order_item_input_screen';
  static const ORDER_PAYMENT_OPTIONS_SCREEN = '/order_payment_options_screen';
  static const ORDER_SUMMARY_SCREEN = '/order_summary_screen';

  static const NOTIFICATIONS_HOME = '/notifications_home';
  static const NOTIFICATIONS_DETAILS = '/notifications_details';

  static const SETTINGS_HOME_SCREEN = '/settings_home_screen';
  static const PROFILE_SETTINGS_SCREEN = '/profile_settings_screen';
  static const EDIT_PROFILE_SCREEN = '/edit_profile_screen';
  static const CURRENT_PASSWORD_ENTRY_SCREEN = '/current_password_entry_screen';
  static const NEW_PASSWORD_ENTRY_SCREEN = '/new_password_entry_screen';
  static const FAQS_SCREEN = '/faqs_screen';

  static const WALLETS_HOME_SCREEN = '/wallets_home_screen';
  static const TRANSACTIONS_SCREEN = '/transactions_screen';
  static const TRANSACTION_DETAILS_SCREEN = '/transaction_details_screen';

  static const RATINGS_AND_REVIEWS_HOME = '/ratings_and_reviews_home';
  static const ADD_WITHDRAWAL_ACCOUNT_SCREEN = '/add_withdrawal_account_screen';
  static const WITHDRAWAL_AMOUNT_SCREEN = '/withdrawal_amount_screen';
}
