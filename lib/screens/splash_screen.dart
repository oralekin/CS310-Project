import 'package:flutter/material.dart';
// SCREENS
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
        context,
        LoginScreen.routeName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Spacer(),
            Text(
              "UniConnect",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Connecting University Clubs",
              style: TextStyle(color: Colors.grey),
            ),
            Spacer(),
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              "Loading...",
              style: TextStyle(color: Colors.grey),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
