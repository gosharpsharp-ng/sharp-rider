import 'package:go_logistics_driver/utils/exports.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await ScreenUtil.ensureScreenSize();
  await Get.putAsync(() => AuthProvider().init());
  Get.put(DeliveryNotificationServiceManager());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  setupServiceLocator();
  //  1.1.2: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  // call the useSystemCallingUI
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
    runApp(GoSharpDriver(navigatorKey: navigatorKey));
  });
}

class GoSharpDriver extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const GoSharpDriver({super.key, required this.navigatorKey});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).height));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoRider',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      navigatorKey: navigatorKey,
    );
  }
}
