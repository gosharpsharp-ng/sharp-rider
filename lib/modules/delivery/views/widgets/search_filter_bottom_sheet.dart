import 'package:gorider/core/utils/exports.dart';

class SearchFilterBottomSheet extends StatelessWidget {
  const SearchFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: AppColors.backgroundColor,
      height: 450.h,
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 15.sp),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            customText(
              "Filter",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              color: AppColors.blackColor,
              fontSize: 25.sp,
              fontWeight: FontWeight.w700,
            ),
            SectionBox(backgroundColor: AppColors.whiteColor, children: [
              ClickableCustomRoundedInputField(
                title: "Order Category",
                label: "Select",
                showLabel: true,
                hasTitle: true,
                readOnly: true,
                suffixWidget: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    SvgAssets.downChevronIcon,
                    // h: 20.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                // controller: signInProvider.emailController,
              ),
              ClickableCustomRoundedInputField(
                title: "City",
                label: "Select",
                showLabel: true,
                hasTitle: true,
                readOnly: true,
                suffixWidget: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    SvgAssets.downChevronIcon,
                    // h: 20.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                // controller: signInProvider.emailController,
              ),
              ClickableCustomRoundedInputField(
                title: "Ride type",
                label: "Select",
                showLabel: true,
                hasTitle: true,
                readOnly: true,
                suffixWidget: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    SvgAssets.downChevronIcon,
                    // h: 20.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                // controller: signInProvider.emailController,
              ),
              ClickableCustomRoundedInputField(
                title: "Ride status",
                label: "Select",
                showLabel: true,
                hasTitle: true,
                readOnly: true,
                suffixWidget: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    SvgAssets.downChevronIcon,
                    // h: 20.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
                // controller: signInProvider.emailController,
              ),
              SizedBox(
                height: 15.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        Get.back();
                      },
                      // isBusy: signInProvider.isLoading,
                      title: "Cancel",
                      height: 38.sp,
                      width: 1.sw,
                      backgroundColor: AppColors.fadedPrimaryColor,
                      fontColor: AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 8.sp,
                  ),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        Get.back();
                      },
                      height: 38.sp,
                      // isBusy: signInProvider.isLoading,
                      title: "Apply",
                      width: 1.sw,
                      backgroundColor: AppColors.primaryColor,
                      fontColor: AppColors.whiteColor,
                    ),
                  ),
                ],
              ),
            ]),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      ),
    );
  }
}
