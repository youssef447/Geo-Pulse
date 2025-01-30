import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geo_pulse/geo_pulse/core/extensions/extensions.dart';
import 'package:geo_pulse/geo_pulse/core/routes/app_routes.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_colors.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.payload?.isNotEmpty ?? false) {
    final Map data = jsonDecode(notificationResponse.payload!);
    if (data['type'] == 'Request') {
      navKey.currentState!.pushNamed(Routes.notifications);
    }
  }
}

void notificationTap(NotificationResponse notificationResponse) {
  if (notificationResponse.payload?.isNotEmpty ?? false) {
    final Map data = jsonDecode(notificationResponse.payload!);
    if (data['type'] == 'Request') {
      navKey.currentState!.pushNamed(Routes.notifications);
    }
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  LocalNotificationService.showNotification(message);
}

abstract class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize the local notification plugin.
  /// Called once when the app starts to initialize the local notification
  /// plugin. This sets up the plugin to work on both Android and iOS and
  /// sets up the callbacks for when the user taps on a notification.
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('report');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      message.messageId ?? Random().nextInt(99999).toString(),
      message.messageId ?? Random().nextInt(99999).toString(),
      importance: Importance.max,
      //  sound: UriAndroidNotificationSound('notification'),
      priority: Priority.high,
      colorized: true,
      color: AppColors.primary,
      largeIcon: DrawableResourceAndroidBitmap('geo'),
      showWhen: true, category: AndroidNotificationCategory.status,
      /* styleInformation: BigPictureStyleInformation(
        DrawableResourceAndroidBitmap(_bitmap),
      ), */
      //  icon: message.data['Type'] == 'Request' ? 'report' : '',
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: "default",
      /*   attachments: [
        DarwinNotificationAttachment('your_icon.png'),
      ], */
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(9999),
      Get.locale!.toString().contains('ar')
          ? message.data['Arabic_Title']
          : message.data['English_Title'],
      Get.locale!.toString().contains('ar')
          ? message.data['Arabic_Body']
          : message.data['English_Body'],
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }
}
