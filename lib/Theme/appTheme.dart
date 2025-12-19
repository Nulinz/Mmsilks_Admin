import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/Theme/Fonts.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: primaryMaterialColor,
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: whiteColor,
      canvasColor: whiteColor,
      iconTheme: const IconThemeData(color: blackColor),
      textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryMaterialColor,
        selectionColor: primaryMaterialColor[100],
        selectionHandleColor: primaryMaterialColor,
      ),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        circularTrackColor: whiteColor,
        color: kPrimaryColor,
      ),
      checkboxTheme: _checkboxThemeData,
      appBarTheme: _appBarTheme,
    );
  }

  // ✅ AppBar Theme
  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: blackColor),
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: blackColor,
    ),
  );

  // ✅ Checkbox Theme
  static final CheckboxThemeData _checkboxThemeData = CheckboxThemeData(
    checkColor: WidgetStatePropertyAll(Colors.white),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
    side: const BorderSide(color: whiteColor40),
    splashRadius: 10,
    visualDensity: VisualDensity.compact,
  );

  // ✅ Elevated Button Theme
  static ElevatedButtonThemeData _elevatedButtonTheme(
      {Color backgroundColor = kPrimaryColor}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        backgroundColor: backgroundColor,
        foregroundColor: whiteColor,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.subHeading,
      ),
    );
  }

  // ✅ Outlined Button Theme
  static OutlinedButtonThemeData _outlinedButtonTheme(
      {Color borderColor = kPrimaryColor}) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        foregroundColor: textcolor,
        minimumSize: const Size(double.infinity, 48),
        side: BorderSide(width: 1.5, color: borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.label,
      ),
    );
  }

  // ✅ Text Button Theme
  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: kPrimaryColor,
      textStyle: AppTextStyles.label,
    ),
  );

  // // ✅  Button Loading

  // static Widget buttonLoading({Color color = kPrimaryColor, double size = 20}) {
  //   return SizedBox(
  //     height: size,
  //     child: Center(
  //       child: SpinKitThreeBounce(
  //         color: color,
  //         size: size,
  //       ),
  //     ),
  //   );
  // }

  // ✅ Borders
  static OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: greyColor, width: 1.2),
    borderRadius: BorderRadius.circular(8),
  );

  static OutlineInputBorder focusedBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: kPrimaryColor, width: 2),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static OutlineInputBorder errorBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static OutlineInputBorder focusedErrorBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2),
    borderRadius: BorderRadius.all(Radius.circular(8)),
  );

  static OutlineInputBorder searchEnabledBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    borderRadius: BorderRadius.circular(8),
  );

  // // ✅ OTP Box Theme
  // static PinTheme defaultpintheme = PinTheme(
  //     width: Get.width / 8,
  //     height: Get.width / 8,
  //     margin: const EdgeInsets.symmetric(horizontal: 10),
  //     padding: const EdgeInsets.symmetric(horizontal: 10),
  //     textStyle: TextStyle(
  //       fontSize: 25.r,
  //       fontWeight: FontWeight.w600,
  //       color: blackColor,
  //     ),
  //     decoration: BoxDecoration(
  //         color: whiteColor,
  //         borderRadius: BorderRadius.circular(15),
  //         border: Border.all(width: 1, color: kStock)));

  // ✅ Reusable Button
  static Widget buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.r),
      child: SizedBox(
        height: 50.r,
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: AppTextStyles.subHeading.copyWith(
              color: whiteColor,
              fontSize: 17.r,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  // ✅ AppBar Variants
  static AppBar loginAppBar() {
    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: backgroundColor,
    );
  }

  static AppBar iconAppBar({
    Widget? title,
    bool centerTitle = false,
    List<Widget>? actions,
  }) {
    return AppBar(
      title: title,
      centerTitle: centerTitle,
      backgroundColor: whiteColor,
      surfaceTintColor: backgroundColor,
      leading: _backIcon(),
      actions: actions,
      titleTextStyle: AppTextStyles.subHeading.copyWith(
        fontSize: Get.width / 22,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static AppBar iconAppBarBackgroundless({
    Widget? title,
    bool centerTitle = false,
    bool implyLeading = true,
    List<Widget>? actions,
    VoidCallback? onPressed,
    Color widgetColor = const Color.fromRGBO(74, 85, 104, 1),
    Color appBackgroundColor = Colors.transparent,
  }) {
    return AppBar(
      automaticallyImplyLeading: implyLeading,
      title: title,
      centerTitle: centerTitle,
      backgroundColor: appBackgroundColor,
      surfaceTintColor: appBackgroundColor,
      titleTextStyle: AppTextStyles.title.copyWith(
        color: widgetColor,
        fontSize: 18.r,
        letterSpacing: .6,
        fontWeight: FontWeight.w700,
      ),
      leading: implyLeading
          ? InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onPressed ?? () => Get.back(),
              child: Image.asset(
                "assets/Icons/backarrow.png",
                scale: 3,
                color: widgetColor,
              ),
            )
          : null,
      actions: actions,
    );
  }

  static Widget labelTitle(String text) {
    return Text(
      text,
      style: AppTextStyles.title.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: Get.width / 28,
        letterSpacing: 0.5,
        color: blackColor,
      ),
    );
  }

  static Widget defaultProfileAvatar() {
    return Image.asset(
      "assets/Icons/ProfileAvatar.jpg",
      fit: BoxFit.cover,
    );
  }

  static Widget defaultCategoryAvatar() {
    return Image.asset(
      // width: 50.r,
      // height: 50.r,
      "assets/Icons/Category_PlaceHolder.png",
      fit: BoxFit.cover,
    );
  }

  static Widget _backIcon() {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => Get.back(),
      child: Image.asset(
        "assets/Icons/backarrow.png",
        scale: 3,
      ),
    );
  }
}
