import 'package:flutter/cupertino.dart';
import 'package:rakt_pravah/presentation/pages/auth/otp_screen.dart';
import 'package:rakt_pravah/presentation/pages/auth/registor_details.dart';
import 'package:rakt_pravah/presentation/pages/auth/sign_in_screen.dart';
import 'package:rakt_pravah/presentation/pages/home/home_page.dart';
import 'package:rakt_pravah/presentation/pages/other/about_us.dart';
import 'package:rakt_pravah/presentation/pages/other/privacy_prolicy.dart';
import 'package:rakt_pravah/presentation/pages/other/terms_conditions.dart';
import 'package:rakt_pravah/presentation/pages/splash_screen.dart';

class Routes {
  static Route? onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return CupertinoPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case SignInScreen.routeName:
        return CupertinoPageRoute(
          builder: (context) => const SignInScreen(),
        );

      case OtpScreen.routeName:
        return CupertinoPageRoute(
          builder: (context) =>
              OtpScreen(phoneNumber: settings.arguments as String),
        );

      case RegistorDetails.routeName:
        return CupertinoPageRoute(
          builder: (context) =>
              RegistorDetails(phoneNumber: settings.arguments as String),
        );

      case TermsConditions.routeName:
        return CupertinoPageRoute(
          builder: (context) => const TermsConditions(),
        );

      case PrivacyPolicy.routeName:
        return CupertinoPageRoute(
          builder: (context) => const PrivacyPolicy(),
        );

      case AboutUs.routeName:
        return CupertinoPageRoute(
          builder: (context) => const AboutUs(),
        );

      case HomePage.routeName:
        return CupertinoPageRoute(
          builder: (context) => const HomePage(),
        );

      default:
        return null;
    }
  }
}
