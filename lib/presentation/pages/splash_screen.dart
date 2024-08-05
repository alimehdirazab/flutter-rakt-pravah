import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rakt_pravah/presentation/pages/after_splash_screen.dart';
import 'package:rakt_pravah/presentation/pages/auth/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = "splashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateOnNextScreen();
  }

  Future<void> _navigateOnNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    Navigator.pushReplacementNamed(context, AfterSplashScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Top background image
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/background_top.png',
                fit: BoxFit.cover,
              ),
            ),
            // Bottom background image
            Positioned(
              bottom: -10,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/background_bottom.png',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  //height: MediaQuery.of(context).size.height * 0.6,
                  child: Image.asset('assets/images/rakt_pravah_logo.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
