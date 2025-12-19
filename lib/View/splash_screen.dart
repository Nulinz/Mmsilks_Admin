import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mm_textiles_admin/View/Screen/DashboardScreen.dart';
import '../Backendservice/connectionService.dart';
import '../Components/UpdatePopup.dart';
import '../Components/errorscreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    appupdate();
  }

  void appupdate() async {
    print("check app update function called");
    try {
      final response = await http.post(
        Uri.parse(ConnectionService.update_popup),
        body: {},
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData['version']);
        if (jsonData['version'] != '0.0.1') {
          print("version not updated");
          Get.offAll(() => const Updatepopup());
        } else {
          print("version updated");
          goToDashboard();
        }
      } else {
        print('${response.statusCode}');
        Get.offAll(() =>
            ErrorScreen(errorMessage: 'Server error: ${response.statusCode}'));
      }
    } catch (e) {
      print(e);
      Get.offAll(() => ErrorScreen(errorMessage: 'An error occurred: $e'));
    }
  }

  void goToDashboard() async {
    Get.offAll(() => const DashboardScreen());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
