import 'package:go_logistics_driver/modules/orders/views/orders_history_screen.dart';

import '../../../utils/exports.dart';

class AppNavigationController extends GetxController {
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  int currentScreenIndex = 0;
  changeScreenIndex(selectedIndex) {
    currentScreenIndex = selectedIndex;
    update();
  }

  List<Widget> screens = [
    const DashboardScreen(),
    const OrdersHistoryScreen(),
    // WalletHomeScreen(),
    const SettingsHomeScreen(),
  ];
}
