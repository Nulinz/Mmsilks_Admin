import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../Theme/Colors.dart';

TitleText(String text) {
  return Text(
    text,
    style: TextStyle(
        color: whiteColor,
        fontSize: Get.width / 20,
        fontWeight: FontWeight.w800),
  );
}

CustomSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    colorText: blackColor,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.grey,
    backgroundGradient: const LinearGradient(
      colors: [kPrimaryColor, Color.fromARGB(255, 248, 234, 109)],
    ),
  );
}

CustomErrorSnackbar() {
  Get.snackbar(
    "Oops! try again",
    "An error occurred while processing your request.",
    colorText: blackColor,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.grey,
    backgroundGradient: const LinearGradient(
      colors: [kPrimaryColor, Color.fromARGB(255, 248, 234, 109)],
    ),
  );
}

Fluttertoastbar(String Message) {
  return Fluttertoast.showToast(
      backgroundColor: Colors.grey.shade800.withOpacity(0.7),
      msg: Message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 12.0);
}
