import 'package:go_logistics_driver/utils/exports.dart';

class NotificationsHomeScreen extends StatelessWidget {
  const NotificationsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Notifications",
          centerTitle: false,
        ),
        body: RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () async {
            settingsController.getNotifications();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: Visibility(
              visible: settingsController.notifications.isNotEmpty,
              replacement: Visibility(
                visible: settingsController.isLoadingNotification &&
                    settingsController.notifications.isEmpty,
                replacement: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: customText("No Notifications yet"),
                    ),
                  ],
                ),
                child: Center(
                  child: customText("Loading...."),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      settingsController.notifications.length,
                          (i) => NotificationItem(
                        onTap: () {
                          settingsController.setSelectedNotification(
                              settingsController.notifications[i]);
                          Get.toNamed(Routes.NOTIFICATIONS_DETAILS);
                        },
                        notification: settingsController.notifications[i],
                        isLast: i == settingsController.notifications.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
