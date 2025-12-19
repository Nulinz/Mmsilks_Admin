import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';

class AppTextStyles {
  // ✅ Getters instead of static fields to avoid AOT optimization issues
  static TextStyle get heading =>
      _poppinsStyle(20.sp, FontWeight.bold, PrimaryBlackColor);

  static TextStyle get subHeading =>
      _poppinsStyle(18.sp, FontWeight.w600, PrimaryBlackColor);

  static TextStyle get title =>
      _poppinsStyle(16.sp, FontWeight.w500, textcolor);

  static TextStyle get label =>
      _poppinsStyle(14.sp, FontWeight.normal, textcolor);

  static TextStyle get subLabel =>
      _poppinsStyle(13.sp, FontWeight.normal, Colors.grey);

  static TextStyle get small =>
      _poppinsStyle(12.sp, FontWeight.normal, Colors.grey);

  static TextStyle get error =>
      _poppinsStyle(14.sp, FontWeight.bold, Colors.red);

  static TextStyle get success =>
      _poppinsStyle(14.sp, FontWeight.bold, Colors.green);

  // ✅ poppins base style builder
  static TextStyle _poppinsStyle(double size, FontWeight weight, Color color) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: 1.4,
    );
  }

  // ✅ Fully custom usage
  static TextStyle custom({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    Color color = Colors.black,
    double height = 1.4,
    TextDecoration decoration = TextDecoration.none,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      height: height,
      decoration: decoration,
      letterSpacing: letterSpacing,
    );
  }
}

// ✅ Extensions for quick chaining
extension TextStyleModifiers on TextStyle {
  TextStyle withColor(Color customColor) => copyWith(color: customColor);
  TextStyle withSize(double customSize) => copyWith(fontSize: customSize.sp);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get strikeThrough =>
      copyWith(decoration: TextDecoration.lineThrough);
}
