import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mm_textiles_admin/Controller/Internet_Controller/dependency_injector.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';
import 'package:mm_textiles_admin/View/splash_screen.dart';
import 'Theme/appTheme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = true;
  DependencyInjection.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const mm_textiles_admin());
}

class mm_textiles_admin extends StatefulWidget {
  const mm_textiles_admin({super.key});

  @override
  State<mm_textiles_admin> createState() => _mm_textiles_adminState();
}

class _mm_textiles_adminState extends State<mm_textiles_admin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(context),
          home: AnimatedSplashScreen(
            backgroundColor: whiteColor,
            splash: Image.asset("assets/Images/Splash-logo.png"),
            splashIconSize: 250,
            nextScreen: const SplashScreen(),
            splashTransition: SplashTransition.fadeTransition,
            animationDuration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}
