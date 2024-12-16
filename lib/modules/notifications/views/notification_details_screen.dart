import 'package:go_logistics_driver/utils/exports.dart';

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: defaultAppBar(
        bgColor: AppColors.backgroundColor,
        title: "Notification Details",
        centerTitle: false,
      ),
      body: Container(
        height: 1.sh,
        width: 1.sw,
        color: AppColors.backgroundColor,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText("ABC Station: Get 10% off!",
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                  overflow: TextOverflow.visible),
              SizedBox(height: 10.sp,),
              customText("Enjoy a 10% discount on all fuel purchases at participating stations. This exclusive offer is available for a limited time only, so fill up your tank and save big!",
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp,
                  overflow: TextOverflow.visible),
            ],
          ),
        ),
      ),
    );
  }
}
