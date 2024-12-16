
import 'package:go_logistics_driver/utils/exports.dart';

class OrderPackageInformationUploadScreen extends StatelessWidget {
  const OrderPackageInformationUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
        builder: (ordersController){
        return Form(
          child: Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              title: "Package information"
            ),
            backgroundColor: AppColors.backgroundColor,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 12.sp),
              height: 1.sh,
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
                      margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: AppColors.whiteColor),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          customText("Package Information",
                              color: AppColors.blackColor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),
                          SizedBox(
                            height: 8.h,
                          ),
                          CustomPaint(
                            painter: DottedBorderPainter(),
                            child: Container(
                              width: 1.sw,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.sp, vertical: 20.h),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.backgroundColor),
                                    padding: EdgeInsets.all(8.sp),
                                    child: SvgPicture.asset(SvgAssets.cameraIcon),
                                  ),
                                  customText("Click here to upload an image",
                                      color: AppColors.primaryColor,
                                      fontSize: 14.sp,
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.w500),
                                  customText(
                                      "Supported format (PNG, JPG)",
                                      color: AppColors.blackColor,
                                      fontSize: 14.sp,
                                      overflow: TextOverflow.visible,
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.normal),
                                  customText("(max 4mb)",
                                      color: AppColors.blackColor,
                                      fontSize: 14.sp,
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeight.normal),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),

                          ClickableCustomRoundedInputField(
                            title: "Category",
                            label: "Food",
                            readOnly: true,
                            showLabel: true,
                            hasTitle: true,
                            suffixWidget: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                SvgAssets.downChevronIcon,
                                // h: 20.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            // controller: signInProvider.emailController,
                          ),CustomRoundedInputField(
                            title: "Label",
                            label: "Label",
                            readOnly: true,
                            showLabel: true,
                            hasTitle: true,
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
                            height: 15.sp,
                          ),

                          CustomButton(
                            onPressed: () {

                            },
                            // isBusy: signInProvider.isLoading,
                            title: "Upload and start shipping",
                            width: 1.sw,
                            backgroundColor: AppColors.primaryColor,
                            fontColor: AppColors.whiteColor,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
