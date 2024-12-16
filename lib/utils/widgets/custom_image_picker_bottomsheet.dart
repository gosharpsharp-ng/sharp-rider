import 'package:go_logistics_driver/utils/exports.dart';


class CustomImagePickerBottomSheet extends StatelessWidget {
  final Function takePhotoFunction;
  final Function selectFromGalleryFunction;
  final Function deleteFunction;
  final String title;

  const CustomImagePickerBottomSheet({
    super.key,
    required this.title,
    required this.takePhotoFunction,
    required this.selectFromGalleryFunction,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0.r),
        topRight: Radius.circular(15.0.r),
      ),
      child: Container(
        height: 200.sp,
        width: 1.sw,
        decoration: const BoxDecoration(color: AppColors.whiteColor),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 13.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.whiteColor),
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                splashColor: AppColors.transparent,
                child: Icon(
                  Icons.clear,
                  color: AppColors.redColor,
                  size: 30.sp,
                ),
              ),
            ),
            InkWell(
              splashColor: AppColors.transparent,
              onTap: () async {
                await takePhotoFunction();
                Get.back();
              },
              child: Text(
                'Take Photo',
                style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp,
                    color: AppColors.primaryColor),
              ),
            ),
            InkWell(
                splashColor: AppColors.transparent,
                onTap: () async {
                  await selectFromGalleryFunction();
                  Get.back();
                },
                child: Text(
                  'Select from Gallery',
                  style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: AppColors.primaryColor),
                )),
            InkWell(
                splashColor: AppColors.transparent,
                onTap: () async {
                  await deleteFunction();
                  Get.back();
                },
                child: Text(
                  'Delete image',
                  style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 16.sp,
                      color: Colors.red),
                )),
          ],
        ),
      ),
    );
  }
}
