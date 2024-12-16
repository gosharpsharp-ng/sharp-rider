
import 'package:go_logistics_driver/utils/exports.dart';

class NotificationsHomeScreen extends StatelessWidget {
  const NotificationsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: defaultAppBar(
        bgColor: AppColors.backgroundColor,
        title: "Notifications",
        centerTitle: false,
      ),
      body: Container(
        height: 1.sh,
        width: 1.sw,
        color: AppColors.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TitleSectionBox(
                title: "Today",
                backgroundColor: AppColors.whiteColor,
                children: [
                  NotificationItem(
                    onTap: () {
                      Get.to(NotificationDetailsScreen());
                    },
                    isRead: true,
                  ),
                  NotificationItem(onTap: () {}),
                  NotificationItem(
                    onTap: () {},
                    isRead: true,
                  ),
                  NotificationItem(
                    onTap: () {},
                    isRead: true,
                  ),
                  NotificationItem(onTap: () {},isLast: true,),
                ],
              ),
              TitleSectionBox(
                title: "2 weeks ago",
                backgroundColor: AppColors.whiteColor,
                children: [
                  NotificationItem(
                    onTap: () {},
                    isRead: true,
                  ),
                  NotificationItem(
                    onTap: () {},
                    isRead: true,
                  ),
                  NotificationItem(
                    onTap: () {},
                    isRead: true,
                  ),
                  NotificationItem(
                    onTap: () {},
                    isRead: true,
                  ),
                  NotificationItem(
                    onTap: () {},
                    isRead: true,
                  ),
                  NotificationItem(
                    onTap: () {},
                    isRead: true,
                  ),
                  NotificationItem(
                    onTap: () {},
                    isRead: true,
                    isLast: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
