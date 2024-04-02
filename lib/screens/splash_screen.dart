import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/app_icon.png',
          width: 100,
          height: 100,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Simple Calendar",
          style: TextStyle(
              color: Get.isDarkMode ? Colors.white : Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
