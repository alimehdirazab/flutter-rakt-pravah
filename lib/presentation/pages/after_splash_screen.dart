import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rakt_pravah/presentation/pages/auth/sign_in_screen.dart';

class AfterSplashScreen extends StatefulWidget {
  const AfterSplashScreen({super.key});
  static const String routeName = "afterSplashScreen";

  @override
  State<AfterSplashScreen> createState() => _AfterSplashScreenState();
}

class _AfterSplashScreenState extends State<AfterSplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateOnNextScreen();
  }

  Future<void> _navigateOnNextScreen() async {
    await Future.delayed(const Duration(seconds: 20));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    Navigator.pushReplacementNamed(context, SignInScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Image.asset('assets/images/vidyaBhartiLogo.png'),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Image.asset('assets/images/rakt_pravah_logo.png'),
                  ),
                ],
              ),
              const Divider(),
              const Text(
                  "विद्याा भारती पूर्व छात्र परिषद द्वारा निर्मित व संचालित \" रक्त प्रवाह \" मोबाइल ऐप रक्तदाता व रक्त अनुरोधकर्ता के मध्य सेतु का कार्य करती हैं | रक्त प्रवाह का उद्देश्य्य देशभर में जीवन रक्षा हेतु रक्त उपलब्ध कराना हैं |"),
            ],
          ),
        ),
      ),
    );
  }
}
