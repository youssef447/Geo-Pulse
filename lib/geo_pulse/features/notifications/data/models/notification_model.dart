import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String title;
  final String titleArabic;
  final String body;
  final String bodyArabic;
  final String type;

  final bool seen;
  final Timestamp timestamp;
  final String? attendanceRequestId;

  NotificationModel({
    required this.title,
    required this.titleArabic,
    required this.body,
    required this.bodyArabic,
    required this.seen,
    required this.type,
    required this.timestamp,
    this.attendanceRequestId,
  });

  Map<String, dynamic> toMap() {
    return {
      'Title': title,
      'Title_Arabic': titleArabic,
      'Body': body,
      'Body_Arabic': bodyArabic,
      'Seen': seen,
      'Timestamp': timestamp,
      "Attendance_Request_Id": attendanceRequestId,
      'Type': type,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['Title'],
      titleArabic: map['Title_Arabic'],
      body: map['Body'],
      bodyArabic: map['Body_Arabic'],
      seen: map['Seen'],
      timestamp: map['Timestamp'],
      attendanceRequestId: map["Attendance_Request_Id"],
      type: map['Type'],
    );
  }
}
