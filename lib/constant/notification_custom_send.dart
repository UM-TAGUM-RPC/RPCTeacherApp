import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as d;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';

class NotificationSend {
  static final dio = d.Dio();

  static Future<void> sendMessageTo(
      {String? fcmToken, String? title, String? body}) async {
    log("Start Sending ${await FirebaseMessaging.instance.getToken()}",
        name: "NOTIF SEND");
    final serviceAccount =
        await rootBundle.loadString('assets/json/rpc-service-key.json');

    final saJson = jsonDecode(serviceAccount) as Map<String, dynamic>;
    final accountCredentials = ServiceAccountCredentials.fromJson(saJson);
    //log("$saJson", name: "NOTIF SEND");
    final scopes = [
      'https://www.googleapis.com/auth/firebase.messaging',
      // 'https://www.googleapis.com/auth/cloud-platform'
    ];
    final client = await clientViaServiceAccount(accountCredentials, scopes);

    const projectId = "rpc2023-5ad2e";
    log("TOKEN EXP ${client.credentials.accessToken.hasExpired}}",
        name: "NOTIF SEND");
    final data = {
      "message": {
        "token":
            "eU0PrQSDTrqH_xXNXMKoNN:APA91bFpfd6hTAvHpkbaJsFVkdZRhaVkHvmsvzFBdMYjzkVV-GLcEUDktUY6Dbu0eftjslArmMgFLbVao09yjEBzzu-5yTUg-pKrcVaooWCcO4JiAAiiXFw",
        "notification": {"title": "$title", "body": body ?? ""},
      }
    };
    await client
        .post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(data),
    )
        .then((resp) {
      log('FCM status: ${resp.statusCode}');
      log('FCM body: ${resp.body}');
    });

    // 7) Inspect result

    // try {
    //   final r = await dio.post(
    //       "https://fcm.googleapis.com/v1/projects/$projectId/messages:send",
    //       data: {
    //         "message": {
    //           "token":
    //               "eU0PrQSDTrqH_xXNXMKoNN:APA91bFpfd6hTAvHpkbaJsFVkdZRhaVkHvmsvzFBdMYjzkVV-GLcEUDktUY6Dbu0eftjslArmMgFLbVao09yjEBzzu-5yTUg-pKrcVaooWCcO4JiAAiiXFw",
    //           "notification": {"title": "$title", "body": body ?? ""},
    //         }
    //       },
    //       options: d.Options(headers: {
    //         "Content-Type": "application/json",
    //         "Authorization": "Bearer ${client.credentials.accessToken.data}",
    //       }));

    //   log('status=${r.statusCode} data=${r.data}', name: 'FCM');
    // } on d.DioException catch (e) {
    //   log(e.response!.statusCode.toString(), name: "NOTIF SEND");
    //   log(e.response!.data.toString(), name: "NOTIF SEND");
    // }
  }
}
