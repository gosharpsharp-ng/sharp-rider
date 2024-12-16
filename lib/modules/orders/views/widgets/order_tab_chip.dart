import 'package:go_logistics_driver/utils/exports.dart';

class OrderTabChip extends StatelessWidget {
  final String title;
  final Function onSelected;
  final bool isSelected;
  const OrderTabChip(
      {super.key,
      this.title = "All",
      this.isSelected = false,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 5.sp),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              width: 0.8,
              color: isSelected
                  ? AppColors.primaryColor
                  : AppColors.obscureTextColor,
            ),
            color: isSelected ? AppColors.primaryColor : AppColors.whiteColor),
        child: Center(
          child: customText(
            title,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color:
                isSelected ? AppColors.whiteColor : AppColors.obscureTextColor,
          ),
        ),
      ),
    );
  }
}
