import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Theme/Colors.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(List<ConnectivityResult> connectivityResults) {
    // Check if any of the results indicate no connectivity
    bool hasNoConnectivity =
        connectivityResults.contains(ConnectivityResult.none);

    if (hasNoConnectivity) {
      showDialog(
        context: Get.overlayContext!,
        barrierDismissible: true, // prevent user from dismissing alert dialog
        builder: (context) => AlertDialog(
          backgroundColor: whiteColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.wifi_off,
                color: Colors.black,
                size: 35,
              ),
              const SizedBox(height: 20),
              Text(
                "Network Not Found !",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.black87,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.width / 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                "Please Check your internet Connection",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: kPrimaryColor,
                    letterSpacing: .5,
                    fontSize: MediaQuery.of(context).size.width / 34,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: MediaQuery.sizeOf(context).height / 4,
                width: MediaQuery.sizeOf(context).width / 1.06,
                child: const Image(
                  image: AssetImage("assets/Images/No-Connection.png"),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width / 4,
                child: TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        WidgetStateProperty.all<Color>(kPrimaryColor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      Get.rawSnackbar(
          showProgressIndicator: true,
          messageText: const Text(
            'PLEASE CONNECT TO THE NETWORK',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          progressIndicatorValueColor:
              AlwaysStoppedAnimation(Colors.grey.shade600),
          isDismissible: true,
          duration: const Duration(days: 1),
          backgroundColor: kPrimaryColor,
          icon: const Icon(Icons.wifi_off, color: Colors.white, size: 35),
          margin: EdgeInsets.zero,
          snackPosition: SnackPosition.BOTTOM,
          snackStyle: SnackStyle.FLOATING,
          progressIndicatorBackgroundColor: Colors.white);
    } else {
      if (Get.isDialogOpen!) {
        Get.back(); // Close any open dialogs
      }
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
    }
  }
}
