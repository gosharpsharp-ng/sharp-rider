import 'package:gorider/middlewares/guard_middleware.dart';
import 'package:gorider/core/utils/exports.dart';
import 'package:gorider/modules/settings/bindings/faq_bindings.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBindings(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingScreen(),
      binding: OnboardingBindings(),
    ),

    //
    GetPage(
      name: Routes.SIGNUP_SCREEN,
      page: () => const SignUpScreen(),
      binding: SignUpBindings(),
    ),
    GetPage(
      name: Routes.SIGNUP_OTP_SCREEN,
      page: () => const SignUpOtpScreen(),
    ),
    GetPage(
      name: Routes.SIGN_IN,
      page: () => const SignInScreen(),
      binding: SignInBindings(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD_EMAIL_ENTRY_SCREEN,
      page: () => const ResetPasswordEmailEntry(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD_OTP_SCREEN,
      page: () => const ResetPasswordOtpScreen(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: Routes.RESET_PASSWORD_NEW_PASSWORD_SCREEN,
      page: () => const NewPasswordScreen(),
      binding: PasswordResetBinding(),
    ),
    GetPage(
      name: Routes.LOCATION_PERMISSION_SCREEN,
      page: () => const LocationPermissionScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.APP_NAVIGATION,
      page: () => const AppNavigationScreen(),
      middlewares: [AuthMiddleware()],
      binding: AppNavigationBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardScreen(),
      middlewares: [AuthMiddleware()],
      binding: DashboardBindings(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS_HOME,
      page: () => const NotificationsHomeScreen(),
      middlewares: [AuthMiddleware()],
      binding: NotificationsBindings(),
    ),
    GetPage(
      name: Routes.NOTIFICATIONS_DETAILS,
      page: () => const NotificationDetailsScreen(),
      middlewares: [AuthMiddleware()],
      binding: NotificationsBindings(),
    ),
    GetPage(
      name: Routes.DELIVERIES_HOME,
      page: () => const DeliveriesHistoryScreen(),
      middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.RIDER_PERFORMANCE_SCREEN,
      page: () => const PerformanceScreen(),
      middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_DETAILS,
      page: () => const DeliveryDetailsScreen(),
      middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_INVOICE_DETAILS,
      page: () => const DeliveryInvoiceDetailsScreen(),
      middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_TRACKING_SCREEN,
      page: () => const DeliveryTrackingScreen(),
      middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_SEARCH_SCREEN,
      page: () => const SearchDeliveriesScreen(),
      middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_PRE_ACCEPTANCE_DETAILS,
      page: () => const DeliveryPreAcceptanceDetailsScreen(),
      middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_PACKAGE_INFORMATION_UPLOAD_SCREEN,
      page: () => const DeliveryPackageInformationUploadScreen(),
      middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),
    GetPage(
      name: Routes.DELIVERY_ACCEPTANCE_RESULT_SCREEN,
      page: () => const DeliveryAcceptanceResultScreen(),
      middlewares: [AuthMiddleware()],
      binding: DeliveriesBindings(),
    ),

    GetPage(
      name: Routes.SETTINGS_HOME_SCREEN,
      page: () => const SettingsHomeScreen(),
      middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE_SCREEN,
      page: () => const EditProfileScreen(),
      middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),
    GetPage(
      name: Routes.ADD_VEHICLE_SCREEN,
      page: () => const AddVehicleScreen(),
      middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),
    GetPage(
      name: Routes.ADD_LICENSE_SCREEN,
      page: () => const AddLicenseScreen(),
      middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),
    GetPage(
      name: Routes.VEHICLE_AND_LICENSE_DETAILS_SCREEN,
      page: () => const VehicleAndLicenseDetailsScreen(),
      middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD_SCREEN,
      page: () => const ChangePasswordScreen(),
      middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),
    GetPage(
      name: Routes.FAQS_SCREEN,
      page: () => const FaqScreen(),
      middlewares: [AuthMiddleware()],
      binding: FaqBindings(),
    ),
    GetPage(
      name: Routes.TRANSACTIONS_SCREEN,
      page: () => const TransactionsScreen(),
      middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: Routes.TRANSACTION_DETAILS_SCREEN,
      page: () => const TransactionDetailsScreen(),
      middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: Routes.PAYOUT_HISTORY_SCREEN,
      page: () => const PayoutHistoryScreen(),
      middlewares: [AuthMiddleware()],
      binding: PayoutBindings(),
    ),
    GetPage(
      name: Routes.PAYOUT_REQUEST_SCREEN,
      page: () => const PayoutRequestScreen(),
      middlewares: [AuthMiddleware()],
      binding: PayoutBindings(),
    ),
    GetPage(
      name: Routes.PAYOUT_DETAILS_SCREEN,
      page: () => const PayoutDetailsScreen(),
      middlewares: [AuthMiddleware()],
      binding: PayoutBindings(),
    ),
    GetPage(
      name: Routes.BANK_DETAILS_SCREEN,
      page: () => const BankDetailsScreen(),
      middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.ADD_WITHDRAWAL_ACCOUNT_SCREEN,
      page: () => const AddWithdrawalAccountScreen(),
      middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.FUND_WALLET_AMOUNT_SCREEN,
      page: () => const FundWalletAmountScreen(),
      middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: Routes.FUND_WALLET_SUCCESS_SCREEN,
      page: () => const FundWalletSuccessScreen(),
      middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: Routes.FUND_WALLET_FAILURE_SCREEN,
      page: () => const FundWalletFailureScreen(),
      middlewares: [AuthMiddleware()],
      binding: WalletBindings(),
    ),
    GetPage(
      name: Routes.RATINGS_AND_REVIEWS_HOME,
      page: () => const RatingsScreen(),
      middlewares: [AuthMiddleware()],
      binding: SettingsBindings(),
    ),

    // GetPage(
    //   name: Routes.WEALTHMATE_TRANSACTION_DETAILS,
    //   page: () => const WealthTransactionDetailsView(),
    //   binding: WealthmateBindings(),
    //   middlewares: [
    //     DomainGuard(),
    //     AuthGuard(),
    //   ],
    // ),
  ];
}
