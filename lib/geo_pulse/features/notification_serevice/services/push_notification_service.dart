import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/utils.dart';
import '../models/notification_content.dart';
import '../models/notification_data.dart';
import '../models/notification_payload.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../../notifications/data/models/notification_model.dart';
import '../secret.dart';

abstract class PushNotificationService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static final _fcm = FirebaseMessaging.instance;

  /// Requests permission from the user to receive notifications.
  static Future<bool> requestPermission() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      return true;
    }
    return false;
  }

  /// Initializes Firebase Cloud Messaging (FCM) by requesting permission
  /// for the app to receive notifications and retrieves a Firebase
  /// messaging token. The token is used to authenticate with the FCM API.
  static Future<void> initNotifications() async {
    final bool granted = await requestPermission();
    if (granted) {
      String? firebaseMessagingToken = await _fcm.getToken();
      debugPrint("Firebase messaging token: $firebaseMessagingToken");
    }
  }

  /// Sends a notification to a given topic.
  static Future<void> sendNotification(
      {required String title,
      required String arabicTitle,
      required String body,
      required String arabicBody,
      required String type,
      required String topic,
      String? attendanceRequestId,
      String? serviceRequestId}) async {
    try {
      var accessToken = await _getAccessToken();

      const String urlEndPoint =
          "https://_fcm.googleapis.com/v1/projects/time-tracker-672cc/messages:send";

      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $accessToken';

      await dio
          .post(
        urlEndPoint,
        data: NotificationPayload(
          fcmToken: '/topics/${_formatTopic(topic)}',
          data: NotificationData(
            arabicTitle: arabicTitle,
            arabicBody: arabicBody,
            englishTitle: title.capitalize!,
            englishBody: body.capitalize!,
            attendanceRequestId: attendanceRequestId,
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
              type: type,
              title: title.capitalize!,
              titleArabic: arabicTitle.toLowerCase(),
              body: body.toLowerCase(),
              bodyArabic: arabicBody.toLowerCase(),
              seen: false,
              timestamp: Timestamp.now(),
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

  /// Sends a notification to multiple topics.

  Future<void> sendNotificationToMultiple(
      {required String title,
      required String arabicTitle,
      required String body,
      required String type,
      required String arabicBody,
      required List<String> topics,
      String? attendanceRequestId,
      String? serviceRequestId}) async {
    try {
      WriteBatch batch = _db.batch();
      final CollectionReference notificationsCollection =
          _db.collection('/Notifications');
      var serverKeyAuthorization = await _getAccessToken();

      const String urlEndPoint =
          "https://_fcm.googleapis.com/v1/projects/time-tracker-672cc/messages:send";

      Dio dio = Dio();
      dio.options.headers['Content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

      for (var element in topics) {
        debugPrint(element);
        await dio
            .post(
          urlEndPoint,
          data: NotificationPayload(
            fcmToken: '/topics/${_formatTopic(element)}',
            data: NotificationData(
              arabicTitle: arabicTitle,
              arabicBody: arabicBody,
              englishTitle: title.capitalize!,
              englishBody: body.capitalize!,
              attendanceRequestId: attendanceRequestId,
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
              title: title.capitalize!,
              type: type,
              titleArabic: arabicTitle.toLowerCase(),
              body: body.toLowerCase(),
              bodyArabic: arabicBody.toLowerCase(),
              seen: false,
              timestamp: Timestamp.now(),
              attendanceRequestId: attendanceRequestId,
            );

            batch.set(
              notificationsCollection
                  .doc(element)
                  .collection('Notifications')
                  .doc(),
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

  /// Returns a Firebase access token that can be used to call Firebase APIs
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
  static Future<String?> _getAccessToken() async {
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      //Obtains oauth2 credentials and returns an authenticated HTTP client To be used to obtain access credentials.
      http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
      );
      //obtain access credentials.
      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client,
      );

      client.close();

      debugPrint("Access Token: ${credentials.accessToken.data}");
      return credentials.accessToken.data;
    } catch (e) {
      return null;
    }
  }

  /// Format a topic
  /// Replaces all "@", ":", " ", and "-" in the topic with "_"
  /// and appends "topic" to the end. This is the format that
  /// Firebase Cloud Messaging expects for topics.
  static String _formatTopic(String topic) {
    return "${topic.replaceAll("@", "_").replaceAll(":", "_").replaceAll(" ", "_").replaceAll("-", "_")}topic";
  }

  /// Subscribe to a topic
  /// This will subscribe the user to a topic, and they will start receiving
  /// notifications for that topic.
  static Future<void> subscribeToTopic(String topic) async {
    await _fcm.subscribeToTopic(_formatTopic(topic));
    debugPrint("subscribe to topic $topic");
  }

  /// Unsubscribe from a topic
  /// This will remove the user from a topic, and they will stop receiving notifications
  /// for that topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm.unsubscribeFromTopic(_formatTopic(topic));
    debugPrint("unsubscribe topic $topic");
  }
}
