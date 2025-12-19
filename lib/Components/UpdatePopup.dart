import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Theme/Colors.dart';

class Updatepopup extends StatefulWidget {
  const Updatepopup({super.key});

  @override
  State<Updatepopup> createState() => _UpdatepopupState();
}

const String _heroAddTodo = 'add-todo-hero';

class _UpdatepopupState extends State<Updatepopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Hero(
                tag: _heroAddTodo,
                child: Material(
                  color: const Color.fromRGBO(249, 248, 246, 1),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Image.asset(
                              "assets/Images/Splash-logo.png",
                              scale: 1.3,
                            ),
                          )),
                      Container(
                        width: Get.width / 1.200,
                        height: Get.height / 5,
                        decoration: const ShapeDecoration(
                            color: Color.fromRGBO(249, 248, 246, 1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30)))),
                        child: Column(
                          children: [
                            SizedBox(height: Get.height / 80),
                            Text(
                              "We're getting better!",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black87,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Update the app to unlock new features",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: greyColor,
                                  letterSpacing: .5,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 28,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: Get.height / 40),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width / 1.5,
                              child: TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          kPrimaryColor),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                                ),
                                onPressed: () {
                                  if (Platform.isAndroid) {
                                    launchUrl(
                                      Uri.parse(
                                          "https://play.google.com/store/apps/details?id=com.mmtextiles.admin.app"),
                                      mode: LaunchMode.platformDefault,
                                    );
                                  }
                                },
                                child: const Text(
                                  'UPDATE NOW!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: .8,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
