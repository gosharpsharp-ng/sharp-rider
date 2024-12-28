
import 'package:go_logistics_driver/utils/exports.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingScreen(),
      binding: OnboardingBindings(),
    ),

    //
    GetPage(
      name: _Paths.SIGNUP_SCREEN,
      page: () => const SignUpScreen(),
      binding: SignUpBindings(),
    ),
    GetPage(
      name: _Paths.SIGNUP_OTP_SCREEN,
      page: () => SignUpOtpScreen(),
      binding: SignUpBindings(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => const SignInScreen(),
      binding: SignInBindings(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD_EMAIL_ENTRY_SCREEN,
      page: () => const ResetPasswordEmailEntry(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD_OTP_SCREEN,
      page: () => ResetPasswordOtpScreen(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD_NEW_PASSWORD_SCREEN,
      page: () => const NewPasswordScreen(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => const SignInScreen(),
      binding: SignInBindings(),
    ),
    GetPage(
      name: _Paths.APP_NAVIGATION,
      page: () => AppNavigationScreen(),
      binding: AppNavigationBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardScreen(),
      binding: DashboardBindings(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS_HOME,
      page: () => const NotificationsHomeScreen(),
      binding: NotificationsBindings(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS_DETAILS,
      page: () => const NotificationDetailsScreen(),
      binding: NotificationsBindings(),
    ),
    GetPage(
      name: _Paths.ORDERS_HOME,
      page: () => const OrdersHistoryScreen(),
      binding: OrdersBindings(),
    ),
    GetPage(
      name: _Paths.ORDER_DETAILS,
      page: () => const OrderDetailsScreen(),
      binding: OrdersBindings(),
    ),
    GetPage(
      name: _Paths.ORDER_INVOICE_DETAILS,
      page: () => const OrderInvoiceDetailsScreen(),
      binding: OrdersBindings(),
    ),
    GetPage(
      name: _Paths.ORDER_TRACKING_SCREEN,
      page: () => const OrderTrackingScreen(),
      binding: OrdersBindings(),
    ),
    GetPage(
      name: _Paths.ORDER_SEARCH_SCREEN,
      page: () => const OrdersSearchScreen(),
      binding: OrdersBindings(),
    ),
    GetPage(
      name: _Paths.ORDER_PRE_ACCEPTANCE_DETAILS,
      page: () => const OrderPreAcceptanceDetailsScreen(),
      binding: OrdersBindings(),
    ),
    GetPage(
      name: _Paths.ORDER_PACKAGE_INFORMATION_UPLOAD_SCREEN,
      page: () => const OrderPackageInformationUploadScreen(),
      binding: OrdersBindings(),
    ),

    GetPage(
      name: _Paths.SETTINGS_HOME_SCREEN,
      page: () => const SettingsHomeScreen(),
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.PROFILE_SETTINGS_SCREEN,
      page: () => const ProfileSettingsScreen(),
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_SCREEN,
      page: () => const EditProfileScreen(),
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.CURRENT_PASSWORD_ENTRY_SCREEN,
      page: () => const CurrentPasswordEntryScreen(),
      binding: SettingsBindings(),
    ), GetPage(
      name: _Paths.NEW_PASSWORD_ENTRY_SCREEN,
      page: () => const NewPasswordEntryScreen(),
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.FAQS_SCREEN,
      page: () => const FaqScreen(),
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.TRANSACTIONS_SCREEN,
      page: () => const TransactionsScreen(),
      binding: WalletBindings(),
    ),
    GetPage(
      name: _Paths.TRANSACTION_DETAILS_SCREEN,
      page: () => const TransactionDetailsScreen(),
      binding: WalletBindings(),
    ),
 GetPage(
      name: _Paths.ADD_WITHDRAWAL_ACCOUNT_SCREEN,
      page: () => const AddWithdrawalAccountScreen(),
      binding: WithdrawalBindings(),
    ),
 GetPage(
      name: _Paths.WITHDRAWAL_AMOUNT_SCREEN,
      page: () => const WithdrawalAmountScreen(),
      binding: WithdrawalBindings(),
    ),

    // GetPage(
    //   name: _Paths.WEALTHMATE_TRANSACTION_DETAILS,
    //   page: () => const WealthTransactionDetailsView(),
    //   binding: WealthmateBindings(),
    //   middlewares: [
    //     DomainGuard(),
    //     AuthGuard(),
    //   ],
    // ),
  ];
}
