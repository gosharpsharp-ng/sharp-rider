import 'dart:io';
import 'package:gorider/core/utils/exports.dart';
import 'package:dotted_border/dotted_border.dart';

class LicenseInfoStep extends GetView<SignUpController> {
  const LicenseInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (controller) {
        return Form(
          key: controller.step3FormKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText("License Information",
                            color: AppColors.blackColor,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w600),
                        SizedBox(height: 5.sp),
                        customText(
                            "Please provide your driver's license details",
                            color: AppColors.blackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal),
                        SizedBox(height: 5.sp),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.sp, vertical: 20.sp),
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.whiteColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomRoundedInputField(
                          title: "License Number",
                          label: "DL-123456789",
                          showLabel: true,
                          isRequired: true,
                          hasTitle: true,
                          controller: controller.licenseNumberController,
                        ),
                        ClickableCustomRoundedInputField(
                          title: "Issue Date",
                          label: controller.licenseIssuedDate != null
                              ? controller.licenseIssuedController.text
                              : "Select issue date",
                          showLabel: true,
                          hasTitle: true,
                          readOnly: true,
                          isRequired: true,
                          controller: controller.licenseIssuedController,
                          onPressed: () {
                            controller.selectLicenseIssuedDate(context);
                          },
                          suffixWidget: IconButton(
                            onPressed: () {
                              controller.selectLicenseIssuedDate(context);
                            },
                            icon: Icon(
                              Icons.calendar_today,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        ClickableCustomRoundedInputField(
                          title: "Expiry Date",
                          label: controller.licenseExpiryDate != null
                              ? controller.licenseExpiryController.text
                              : "Select expiry date",
                          showLabel: true,
                          hasTitle: true,
                          readOnly: true,
                          isRequired: true,
                          controller: controller.licenseExpiryController,
                          onPressed: () {
                            controller.selectLicenseExpiryDate(context);
                          },
                          suffixWidget: IconButton(
                            onPressed: () {
                              controller.selectLicenseExpiryDate(context);
                            },
                            icon: Icon(
                              Icons.calendar_today,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.sp),

                        // Optional License Images Section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: customText(
                            "License Photos (Optional)",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 10.sp),

                        // Front Image - Sharp-vendor pattern
                        _buildImagePicker(
                          context: context,
                          title: "Front Image",
                          image: controller.licenseFrontImage,
                          onTap: () {
                            showAnyBottomSheet(
                              isControlled: false,
                              child: CustomImagePickerBottomSheet(
                                title: "License Front Image",
                                takePhotoFunction: () =>
                                    controller.pickLicenseFrontImage(
                                        pickFromCamera: true),
                                selectFromGalleryFunction: () =>
                                    controller.pickLicenseFrontImage(
                                        pickFromCamera: false),
                                deleteFunction: () =>
                                    controller.removeLicenseFrontImage(),
                              ),
                            );
                          },
                          onRemove: () => controller.removeLicenseFrontImage(),
                        ),

                        SizedBox(height: 10.sp),

                        // Back Image - Sharp-vendor pattern
                        _buildImagePicker(
                          context: context,
                          title: "Back Image",
                          image: controller.licenseBackImage,
                          onTap: () {
                            showAnyBottomSheet(
                              isControlled: false,
                              child: CustomImagePickerBottomSheet(
                                title: "License Back Image",
                                takePhotoFunction: () =>
                                    controller.pickLicenseBackImage(
                                        pickFromCamera: true),
                                selectFromGalleryFunction: () =>
                                    controller.pickLicenseBackImage(
                                        pickFromCamera: false),
                                deleteFunction: () =>
                                    controller.removeLicenseBackImage(),
                              ),
                            );
                          },
                          onRemove: () => controller.removeLicenseBackImage(),
                        ),

                        SizedBox(height: 15.sp),
                        CustomButton(
                          onPressed: () {
                            if (controller.validateStep3()) {
                              controller.submitRegistration();
                            }
                          },
                          isBusy: controller.isLoading,
                          title: "Submit Registration",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImagePicker({
    required BuildContext context,
    required String title,
    required File? image,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          title,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.blackColor,
        ),
        SizedBox(height: 8.sp),
        DottedBorder(
          dashPattern: const [8, 4],
          strokeWidth: 1.5,
          color: AppColors.greyColor.withOpacity(0.5),
          borderType: BorderType.RRect,
          radius: Radius.circular(8.r),
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              height: 120.sp,
              decoration: BoxDecoration(
                color: image != null
                    ? Colors.transparent
                    : AppColors.textFieldBackgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: image == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.whiteColor,
                          ),
                          padding: EdgeInsets.all(8.sp),
                          child: Icon(
                            Icons.upload_outlined,
                            size: 24.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: 8.sp),
                        customText(
                          "Browse image to upload",
                          fontSize: 12.sp,
                          color: AppColors.blackColor,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.sp),
                        customText(
                          "(Max. file size: 25 MB)",
                          fontSize: 10.sp,
                          color: AppColors.greyColor,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(
                            image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 8.sp,
                          right: 8.sp,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.whiteColor,
                            ),
                            padding: EdgeInsets.all(8.sp),
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.sp,
                          right: 8.sp,
                          child: InkWell(
                            onTap: onRemove,
                            child: Container(
                              padding: EdgeInsets.all(4.sp),
                              decoration: const BoxDecoration(
                                color: AppColors.redColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: AppColors.whiteColor,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
