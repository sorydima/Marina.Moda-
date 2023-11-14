import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../helpers/Constant.dart';

import '../screens/main_screen.dart';

@pragma('vm:entry-point')
void onBackgroundMessageLocal(NotificationResponse message) async {
  await Firebase.initializeApp();
}

class FirebaseInitialize {
  final _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;
  initFirebaseState(BuildContext context) async {
    channel = const AndroidNotificationChannel(
        'com.marina.moda', // id
        'Marina.Moda ® 💖♥️', // title
        description: 'Get on Marina.Moda ® to help you connect with fans and grow up your audience! 🚀🙏', // description
        importance: Importance.high,
        playSound: true);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher_squircle');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
      notificationCategories: [],
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    onSelectNotification(String? payload) async {
//supportNotificationType
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            onSelectNotification(notificationResponse.payload!);
            break;

          case NotificationResponseType.selectedNotificationAction:
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: onBackgroundMessageLocal,
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    Future<void> generateSimpleNotication(String title, String msg) async {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        playSound: true,
        icon: notificationIcon,
      );
      var iosDetail = const DarwinNotificationDetails();

      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics, iOS: iosDetail);
      await flutterLocalNotificationsPlugin.show(
          0, title, msg, platformChannelSpecifics);
    }

    Future<void> generateImageNotication(
        String title, String msg, String image) async {
      var bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(image),
          hideExpandedLargeIcon: true,
          contentTitle: title,
          htmlFormatContentTitle: true,
          summaryText: msg,
          htmlFormatSummaryText: true);
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channel.id, channel.name,
          channelDescription: channel.description,
          playSound: true,
          icon: notificationIcon,
          largeIcon: FilePathAndroidBitmap(image),
          styleInformation: bigPictureStyleInformation);

      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        msg,
        platformChannelSpecifics,
      );
    }

    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {}
    });

    _firebaseMessaging.getToken().then((value) {
      print('token==$value');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      var title = notification.title ?? '';
      var body = notification.body ?? '';
      var image = '';

      image = defaultTargetPlatform == TargetPlatform.android
          ? notification.android!.imageUrl ?? ''
          : notification.apple!.imageUrl ?? '';

      if (image != '') {
        generateImageNotication(title, body, image);
      } else {
        generateSimpleNotication(title, body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      var title = notification.title ?? '';
      var body = notification.body ?? '';
      PendingDynamicLinkData? dynamicLinkData;
      if (Uri.parse(body).host != '') {
        dynamicLinkData =
            await FirebaseDynamicLinks.instance.getDynamicLink(Uri.parse(body));
      }
      if (dynamicLinkData != null) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (_) => MyHomePage(
                    webUrl: dynamicLinkData!.link.toString(),
                  )),
          (route) => false,
        );
      }
    });
  }
}
