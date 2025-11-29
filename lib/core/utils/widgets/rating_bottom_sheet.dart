import 'package:gorider/core/utils/exports.dart';

class RatingBottomSheet extends StatelessWidget {
  const RatingBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 250.h,
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 5.h,
          ),
          customText(
            "Rate your experience!",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            color: AppColors.primaryColor,
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(
            height: 20.h,
          ),
          customText(
              "This information is important to us, we use it to create a better user experience for you",
              overflow: TextOverflow.visible,
              color: AppColors.blackColor,
              textAlign: TextAlign.center,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal),
          SizedBox(
            height: 20.h,
          ),
          RatingBarIndicator(
            rating: 0,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              size: 15.sp,
              color: AppColors.obscureTextColor,
            ),
            itemCount: 5,
            itemSize: 30.sp,
            direction: Axis.horizontal,
          ),
        ],
      ),
    );
  }
}
