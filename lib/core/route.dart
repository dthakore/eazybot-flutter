import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../presentation/FebTabs.dart';
import '../presentation/authontication/otp_verify.dart';
import '../presentation/authontication/signin_screen.dart';
import '../presentation/bots/bot_list_screen.dart';
import '../presentation/insights/bot_insight_screen.dart';
import '../presentation/splashscreen/splash_screen.dart';

class RouteGenerator {
  static const String signInScreen = "/signInScreen";
  static const String otpVerify = "/otpVerify";
  static const String botListScreen = "/botListScreen";
  static const String fabTab = "/fabTab";
  static const String splashScreen = "/splashScreen";
  static const String botInsightScreen = "/botInsightScreen";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signInScreen:
        //var arg = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case otpVerify:
        return MaterialPageRoute(builder: (_) => OTPVerify());
      case botListScreen:
        return MaterialPageRoute(builder: (_) => BotListScreen());
      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case botInsightScreen:
        final botId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => BotInsightScreen(botId: botId),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(backgroundColor: Colors.black),
        );
    }
  }
}
