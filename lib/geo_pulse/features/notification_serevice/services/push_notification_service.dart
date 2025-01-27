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
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "time-tracker-672cc",
      "private_key_id": "113dec0293278c919dc6a246840fc97b7b19d5b8",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCipxustCVtNf/K\npcT6u/1puorL9lArpyWxQTB40eczz5bLYEavrBUAqiYF7majt1dzTVKTOj+Nz1Gh\ngTlFXRwqJhiQvtF5Kb3tU+CrkJ7V4PR+FwL8mMMJRetwMD/Jgf+C67KaH3paX20R\nZ7ht0xJfeL27m6jueIPqsM34t/MGovXbsEVofYPmub5ofYiB9o0gVVWCbiuvcTdZ\nT/+iC1IgdGwhafXweRSYfCJ9391B8NSLazrcJTcmI1gk/h4WfVanHDyuv4UiSCvO\n+XJ9eyusjJAmr4hGDEUkYV+8eKmXJ3Hoo1ze4LsFJB6co4o+DntVjmt2N9FBl4jz\nOwCaeeR1AgMBAAECggEAALKIutfW5T37B8poKs8NihuDptY6h8VisvzdkVcND7rP\nIbYa93vcZzFTkmjwRbluhY8KUJlKVnhSGEguj66ThVa+ejhnO4bDSrY2W2X2WGJr\nifLdT2n0RCDpnoSGcX2+M7iA/oouAx8vn4h7UPU7ue8RmTFUqxkXL7VsXKmlQB0H\nAYpGGYrXg0QVav530Yfr6+NhZPuVbdsn38MC8x1diy8secMUBhGmX74zwFNp2UDP\nvvZCgaE0mukbOgVMX5QLm5YpXw+zPGvScTW3KSK7pHJqb18l897x60Z5z38J6spY\n1spmFySl272a1hCwvKOqNe4M5ifOCkxyJzqVINf0wQKBgQDcaYTk1Y5YwaBa2bfC\npgUpCdchxuOsSPM21V2Z6HmMBxLl7HJC5Rov0KSTAPuL7mmlvEsbeYJTNP5F5J5V\nIPV1AQQhPjkbIwSgRJRWs89rVwiFF3xf2DbokR1HIE0w1Ry9N1mY5vHwKd7NcdNW\ntkmzVO4fmTFdtVQPM56yJv+wsQKBgQC86iu0jm6prh8koC+fmMNtXxm7JT2YgjOL\nEULUwXtPKgl2xyOfx1czrrgimBKfEVUTrzvwHL/UWUPr31OVJIXjzmPC3cimA8Qg\nAoHsjLqHr6euU+goaV8ebKSWW5+1Cq8HeJZmjKtf6Wzgf/h3jrDgDvcAD2bXqsu3\n/rZmqSbBBQKBgQCfO5QIhceqk2e3eqZo9uuvdC55dmgwpRsgOBDBCdQVt16NwL3j\nWgQLGx5qHUGdHAYy988C8EuYtSYldD52nbL2bl9/bKZw1mGXLzRDVu+4Sk4baJYv\n39H7Pir6oXlil/OFNyGBdwa+TGFr5pmZgWPJLMhDB7dETaWGvfIeHlKGYQKBgGsE\npTmlrl8FOrM+43ufyKW+yA7Sa/BnYdeYMang6X/RKodVDINJI8ctZTaDu5jM8ssx\n69x8DNe4sdd/LhRBGnAQzUbo6O/TFlmj0gI1Pr367hy9f7jU6IONvDdJNFIU+U5c\nK6dwbOzqiTkshY8FEIH9OEOadgIayUk0TBQgIsoZAoGAEl6+MJ3EobxhUnJVQ28i\nAfnKftu3jFQ0eUQqHUryqhi9MKpcNEbn3epupWvK9jRbgQ8X57z2RWHnBQ/YFLCL\n+STJEOg9qqU2wU/O6bkoL/Nc1qRxmqlMAvd+OlWs8NxuIjw/XgxW3N7oCDEExr4p\npnUHdX2D8z2a7HA2Fd/Ejfk=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-8h6b3@time-tracker-672cc.iam.gserviceaccount.com",
      "client_id": "111608450257597302771",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-8h6b3%40time-tracker-672cc.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

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
