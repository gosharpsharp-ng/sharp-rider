import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gorider/core/services/analytics_service.dart';
import 'package:gorider/core/services/app_update/app_update_service.dart';
import 'package:gorider/core/services/push_notification_service.dart';
import 'package:gorider/core/utils/exports.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load appropriate env file based on build mode
  await dotenv.load(fileName: kReleaseMode ? '.env.prod' : '.env.dev');

  await GetStorage.init();
  await Get.putAsync(() => AuthProvider().init());
  Get.put(DeliveryNotificationServiceManager());

  // Initialize push notifications
  await PushNotificationService().initialize();

  // Initialize Firebase Analytics
  await AnalyticsService().initialize();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  setupServiceLocator();

  // Keep screen on while app is in foreground
  WakelockPlus.enable();

  runApp(const GoSharpDriver());

  // Check for app updates after app is running
  Future.delayed(const Duration(seconds: 2), () {
    AppUpdateService().initialize();
  });
}

class GoSharpDriver extends StatelessWidget {
  const GoSharpDriver({super.key});

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final screenSize = view.physicalSize / view.devicePixelRatio;
    final isTablet = screenSize.shortestSide >= 600;

    return ScreenUtilInit(
      designSize: isTablet ? screenSize : const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GoRider',
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          navigatorKey: Get.key,
          builder: (context, child) {
            return Builder(
              builder: (innerContext) {
                return MediaQuery(
                  data: MediaQuery.of(innerContext).copyWith(
                    textScaler: TextScaler.linear(0.85),
                    boldText: false,
                  ),
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}
