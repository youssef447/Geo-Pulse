import 'notification_content.dart';
import 'notification_payload.dart';

class NotificationBody {
  final String? fcmToken;
  final String? topic;
  final NotificationContent notification;
  final NotificationPayload payload;

  NotificationBody({
    this.fcmToken,
    this.topic,
    required this.notification,
    required this.payload,
  });

  Map<String, dynamic> toMap() {
    return {
      "message": {
        if (fcmToken != null) "token": fcmToken,
        if (topic != null) "topic": topic,
        //for all platforms
        //  "notification": notification.toMap(),
        /*     "android": {
          // "priority":"HIGH", //NORMAL
          "notification": {
            "notification_priority": "PRIORITY_HIGH",
            "sound": "default",
          },
        },
        "apns": {
          "payload": {
            "aps": {
              //"alert": notification.toMap(),
              'content-available': 1,
              "sound": "default",
            },
          },
          //"fcm_options": {'image': image},
        }, */
        "data": payload
            .toMap() /* .addAll({'notification': notification.toMap()}) */,
      },
    };
  }
}
