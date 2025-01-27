import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/notification_data.dart';

/* final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast(); */

NotificationData? notificationData;

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.input?.isNotEmpty ?? false) {
    debugPrint(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LocalNotificationService.showNotification(message);
}

abstract class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// ✨Initialize the local notification plugin.⭐
  /// Called once when the app starts to initialize the local notification
  /// plugin. This sets up the plugin to work on both Android and iOS and
  /// sets up the callbacks for when the user taps on a notification.
  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // onDidReceiveLocalNotification:
      //     (int id, String? title, String? body, String? payload) async {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        //   selectNotificationStream.add(notificationResponse.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      message.messageId ?? Random().nextInt(99999).toString(),
      message.messageId ?? Random().nextInt(99999).toString(),
      importance: Importance.max,
      priority: Priority.high,
      colorized: true,
      color: AppColors.primary,
      showWhen: true,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: "default",
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(9999),
      Get.deviceLocale!.languageCode == "ar"
          ? message.data['Arabic_Title']
          : message.data['English_Title'],
      Get.deviceLocale!.languageCode == "ar"
          ? message.data['Arabic_Body']
          : message.data['English_Body'],
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }
}
