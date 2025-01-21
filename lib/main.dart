import 'package:go_logistics_driver/utils/exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await ScreenUtil.ensureScreenSize();
  Get.put(ServiceManager());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  setupServiceLocator();
  runApp(const GoSharpDriver());
}

class GoSharpDriver extends StatelessWidget {
  const GoSharpDriver({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoSharpSharp Driver',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
