import 'dart:developer';

import 'package:gorider/core/utils/exports.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.title = "",
      required this.onPressed,
      this.backgroundColor = AppColors.redColor,
      this.fontColor = AppColors.whiteColor,
      this.borderColor = Colors.transparent,
      this.width = 260,
      this.height = 52,
      this.fontSize = 14,
      this.isBusy = false,
      this.icon = Icons.arrow_forward_outlined});
  final String title;
  final Function onPressed;
  final Color backgroundColor;
  final Color fontColor;
  final IconData icon;
  final double width;
  final double height;
  final double fontSize;
  final Color borderColor;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isBusy ? log("Is Busy") : onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 8.sp),
        height: height.sp,
        width: width.sp,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35.r),
            border: Border.all(color: borderColor, width: 1.sp),
            color: backgroundColor),
        child: Center(
          child: isBusy
              ? SizedBox(
                  height: 25.sp,
                  width: 25.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: fontColor,
                  ),
                )
              : customText(title,
                  fontSize: fontSize.sp,
                  color: fontColor,
                  fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {super.key,
      this.title = "",
      required this.onPressed,
      this.backgroundColor = AppColors.redColor,
      this.fontColor = AppColors.whiteColor,
      this.borderColor = Colors.transparent,
      this.iconBackgroundColor = Colors.white,
      this.iconColor = AppColors.redColor,
      this.width = 260,
      this.fontSize = 16,
      this.isBusy = false,
      this.icon = Icons.arrow_forward_outlined});
  final String title;
  final int fontSize;
  final Function onPressed;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color fontColor;
  final IconData icon;
  final double width;
  final Color borderColor;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isBusy ? log("Busy") : onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        height: 55.sp,
        width: width.sp,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.r),
            border: Border.all(color: borderColor, width: 1.sp),
            color: backgroundColor),
        child: isBusy
            ? Center(
                child: SizedBox(
                  height: 25.sp,
                  width: 25.sp,
                  child: const CircularProgressIndicator(
                    color: AppColors.whiteColor,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(6.sp),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: iconBackgroundColor,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  customText(title,
                      fontSize: fontSize.sp,
                      color: fontColor,
                      fontWeight: FontWeight.w500),
                ],
              ),
      ),
    );
  }
}

class CustomFlatButton extends StatelessWidget {
  const CustomFlatButton(
      {super.key,
      this.title = "",
      required this.onPressed,
      this.width = 235,
      this.height = 55,
      this.fontSize = 16,
      this.backgroundColor = AppColors.primaryColor,
      this.fontColor = AppColors.whiteColor,
      this.borderColor = Colors.transparent,
      this.isBusy = false,
      this.icon = Icons.arrow_forward_outlined});
  final String title;
  final Function onPressed;
  final double width;
  final double height;
  final double fontSize;
  final Color backgroundColor;
  final Color fontColor;
  final IconData icon;
  final Color borderColor;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.sp),
        height: height.sp,
        width: width.sp,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: borderColor, width: 1.sp),
            color: backgroundColor),
        child: isBusy
            ? Center(
                child: SizedBox(
                  height: 25.sp,
                  width: 25.sp,
                  child: CircularProgressIndicator(
                    color: fontColor,
                  ),
                ),
              )
            : Center(
                child: customText(title,
                    fontSize: fontSize.sp,
                    color: fontColor,
                    fontWeight: FontWeight.w700),
              ),
      ),
    );
  }
}

class CustomColouredTextButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Widget? child; // Make child nullable
  final Color bgColor;
  final bool isLoading;

  const CustomColouredTextButton(
      {super.key,
      required this.onPressed,
      this.title = "",
      this.child, // Make child optional without a default value
      this.bgColor = AppColors.primaryColor,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 8.sp),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: isLoading
            ? SizedBox(
                height: 15.sp,
                width: 15.sp,
                child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                  strokeWidth: 1.5.sp,
                ),
              )
            : child ??
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customText(
                        title,
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

class CustomGreenTextButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final Color bgColor;
  final bool isLoading;
  const CustomGreenTextButton(
      {super.key,
      required this.onPressed,
      required this.title,
      this.bgColor = AppColors.primaryColor,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 8.sp),
        margin: EdgeInsets.all(5.sp),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(40.r),
        ),
        child: Center(
            child: isLoading
                ? SizedBox(
                    height: 15.sp,
                    width: 15.sp,
                    child: CircularProgressIndicator(
                      color: AppColors.whiteColor,
                      strokeWidth: 1.5.sp,
                    ),
                  )
                : customText(
                    title,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 15.sp,
                  )),
      ),
    );
  }
}
