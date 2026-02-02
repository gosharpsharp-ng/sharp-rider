import 'package:gorider/core/utils/exports.dart';

Widget customText(String text,
    {Color? color,
    double fontSize = 14,
    double? letterSpacing,
    double? height,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextDecoration? decoration,
    FontWeight? fontWeight,
    String? fontFamily,
    bool blur = false}) {
  return Text(
    text,
    textAlign: textAlign,
    maxLines: maxLines,
    overflow: overflow,
    softWrap: true,
    style: fontFamily != null
        ? TextStyle(
            fontFamily: fontFamily,
            fontStyle: FontStyle.normal,
            color: color,
            letterSpacing: letterSpacing,
            fontSize: fontSize,
            height: height,
            fontWeight: fontWeight,
            decoration: decoration,
          )
        : TextStyle(
            fontFamily: 'Satoshi',
            fontStyle: FontStyle.normal,
            color: color,
            letterSpacing: letterSpacing,
            fontSize: fontSize,
            height: height,
            fontWeight: fontWeight,
            decoration: decoration,
          ),
  );
}
