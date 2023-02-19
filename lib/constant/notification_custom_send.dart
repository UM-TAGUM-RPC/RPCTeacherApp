import 'dart:developer';

import 'package:dio/dio.dart' as d;

class NotificationSend {
  static final dio = d.Dio();

  static sendMessageTo({String? fcmToken, String? title, String? body}) async {
    try {
      await dio.post("https://fcm.googleapis.com/fcm/send",
          data: {
            "to": fcmToken,
            "notification": {
              "body": body ?? "",
              "title": title ?? "Notification",
            }
          },
          options: d.Options(headers: {
            "Content-Type": "application/json",
            "Authorization":
                "key=AAAAmL5EGcU:APA91bGc1TGqnfWaqmKxqqSKMK6n_l10DhR8NYDTIQbf2WomewxehaeG1WOeS87J-yA58Rs0D0l4vv4Dk4O4LKAoEUnaLI0HWMkqaXml5IVVVner-XJT__y8Kg2pfiGs_9TelrZwGcDK",
          }));
    } on d.DioError catch (e) {
      log(e.response!.data.toString(), name: "Notification Error");
    }
  }
}
