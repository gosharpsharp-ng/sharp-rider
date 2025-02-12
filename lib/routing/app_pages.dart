
import 'package:go_logistics_driver/utils/exports.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

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
      name: _Paths.DELIVERIES_HOME,
      page: () => const DeliveriesHistoryScreen(),
      binding: DeliveriesBindings(),
    ), GetPage(
      name: _Paths.RIDER_PERFORMANCE_SCREEN,
      page: () => const PerformanceScreen(),
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_DETAILS,
      page: () => const DeliveryDetailsScreen(),
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_INVOICE_DETAILS,
      page: () => const DeliveryInvoiceDetailsScreen(),
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_TRACKING_SCREEN,
      page: () => const DeliveryTrackingScreen(),
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_SEARCH_SCREEN,
      page: () => const SearchDeliveriesScreen(),
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_PRE_ACCEPTANCE_DETAILS,
      page: () => const DeliveryPreAcceptanceDetailsScreen(),
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: _Paths.DELIVERY_PACKAGE_INFORMATION_UPLOAD_SCREEN,
      page: () => const DeliveryPackageInformationUploadScreen(),
      binding: DeliveriesBindings(),
    ),

    GetPage(
      name: _Paths.SETTINGS_HOME_SCREEN,
      page: () => const SettingsHomeScreen(),
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE_SCREEN,
      page: () => const EditProfileScreen(),
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.ADD_VEHICLE_SCREEN,
      page: () => const AddVehicleScreen(),
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.ADD_LICENSE_SCREEN,
      page: () => const AddLicenseScreen(),
      binding: SettingsBindings(),
    ), GetPage(
      name: _Paths.VEHICLE_AND_LICENSE_DETAILS_SCREEN,
      page: () => const VehicleAndLicenseDetailsScreen(),
      binding: SettingsBindings(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD_SCREEN,
      page: () => const ChangePasswordScreen(),
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
      binding: WalletBindings(),
    ),
    GetPage(
      name: _Paths.WITHDRAWAL_AMOUNT_SCREEN,
      page: () => const WithdrawalAmountScreen(),
      binding: WalletBindings(),
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
