import 'dart:convert';

import 'package:http/http.dart' as http;

class PushNotificationServices {
  static Future sendNotification(
      {required String deviceToken,
      required String title,
      required String body}) async {
    http
        .post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
            headers: {
              "Content-Type": "application/json",
              "Authorization":
                  "key=AAAASiV8780:APA91bFI67dwuRtq53UW2QVurbsu4ks6UNgtzt9wLDDB-BkHNRXpOnzAU_KVMG1kVkQ_D4BdlVsPPoECWZJhTP3dPXIZC5xbug_dYJtgXenmaeHw1nSvG1Ev2LnF42llU6L8DWsItylm"
            },
            body: jsonEncode({
              "to": deviceToken,
              "notification": {
                "title": title,
                "body": body,
              },
              "data": {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
              }
            }))
        .then((value) => print(value.body));
  }
}
