import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rpcadvisorapp/constant/constant.dart';

final firebaseMessagingProvider =
    Provider<FirebasePushNotif>((ref) => FirebasePushNotif());

class FirebasePushNotif {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel? channel;
  final AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings('mipmap/logo_square');

  onInit() async {
    if (Platform.isAndroid) {
      final InitializationSettings initializationSettings =
          InitializationSettings(android: androidInitializationSettings);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      if (!kIsWeb) {
        log("Channel Iniatialize");
        channel = const AndroidNotificationChannel(
          "high_importance_channel",
          "High Importance Notification",
          description: "This channel is used for important notifications",
          importance: Importance.high,
          enableVibration: true,
          playSound: true,
        );
      }
    }
    firebaseMessageListen();
    getToken();
  }

  firebaseMessageListen() async {
   if(!(await Permission.notification.isGranted)){
     NotificationSettings perm =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (perm.authorizationStatus == AuthorizationStatus.authorized) {
    } else if (perm.authorizationStatus == AuthorizationStatus.provisional) {
    } else {}
   }
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      RemoteNotification? notification = message!.notification;
      AndroidNotification? android = message.notification?.android;
      log("Device IOS/Android ${message.contentAvailable}");
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
            android: AndroidNotificationDetails(
              channel!.id,
              channel!.name,
              channelDescription: channel!.description,
              channelShowBadge: true,
              icon: "mipmap/logo_square",
              priority: Priority.high,
              importance: Importance.high,
              color: CustomColor.kindaRed,
              enableVibration: true,
              playSound: true,
              //styleInformation:
            ),
          ),
        );
        log(channel!.id);
        log(channel!.name);
      } else {
        ///
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log(message.notification!.body!);
    });
  }

  getToken() async {
    FirebaseMessaging.instance.requestPermission();
    final result = await FirebaseMessaging.instance.getToken();
    if (SharedPrefs.read(tokenDevice) != null &&
        SharedPrefs.read(tokenDevice) == result) {
      log("Token Firebase already been saved");
    } else {
      if (Platform.isAndroid) {
        SharedPrefs.write(tokenDevice, result);
        log("Token Device user save $result", name: "Device Token");
      }
    }
  }
}
