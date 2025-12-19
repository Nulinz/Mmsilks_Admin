import 'package:flutter/material.dart';
import 'package:mm_textiles_admin/Theme/Colors.dart';

class LoadingProgress extends StatefulWidget {
  const LoadingProgress({super.key});

  @override
  State<LoadingProgress> createState() => _LoadingProgressState();
}

class _LoadingProgressState extends State<LoadingProgress> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: ShapeDecoration(
            color: whiteColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/Images/Splash-logo.png', // Your logo/image
                width: 40,
                height: 50,
              ),
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  backgroundColor: lightGreyColor,
                  strokeWidth: 3,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
