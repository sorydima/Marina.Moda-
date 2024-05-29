import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marinamoda/pages/homepage.dart';
import 'package:marinamoda/pages/onboarding.dart';
import 'package:marinamoda/provider/homepageprovider.dart';
import 'package:marinamoda/provider/webview.dart';
import 'package:marinamoda/utils/colors.dart';
import 'package:marinamoda/utils/global_fuction.dart';
import 'package:marinamoda/utils/responsible_file.dart';
import 'utils/constants.dart';

late bool isIntro = false;
loadSharePre() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  isIntro = (prefs.getBool('intro') ?? false);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Permission.camera.request();
  // await Permission.location.request();
  // await Permission.microphone.request();

  MobileAds.instance.initialize();
  loadSharePre();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  checkInternetConnection();

  //Remove this method to stop OneSignal Debugging
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(oneSignalAppId);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    debugPrint("Accepted permission: $accepted");
  });

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => HomePageProvider()),
      ChangeNotifierProvider(create: (_) => WebViewProvider()),
    ], child: const MyApp()),
  ); //only myapp
}

// this is testing comment

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(statusBarColor: transparant));
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: introScreenOnOff
              ? isIntro
                  ? "/homePage"
                  : "/onBoardingPage"
              : "/homePage",
          routes: {
            "/homePage": (context) => const HomePage(),
            "/onBoardingPage": (context) => const OnBoardingPage()
          },
        );
      });
    });
  }
}
