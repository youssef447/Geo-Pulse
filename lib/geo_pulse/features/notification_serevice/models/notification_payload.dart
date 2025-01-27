import 'notification_content.dart';
import 'notification_data.dart';

class NotificationPayload {
  final String fcmToken;
  final NotificationContent notification;
  final NotificationData data;

  NotificationPayload({
    required this.fcmToken,
    required this.notification,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      "message": {
        "token": fcmToken,
        // "notification": notification.toMap(),
        // "android": {
        //   "notification": {
        //     "notification_priority": "PRIORITY_MAX",
        //     "sound": "default",
        //   },
        // },
        "apns": {
          "payload": {
            "aps": {
              "content_available": true,
              "alert": notification.toMap(),
              "sound": "default",
            },
          },
        },
        "data": data.toMap(),
      },
    };
  }
}
