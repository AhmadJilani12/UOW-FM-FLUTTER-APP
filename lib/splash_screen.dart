import 'package:flutter/material.dart';

import 'main.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RadioApp()), // Replace with your main screen
      );
    });
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color of the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center images vertically
          children: [
            Image.asset(
              'assets/images/uow_logo.png',
              width: 350, // Adjust the size of the first logo as needed
              height: 150,
            ),
            SizedBox(height: 20), // Add some space between the two images
            Image.asset(
              'assets/images/live_radio_logo.png',
              width: 350, // Adjust the size of the second logo as needed
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
