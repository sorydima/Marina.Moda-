// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/splash_screen.dart';
import '../helpers/Constant.dart';
import '../screens/main_screen.dart';
import '../widgets/admob_service.dart';
import '../provider/theme_provider.dart';
import '../provider/navigationBarProvider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
late SharedPreferences pref;
Future<void> _messageHandler(RemoteMessage message) async {}
// Create a global instance of FirebaseMessaging
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

// Create a global instance of FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
enableStoragePermision() async {
  if (Platform.isIOS) {
    bool permissionGiven = await Permission.storage.isGranted;
    if (!permissionGiven) {
      permissionGiven = (await Permission.storage.request()).isGranted;
      return permissionGiven;
    }
    return permissionGiven;
  }
  //if it is for android
  final deviceInfoPlugin = DeviceInfoPlugin();
  final androidDeviceInfo = await deviceInfoPlugin.androidInfo;

  if (androidDeviceInfo.version.sdkInt < 33) {
    bool permissionGiven = await Permission.storage.isGranted;
    if (!permissionGiven) {
      permissionGiven = (await Permission.storage.request()).isGranted;
      return permissionGiven;
    }

    return permissionGiven;
  } else {
    bool permissionGiven = await Permission.photos.isGranted;

    if (!permissionGiven) {
      permissionGiven = (await Permission.photos.request()).isGranted;

      return permissionGiven;
    }
    return permissionGiven;
  }
}

Future main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //when we have to communicate to flutter framework before initializing app
  pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  AdMobService.initialize();
  await requestNotificationPermissions();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  int counter = 0;

  if (isStoragePermissionEnabled) {
    await enableStoragePermision();
  }

  SharedPreferences.getInstance().then((prefs) {
    prefs.setInt('counter', counter);
    var isDarkTheme =
        prefs.getBool("isDarkTheme") ?? ThemeMode.system == ThemeMode.dark
            ? true
            : false;

    return runApp(
      ChangeNotifierProvider<ThemeProvider>(
        child: MyApp(),
        create: (BuildContext context) {
          return ThemeProvider(isDarkTheme);
        },
      ),
    );
  });
}

Future<void> requestNotificationPermissions() async {

  // Request permission for iOS
  await _firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Request permission for Android
  await _firebaseMessaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      /* start--uncommnet  below 2 lines to enable landscape mode */
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
      /*end */
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationBarProvider>(
            create: (_) => NavigationBarProvider())
      ],
      child: Consumer<ThemeProvider>(builder: (context, value, child) {
        return MaterialApp(
          title: appName,
          debugShowCheckedModeBanner: false,
          themeMode: value.getTheme(),
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          navigatorKey: navigatorKey,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case 'settings':
                return CupertinoPageRoute(builder: (_) => SettingsScreen());
            }
          },
          home: showSplashScreen
              ? SplashScreen()
              : MyHomePage(
                  webUrl: webinitialUrl,
                ),
        );
      }),
    );
  }
}
