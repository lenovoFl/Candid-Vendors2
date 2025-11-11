import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ShowLoadingScreen extends StatelessWidget {
  const ShowLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.h,
              width: 50.w,
              child: Image.asset(
                'lib/Images/candid.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.h), // Adjust the spacing as needed
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}