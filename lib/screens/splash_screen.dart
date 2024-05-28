import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marinamoda/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marinamoda/helpers/Colors.dart';
import 'package:marinamoda/helpers/Constant.dart';
import 'package:marinamoda/helpers/Icons.dart';
import 'package:marinamoda/main.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, () async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (showOnboardingScreen && (pref.getBool('isFirstTimeUser') ?? true)) {
        navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (_) => const OnboardingScreen()));
      } else {
        navigatorKey.currentState!.pushReplacement(MaterialPageRoute(
            builder: (_) => const MyHomePage(
                  webUrl: webinitialUrl,
                )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark));
    return Scaffold(
      body: Container(
          padding: EdgeInsets.zero,
          height: double.maxFinite,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [splashBackColor1, splashBackColor2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
          child: Center(
            child: SvgPicture.asset(
              Theme.of(context).colorScheme.splashLogo,
              width: 200,
              height: 200,
            ),
          )),
    );
  }
}
