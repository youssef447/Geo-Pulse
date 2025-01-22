import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import '../users/logic/add_employee_controller.dart';
import '../../features/notification_serevice/notification_model.dart';
import '../../features/notification_serevice/notification_service.dart';

class AppNotificationController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final fcm = FirebaseMessaging.instance;

  List<NotificationModel> allNotifications = [];
  bool isLoading = false;

  /// ✨Format a topic.⭐
  /// Replaces all "@", ":", " ", and "-" in the topic with "_"
  /// and appends "topic" to the end. This is the format that
  /// Firebase Cloud Messaging expects for topics.
  String formatTopic(String topic) {
    return "${topic.replaceAll("@", "_").replaceAll(":", "_").replaceAll(" ", "_").replaceAll("-", "_")}topic";
  }

  /// ✨Subscribe to a topic.⭐
  /// This will subscribe the user to a topic, and they will start receiving
  /// notifications for that topic.
  Future<void> subscribeToTopic(String topic) async {
    await fcm.subscribeToTopic(formatTopic(topic));
    debugPrint("subscribe to topic $topic");
  }

  /// ✨Unsubscribe from a topic.⭐
  /// This will remove the user from a topic, and they will stop receiving notifications
  /// for that topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await fcm.unsubscribeFromTopic(formatTopic(topic));
    debugPrint("unsubscribe topic $topic");
  }

  /// ✨Requests permission from the user to receive notifications.⭐
  Future<void> requestPermission() async {
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint("User granted provisional permission");
    } else {
      debugPrint("User declined or has not accepted permission");
    }
  }

  /// ✨Initializes Firebase Cloud Messaging (FCM) by requesting permission
  /// for the app to receive notifications and retrieves a Firebase
  /// messaging token. The token is used to authenticate with the FCM API.⭐
  Future<void> initNotifications() async {
    await requestPermission();
    String? firebaseMessagingToken = await fcm.getToken();
    debugPrint("firebaseMessagingToken : $firebaseMessagingToken");
  }

  /// ✨Returns a Firebase access token that can be used to call Firebase APIs.⭐
  ///
  /// This method is used to get a token that can be used to call Firebase APIs,
  /// such as the Firebase Cloud Messaging (FCM) API. The token is obtained by
  /// using a service account to authenticate with Google.
  ///
  /// The returned token is a string that can be used as a Bearer token in the
  /// Authorization header of HTTP requests to Firebase APIs.
  ///
  /// The token is valid for one hour. After that, the method needs to be called
  /// again to obtain a new token.
  Future<String?> getAccessToken() async {
    final serviceAccountJson = {};

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);

      client.close();

      debugPrint("Access Token: ${credentials.accessToken.data}");
      debugPrint("fcm Token : ${await fcm.getToken()}");
      return credentials.accessToken.data;
    } catch (e) {
      return null;
    }
  }

  /// ✨Send a notification to a given topic.⭐
  Future<void> sendNotification(
      {required String title,
      required String arabicTitle,
      required String body,
      required String arabicBody,
      required String type,
      required String topic,
      String? noteId,
      String? cardId,
      String? todoId,
      String? eventId,
      String? surveyId,
      String? boardId,
      String? serviceId,
      String? attendanceRequestId,
      String? serviceRequestId}) async {
    try {
      var serverKeyAuthorization = await getAccessToken();

      const String urlEndPoint =
          "https://fcm.googleapis.com/v1/projects//* knowticed-v2-scheme *//messages:send";

      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

      await dio
          .post(
        urlEndPoint,
        data: NotificationPayload(
          fcmToken: '/topics/${formatTopic(topic)}',
          data: NotificationData(
            arabicTitle: arabicTitle,
            arabicBody: arabicBody,
            englishTitle: title.capitalize!,
            englishBody: body.capitalize!,
            type: type.toLowerCase(),
            noteId: noteId,
            cardId: cardId,
            todoId: todoId,
            eventId: eventId,
            surveyId: surveyId,
            boardId: boardId,
            serviceId: serviceId,
            attendanceRequestId: attendanceRequestId,
            serviceRequestId: serviceRequestId,
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          ),
          notification: NotificationContent(
            title: title.capitalize!,
            body: body.capitalize!,
          ),
        ).toMap(),
      )
          .then(
        (value) async {
          NotificationModel notification = NotificationModel(
              title: title.toLowerCase(),
              titleArabic: arabicTitle.toLowerCase(),
              body: body.toLowerCase(),
              bodyArabic: arabicBody.toLowerCase(),
              type: type.toLowerCase(),
              seen: false,
              timestamp: Timestamp.now(),
              boardId: boardId,
              cardId: cardId,
              eventId: eventId,
              noteId: noteId,
              serviceId: serviceId,
              serviceRequestId: serviceRequestId,
              surveyId: surveyId,
              todoId: todoId,
              attendanceRequestId: attendanceRequestId);
          await FirebaseFirestore.instance
              .collection('Notifications')
              .doc(topic)
              .collection('Notifications')
              .doc(
                  DateTime.now().toString() + Random().nextInt(9999).toString())
              .set(notification.toMap());
          debugPrint("Notification sent successfully999");
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// ✨Sends a notification to multiple topics.⭐
  ///
  /// This method takes a list of topics and sends a notification to all of them.
  /// The notification is stored in the database and has a unique id generated
  /// by the server.
  Future<void> sendNotificationToMultiple(
      {required String title,
      required String arabicTitle,
      required String body,
      required String arabicBody,
      required String type,
      required List<String> topics,
      String? noteId,
      String? cardId,
      String? todoId,
      String? eventId,
      String? surveyId,
      String? boardId,
      String? serviceId,
      String? attendanceRequestId,
      String? serviceRequestId}) async {
    try {
      WriteBatch batch = db.batch();
      final CollectionReference notificationsCollection =
          db.collection('/Notifications');
      var serverKeyAuthorization = await getAccessToken();

      const String urlEndPoint = "";

      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

      for (var element in topics) {
        debugPrint(element);
        await dio
            .post(urlEndPoint,
                data: NotificationPayload(
                    fcmToken: '/topics/${formatTopic(element)}',
                    data: NotificationData(
                      arabicTitle: arabicTitle,
                      arabicBody: arabicBody,
                      englishTitle: title.capitalize!,
                      englishBody: body.capitalize!,
                      type: type.toLowerCase(),
                      noteId: noteId,
                      cardId: cardId,
                      todoId: todoId,
                      eventId: eventId,
                      surveyId: surveyId,
                      boardId: boardId,
                      serviceId: serviceId,
                      attendanceRequestId: attendanceRequestId,
                      serviceRequestId: serviceRequestId,
                      clickAction: "FLUTTER_NOTIFICATION_CLICK",
                    ),
                    notification: NotificationContent(
                      title: title.capitalize!,
                      body: body.capitalize!,
                    )).toMap())
            .then(
          (value) async {
            NotificationModel notification = NotificationModel(
              title: title.toLowerCase(),
              titleArabic: arabicTitle.toLowerCase(),
              body: body.toLowerCase(),
              bodyArabic: arabicBody.toLowerCase(),
              type: type.toLowerCase(),
              seen: false,
              timestamp: Timestamp.now(),
              boardId: boardId,
              cardId: cardId,
              eventId: eventId,
              noteId: noteId,
              serviceId: serviceId,
              serviceRequestId: serviceRequestId,
              surveyId: surveyId,
              todoId: todoId,
              attendanceRequestId: attendanceRequestId,
            );

            batch.set(
              notificationsCollection
                  .doc(element)
                  .collection('Notifications')
                  .doc(DateTime.now().toString() +
                      Random().nextInt(9999).toString()),
              notification.toMap(),
              SetOptions(merge: true),
            );
          },
        );
      }
      await batch.commit();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// ✨Shows a local notification to the user with the given parameters.⭐
  static Future<void> showTodoNotification({
    required String titleEnglish,
    required String titleArabic,
    required String bodyEnglish,
    required String bodyArabic,
    required String type,
    String? todoId,
  }) async {
    NotificationData notificationData = NotificationData(
      type: type,
      englishTitle: titleEnglish,
      arabicTitle: titleArabic,
      englishBody: bodyEnglish,
      arabicBody: bodyArabic,
      todoId: todoId,
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Random().nextInt(99999).toString(),
      Random().nextInt(99999).toString(),
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: "default",
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinNotificationDetails,
    );

    await NotificationService.flutterLocalNotificationsPlugin.show(
      Random().nextInt(9999),
      Get.deviceLocale!.languageCode == "ar" ? titleArabic : titleEnglish,
      Get.deviceLocale!.languageCode == "ar" ? bodyArabic : bodyEnglish,
      platformChannelSpecifics,
      payload: jsonEncode(notificationData.toMap()),
    );
  }

  /// Fetch all notifications for the currently logged in employee and store them
  /// in the [allNotifications] list.
  Future<void> fetchNotifications() async {
    isLoading = true;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Notifications')
        .doc(Get.find<UserController>().employee!.email)
        .collection('Notifications')
        .orderBy('Timestamp', descending: true)
        .get();

    allNotifications = querySnapshot.docs.map((doc) {
      return NotificationModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
    debugPrint("fetch allNotifications : ${allNotifications.length}");
    isLoading = false;
    update();
  }

  /// ✨Stream that emits a snapshot whenever unseen notifications for the currently
  /// logged in employee change.⭐
  ///  The snapshot contains all unseen notifications for the employee.
  Stream<QuerySnapshot> getUnseenNotificationsStream() {
    return FirebaseFirestore.instance
        .collection('Notifications')
        .doc(Get.find<UserController>().employee!.email)
        .collection('Notifications')
        .where('seen', isEqualTo: false)
        .snapshots();
  }

  /// ✨Mark all unseen notifications for the currently logged in employee as seen.⭐
  /// This is typically called when the user opens the notifications screen.
  Future<void> updateSeenNotifications() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Notifications')
        .doc(Get.find<UserController>().employee!.email)
        .collection('Notifications')
        .where('seen', isEqualTo: false)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'seen': true});
    }
    // querySnapshot.docs.forEach((element) {
    //   element.reference.update({'seen': true});
    // });
  }
}

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

class NotificationContent {
  final String title;
  final String body;

  NotificationContent({
    required this.title,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "body": body,
    };
  }
}

class NotificationData {
  final String? type;
  final String arabicTitle, arabicBody, englishTitle, englishBody;
  final String? noteId,
      cardId,
      todoId,
      eventId,
      surveyId,
      boardId,
      serviceId,
      serviceRequestId,
      attendanceRequestId;
  final String clickAction;

  NotificationData({
    this.type,
    this.noteId,
    this.cardId,
    this.todoId,
    this.eventId,
    this.surveyId,
    this.boardId,
    this.serviceId,
    this.serviceRequestId,
    this.attendanceRequestId,
    this.clickAction = "FLUTTER_NOTIFICATION_CLICK",
    required this.englishTitle,
    required this.arabicTitle,
    required this.englishBody,
    required this.arabicBody,
  });

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "click_action": clickAction,
      "Arabic_Title": arabicTitle,
      "English_Title": englishTitle,
      "Arabic_Body": arabicBody,
      "English_Body": englishBody,
      "Note_Id": noteId,
      "Card_Id": cardId,
      "Todo_Id": todoId,
      "Event_Id": eventId,
      "Survey_Id": surveyId,
      "Board_Id": boardId,
      "Service_Id": serviceId,
      "Service_Request_Id": serviceRequestId,
      "Attendance_Request_Id": attendanceRequestId,
    };
  }

  // from map

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      type: map["type"],
      noteId: map["Note_Id"],
      cardId: map["Card_Id"],
      todoId: map["Todo_Id"],
      eventId: map["Event_Id"],
      surveyId: map["Survey_Id"],
      boardId: map["Board_Id"],
      serviceId: map["Service_Id"],
      serviceRequestId: map["Service_Request_Id"],
      clickAction: map["click_action"] ?? "FLUTTER_NOTIFICATION_CLICK",
      englishTitle: map["English_Title"],
      arabicTitle: map["Arabic_Title"],
      englishBody: map["English_Body"],
      arabicBody: map["Arabic_Body"],
      attendanceRequestId: map["Attendance_Request_Id"],
    );
  }
}
