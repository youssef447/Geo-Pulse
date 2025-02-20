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
  // if(message.data['id']=='request')
  LocalNotificationService.showNotification(message);
}

abstract class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> handleNotificationLaunch() async {
    final notificationTapDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationTapDetails?.didNotificationLaunchApp ?? false) {
      notificationTap(notificationTapDetails!.notificationResponse!);
    }
  }

  static Future<void> initialize() async {
    /*   flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestExactAlarmsPermission(); */

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'requests', // Channel ID
      'request_approval_channel', // Channel Title
      importance: Importance.max, showBadge: false,
      // sound:  UriAndroidNotificationSound('notification'),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const DarwinNotificationCategory iOSCategory = DarwinNotificationCategory(
      'requests',
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: false,
            requestSoundPermission: true,
            notificationCategories: [iOSCategory]
            /* notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
         
        ),
      ], */
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
      //should be message.data['id'] , message.data['name']
      'requests', // Channel ID
      'request_approval_channel', // Channel Title

      // sound: UriAndroidNotificationSound('notification'),

      priority: Priority.max,
      colorized: true,
      color: AppColors.background,
      largeIcon: DrawableResourceAndroidBitmap('report'),
      showWhen: true,

      /*     actions: [
          AndroidNotificationAction(
            'id1',
            'title1',
            showsUserInterface: true,
            cancelNotification: true,
            contextual: true,
          ),
        ] */
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
      categoryIdentifier: "requests",

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
      Get.locale?.toString().contains('ar') ?? false
          ? message.data['Arabic_Title']
          : message.data['English_Title'],
      Get.locale?.toString().contains('ar') ?? false
          ? message.data['Arabic_Body']
          : message.data['English_Body'],
      notificationDetails,
      payload: jsonEncode(message.data),
    );
  }
}
