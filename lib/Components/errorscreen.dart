import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;

  const ErrorScreen({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Error'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.transparent,
              height: Get.height / 3,
              width: Get.width / 1,
              child: const Image(
                image: AssetImage("assets/Images/404_error.png"),
              ),
            ),
            Text(
              "Dear User !\nSomething Went wrong\n Kindly Try After Sometime!",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Colors
                      .black, // Changed to Colors.black for color reference
                  letterSpacing: .5,
                  fontSize: Get.width / 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
