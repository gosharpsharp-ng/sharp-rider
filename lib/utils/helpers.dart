import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:go_logistics_driver/utils/exports.dart';
import 'package:cloudinary/cloudinary.dart';

showAnyBottomSheet({required Widget child, bool isControlled = true}) {
  Get.bottomSheet(
    child,
    isScrollControlled: isControlled,
    backgroundColor: AppColors.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25.r),
        topRight: Radius.circular(25.r),
      ),
    ),
  );
}

class InvertedPlateClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0); // Start at the top-left corner
    path.quadraticBezierTo(size.width / 2, 100, size.width,
        0); // Create an outward bulge at the top
    path.lineTo(size.width, size.height); // Right side
    path.lineTo(0, size.height); // Bottom side
    path.close(); // Left side to complete the shape
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class DottedDivider extends StatelessWidget {
  final double dotSize;
  final double spacing;
  final Color color;
  final Axis axis;
  final double length;

  const DottedDivider({
    Key? key,
    this.dotSize = 8.0,
    this.spacing = 2.0,
    this.color = AppColors.primaryColor,
    this.axis = Axis.vertical, // Default to horizontal
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int dotCount = (length / (dotSize + spacing)).floor();

    return Container(
      height: axis == Axis.horizontal ? 2 : length + 2,
      width: axis == Axis.horizontal ? length : 2.sp,
      child: axis == Axis.horizontal
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dotCount,
                    itemBuilder: (context, index) {
                      return Container(
                        width: dotSize,
                        height: dotSize,
                        margin: EdgeInsets.symmetric(horizontal: spacing / 2),
                        decoration: BoxDecoration(
                          color: color,
                          // shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: dotCount,
                    itemBuilder: (context, index) {
                      return Container(
                        width: dotSize,
                        height: dotSize,
                        margin: EdgeInsets.symmetric(vertical: spacing / 2),
                        decoration: BoxDecoration(
                          color: color,
                          // shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

double stripCurrencyFormat(String formattedAmount) {
  if (formattedAmount.isEmpty) {
    return 1.0;
  }
  String cleanedString =
      formattedAmount.replaceAll('₦', '').replaceAll(RegExp(r'[^0-9.]'), '');

  return double.parse(cleanedString);
}

String formatTextFieldAmountToCurrency(String value) {
  // Remove any non-numeric characters except the decimal point
  String newValue = value.replaceAll(RegExp(r'[^0-9.]'), '');

  // Return empty if the input is empty or consists of zeros only
  if (newValue.isEmpty || newValue == '0') {
    return '';
  }

  // If the value has a decimal point, ensure it's parsed as a double
  double parsedValue = double.parse(newValue);

  // Format as currency in NGN locale
  String formattedValue = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '₦',
    decimalDigits: 2, // Use 2 decimal places for consistency
  ).format(parsedValue);

  return formattedValue;
}

detailHorizontalItem({required String title, required String detail}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5.sp),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(title, fontSize: 12.sp, color: AppColors.obscureTextColor),
        SizedBox(
          width: 3.sp,
        ),
        Expanded(
            child: customText(detail,
                fontSize: 12.sp,
                color: AppColors.obscureTextColor,
                overflow: TextOverflow.visible)),
      ],
    ),
  );
}

detailVerticalItem({required String title, required String detail}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 5.sp),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(title,
            fontSize: 16.sp,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w500),
        SizedBox(
          height: 2.sp,
        ),
        customText(
          detail,
          fontSize: 12.sp,
          color: AppColors.obscureTextColor,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.justify,
        ),
      ],
    ),
  );
}

detailHeader({required String header}) {
  return Container(
    margin: EdgeInsets.only(top: 12.sp, bottom: 8.sp),
    child: customText(header, fontSize: 14.sp, fontWeight: FontWeight.w500),
  );
}

class UserVerticalStatsItem extends StatelessWidget {
  final String metric;
  final String value;
  const UserVerticalStatsItem(
      {super.key, required this.metric, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          value,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(
          height: 5.sp,
        ),
        customText(
          metric,
          fontSize: 12.sp,
          fontWeight: FontWeight.normal,
          color: AppColors.obscureTextColor,
        ),
      ],
    );
  }
}

class EditIcon extends StatelessWidget {
  final Function onPressed;
  final bool isLoading;
  final String title;
  const EditIcon(
      {super.key,
      required this.onPressed,
      this.isLoading = false,
      this.title = "Edit"});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.transparent,
      onTap: () {
        isLoading ? null : onPressed();
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20.r)),
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
        margin: EdgeInsets.symmetric(vertical: 5.sp),
        child: isLoading
            ? SizedBox(
                height: 12.sp,
                width: 12.sp,
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                  strokeWidth: 1.0.sp,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  customText(title,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primaryColor),
                  SizedBox(
                    width: 8.sp,
                  ),
                  SvgPicture.asset(
                    SvgAssets.editIcon,
                    color: AppColors.primaryColor,
                    height: 14.sp,
                  ),
                ],
              ),
      ),
    );
  }
}

showToast({String message = "", bool isError = false}) {
  Get.snackbar(
    "",
    "",
    titleText: customText(isError ? "Error!" : "Success!",
        color: isError ? Colors.red : AppColors.primaryColor,
        fontWeight: FontWeight.w700,
        fontSize: 15.sp),
    messageText: customText(message,
        color: isError ? Colors.red : AppColors.primaryColor,
        overflow: TextOverflow.visible,
        fontSize: 12.sp),
    snackPosition: SnackPosition.TOP,
    backgroundColor: CupertinoColors.systemGrey5,
    colorText: isError ? Colors.red : AppColors.primaryColor,
    maxWidth: 1.sw * 0.7,
    icon: Container(
      // padding: EdgeInsets.only(left: 8.0.sp),
      margin: EdgeInsets.symmetric(horizontal: 5.0.sp),
      child: SvgPicture.asset(
          isError ? SvgAssets.errorIcon : SvgAssets.successIcon),
    ),
    borderRadius: 10.r,
    margin: EdgeInsets.only(left: 12.sp, top: 14.sp),
    duration: const Duration(seconds: 3),
  );
}

Future<CroppedFile> cropImage(XFile image) async {
  final croppedImageFile =
      await ImageCropper().cropImage(sourcePath: image.path, uiSettings: [
    AndroidUiSettings(
        toolbarColor: AppColors.primaryColor,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false),
    IOSUiSettings(title: "Crop Image")
  ]);
  return croppedImageFile!;
}

Future<String?> uploadImageToCloudinary({
  required File file,
  required String folderName,
}) async {
  const String cloudName = 'dnp0rvouv';
  const String apiKey = '347923482662651';
  const String apiSecret = '_Af_uRnU0SivpG59mPeak5I74oo';
  final cloudinary = Cloudinary.signedConfig(
    apiKey: apiKey,
    apiSecret: apiSecret,
    cloudName: cloudName,
  );
  try {
    final response = await cloudinary.upload(
        file: file.path,
        fileBytes: file.readAsBytesSync(),
        resourceType: CloudinaryResourceType.image,
        folder: folderName,
        progressCallback: (count, total) {
          print('Uploading image from file with progress: $count/$total');
        });
    if (response.isSuccessful) {
      return response.secureUrl;
    } else {
      return null;
    }
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}

String formatRideDate(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  return "${_getWeekday(dateTime.weekday)}, ${dateTime.day}${_getDaySuffix(dateTime.day)} ${_getMonth(dateTime.month)}, ${dateTime.year}";
}

String _getWeekday(int weekday) {
  const weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  return weekdays[weekday - 1];
}

String _getDaySuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}

String _getMonth(int month) {
  const months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return months[month - 1];
}

String formatRideTime(String timestamp) {
  DateTime dateTime = DateTime.parse(timestamp);
  int hour = dateTime.hour;
  int minute = dateTime.minute;

  String period = hour >= 12 ? "PM" : "AM";
  hour = hour % 12;
  if (hour == 0) hour = 12;

  String minuteStr = minute.toString().padLeft(2, '0');
  return "$hour:$minuteStr $period";
}

String formatToCurrency(num number) {
  NumberFormat format = NumberFormat.currency(locale: 'en_US', symbol: '₦');
  return format.format(number);
}

formatNumber(dynamic value, {String locale = 'en_NG'}) {
  final cFormat = NumberFormat("#,##0", locale);
  if (value == null) return '₦${cFormat.format('0')}';
  return cFormat.format(value);
}

String computeAgeRange(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return '';
  }

  try {
    // Parse the date string
    final birthDate = DateTime.parse(dateString);
    final now = DateTime.now();

    // Calculate the age in years
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    // Determine the age range
    if (age < 18) {
      return 'Under 18';
    } else if (age < 30) {
      return '18-29';
    } else if (age < 40) {
      return '30-39';
    } else if (age < 50) {
      return '40-49';
    } else {
      return '50 and above';
    }
  } catch (e) {
    // Handle invalid date format
    return '';
  }
}

class PartialViewHeader extends StatelessWidget {
  final String title;
  final Function onPressed;
  const PartialViewHeader(
      {super.key, required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      child: Row(
        children: [
          Expanded(
              child: customText(title,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  color: AppColors.blackColor)),
          InkWell(
            onTap: () {
              onPressed();
            },
            child: Row(
              children: [
                customText("View all",
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    color: AppColors.primaryColor),
                SizedBox(
                  width: 5.sp,
                ),
                SvgPicture.asset(
                  SvgAssets.rightChevronIcon,
                  color: AppColors.primaryColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          customText(title,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp,
              color: AppColors.blackColor),
        ],
      ),
    );
  }
}

class TitleSectionBox extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget> children;
  const TitleSectionBox(
      {super.key,
      required this.title,
      required this.children,
      this.backgroundColor = AppColors.whiteColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
      margin: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
      width: 1.sw,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r), color: backgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(title,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.visible,
              fontSize: 16.sp,
              color: AppColors.blackColor),
          SizedBox(
            height: 5.h,
          ),
          ...children
        ],
      ),
    );
  }
}

class SectionBox extends StatelessWidget {
  final Color backgroundColor;
  CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;
  SectionBox(
      {super.key,
      required this.children,
      this.backgroundColor = AppColors.whiteColor,
      this.crossAxisAlignment = CrossAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
      margin: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
      width: 1.sw,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r), color: backgroundColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment,
        children: [...children],
      ),
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.obscureTextColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 3.0;
    const double dashSpace = 3.0;
    double startX = 0;
    final path = Path();

    while (startX < size.width) {
      path.moveTo(startX, 0); // Top border
      path.lineTo(startX + dashWidth, 0);
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    while (startX < size.height) {
      path.moveTo(0, startX); // Left border
      path.lineTo(0, startX + dashWidth);
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    while (startX < size.width) {
      path.moveTo(startX, size.height); // Bottom border
      path.lineTo(startX + dashWidth, size.height);
      startX += dashWidth + dashSpace;
    }

    startX = 0;
    while (startX < size.height) {
      path.moveTo(size.width, startX); // Right border
      path.lineTo(size.width, startX + dashWidth);
      startX += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

String capitalizeText(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

bool validateEmail(String email) {
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}

bool validatePhoneNumber(String phoneNumber) {
  String pattern =
      r'^[1-9]\d{9}$'; // Starts with a digit 1-9 followed by exactly 9 digits
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(phoneNumber);
}

String getFormattedResendOTPTime(int remainingTime) {
  int minutes = remainingTime ~/ 60;
  int seconds = remainingTime % 60;

  if (remainingTime >= 60) {
    if (seconds == 0) {
      return '$minutes m';
    } else {
      return '$minutes m $seconds s';
    }
  } else {
    return '$seconds s';
  }
}

String formatDate(String inputDate) {
  try {
    // Parse the input date string to a DateTime object
    DateTime parsedDate = DateTime.parse(inputDate);

    // Format the date to the desired format
    String formattedDate = DateFormat('EEE d MMMM, yyyy').format(parsedDate);

    return formattedDate;
  } catch (e) {
    // Handle any parsing or formatting errors
    return 'Invalid date';
  }
}

String formatTime(String inputDate) {
  try {
    // Parse the input date string to a DateTime object
    DateTime parsedDate = DateTime.parse(inputDate);

    // Format the time to 12-hour format
    return DateFormat('hh:mm a').format(parsedDate);
  } catch (e) {
    // Handle any parsing or formatting errors
    return 'Invalid time';
  }
}
