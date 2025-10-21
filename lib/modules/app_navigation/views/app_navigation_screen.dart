import 'package:gorider/core/utils/exports.dart';

class AppNavigationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setSystemOverlayStyle(navigationColor: AppColors.whiteColor);
    return GetBuilder<AppNavigationController>(
      builder: (homeController) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: homeController.screens[homeController.currentScreenIndex],
          bottomNavigationBar: BottomAppBar(
            surfaceTintColor: AppColors.backgroundColor,
            padding: const EdgeInsets.all(0.0),
            color: AppColors.backgroundColor,
            elevation: 6,
            shape: const CircularNotchedRectangle(),
            // notchMargin: 12.sp,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
              decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  border: Border(
                      top: BorderSide(
                    color: AppColors.obscureTextColor,
                    width: 0.2.sp,
                  ))),
              height: 60.sp,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: BottomNavItem(
                      index: 0,
                      title: "Home",
                      activeIcon: SvgAssets.homeIcon,
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      index: 1,
                      title: "Deliveries",
                      activeIcon: SvgAssets.deliveryIcon,
                    ),
                  ),
                  Expanded(
                    child: BottomNavItem(
                      index: 2,
                      title: "Profile",
                      activeIcon: SvgAssets.settingsIcon,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String title;
  final String activeIcon;
  final int index;
  const BottomNavItem(
      {super.key,
      required this.title,
      required this.activeIcon,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppNavigationController>(
        builder: (homeController) => Container(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  homeController.changeScreenIndex(index);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      activeIcon,
                      height: 28.sp,
                      color: index == homeController.currentScreenIndex
                          ? AppColors.primaryColor
                          : AppColors.blackColor,
                      width: 28.sp,
                    ),
                    SizedBox(
                      height: 5.sp,
                    ),
                    customText(title,
                        fontWeight: index == homeController.currentScreenIndex
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: index == homeController.currentScreenIndex
                            ? AppColors.primaryColor
                            : AppColors.blackColor,
                        fontSize: 13.sp)
                  ],
                ),
              ),
            ));
  }
}
