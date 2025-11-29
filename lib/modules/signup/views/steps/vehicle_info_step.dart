import 'dart:io';
import 'package:gorider/core/utils/exports.dart';
import 'package:dotted_border/dotted_border.dart';

class VehicleInfoStep extends GetView<SignUpController> {
  const VehicleInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (controller) {
        return Form(
          key: controller.step2FormKey,
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
                        customText("Vehicle Information",
                            color: AppColors.blackColor,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w600),
                        SizedBox(height: 5.sp),
                        customText("Please provide your vehicle details",
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
                        ClickableCustomRoundedInputField(
                          title: "Courier Type",
                          label: controller.selectedCourierType?.name ??
                              "Select courier type",
                          showLabel: true,
                          hasTitle: true,
                          readOnly: true,
                          isRequired: true,
                          useCustomValidator: true,
                          controller: TextEditingController(
                              text: controller.selectedCourierType?.name ?? ""),
                          onPressed: () {
                            _showCourierTypeBottomSheet(context, controller);
                          },
                          suffixWidget: IconButton(
                            onPressed: () {
                              _showCourierTypeBottomSheet(context, controller);
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (controller.selectedCourierType == null) {
                              return 'Please select a courier type';
                            }
                            return null;
                          },
                        ),
                        CustomRoundedInputField(
                          title: "Brand",
                          label: "Toyota",
                          showLabel: true,
                          isRequired: true,
                          hasTitle: true,
                          controller: controller.vehicleBrandController,
                        ),
                        CustomRoundedInputField(
                          title: "Model",
                          label: "Corolla",
                          showLabel: true,
                          isRequired: true,
                          hasTitle: true,
                          controller: controller.vehicleModelController,
                        ),
                        CustomRoundedInputField(
                          title: "Year",
                          label: "2020",
                          showLabel: true,
                          isRequired: true,
                          hasTitle: true,
                          keyboardType: TextInputType.number,
                          useCustomValidator: true,
                          controller: controller.vehicleYearController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Year is required';
                            }
                            final year = int.tryParse(value);
                            if (year == null) {
                              return 'Please enter a valid year';
                            }
                            if (year < 1900 || year > DateTime.now().year + 1) {
                              return 'Please enter a valid year';
                            }
                            return null;
                          },
                        ),
                        CustomRoundedInputField(
                          title: "Registration Number",
                          label: "ABC-1234",
                          showLabel: true,
                          isRequired: true,
                          hasTitle: true,
                          controller: controller.vehicleRegNumController,
                        ),
                        SizedBox(height: 10.sp),

                        // Optional Images Section
                        Align(
                          alignment: Alignment.centerLeft,
                          child: customText(
                            "Vehicle Photos (Optional)",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackColor,
                          ),
                        ),
                        SizedBox(height: 10.sp),

                        // Interior Photo - Sharp-vendor pattern
                        _buildImagePicker(
                          context: context,
                          title: "Interior Photo",
                          image: controller.vehicleInteriorPhoto,
                          onTap: () {
                            showAnyBottomSheet(
                              isControlled: false,
                              child: CustomImagePickerBottomSheet(
                                title: "Interior Photo",
                                takePhotoFunction: () =>
                                    controller.pickVehicleInteriorPhoto(
                                        pickFromCamera: true),
                                selectFromGalleryFunction: () =>
                                    controller.pickVehicleInteriorPhoto(
                                        pickFromCamera: false),
                                deleteFunction: () =>
                                    controller.removeVehicleInteriorPhoto(),
                              ),
                            );
                          },
                          onRemove: () =>
                              controller.removeVehicleInteriorPhoto(),
                        ),

                        SizedBox(height: 10.sp),

                        // Exterior Photo - Sharp-vendor pattern
                        _buildImagePicker(
                          context: context,
                          title: "Exterior Photo",
                          image: controller.vehicleExteriorPhoto,
                          onTap: () {
                            showAnyBottomSheet(
                              isControlled: false,
                              child: CustomImagePickerBottomSheet(
                                title: "Exterior Photo",
                                takePhotoFunction: () =>
                                    controller.pickVehicleExteriorPhoto(
                                        pickFromCamera: true),
                                selectFromGalleryFunction: () =>
                                    controller.pickVehicleExteriorPhoto(
                                        pickFromCamera: false),
                                deleteFunction: () =>
                                    controller.removeVehicleExteriorPhoto(),
                              ),
                            );
                          },
                          onRemove: () =>
                              controller.removeVehicleExteriorPhoto(),
                        ),

                        SizedBox(height: 15.sp),
                        CustomButton(
                          onPressed: () {
                            if (controller.validateStep2()) {
                              controller.nextStep();
                            }
                          },
                          isBusy: controller.isLoading,
                          title: "Next",
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
                          decoration: const BoxDecoration(
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
                            decoration: const BoxDecoration(
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

  void _showCourierTypeBottomSheet(
      BuildContext context, SignUpController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return GetBuilder<SignUpController>(
          builder: (controller) {
            if (controller.isLoadingCourierTypes) {
              return SizedBox(
                height: 300.sp,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                ),
              );
            }

            return Container(
              padding: EdgeInsets.all(20.sp),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(
                    "Select Courier Type",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                  SizedBox(height: 20.sp),
                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.courierTypes.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final courierType = controller.courierTypes[index];
                        final isSelected = controller.selectedCourierType?.id ==
                            courierType.id;
                        return ListTile(
                          onTap: () {
                            controller.setSelectedCourierType(courierType);
                            Navigator.pop(context);
                          },
                          title: customText(
                            courierType.name,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.blackColor,
                          ),
                          subtitle: customText(
                            courierType.description,
                            fontSize: 12.sp,
                            color: AppColors.obscureTextColor,
                          ),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primaryColor,
                                )
                              : null,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
