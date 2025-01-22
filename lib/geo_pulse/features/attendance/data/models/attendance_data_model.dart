import 'package:flutter/material.dart';

import '../../../../core/constants/enums.dart';
import '../../../request/data/models/doc_model.dart';

class AttendanceDataModel {
  DateTime date;
  TimeOfDay? oncomingTime;
  TimeOfDay? leavingTime;
  Duration? breakTime;
  Duration? totalTime;
  AttendanceStatus status;
  List<DocModel>? attachments;
  String? id;
  AttendanceDataModel({
    required this.date,
    this.oncomingTime,
    this.leavingTime,
    this.breakTime,
    this.totalTime,
    required this.status,
    this.attachments,
    this.id,
  });
  // Static constants for keys
  static const String fieldDate = 'Date';
  static const String fieldOncomingTime = 'Oncoming_Time';
  static const String fieldLeavingTime = 'Leaving_Time';
  static const String fieldBreakTime = 'Break_Time';
  static const String fieldTotalTime = 'Total_Time';
  static const String fieldStatus = 'Status';
  static const String fieldAttachments = 'Attachments';
  static const String userId = 'user_ID';
  //from json
  factory AttendanceDataModel.fromMap(Map<String, dynamic> json) {
    return AttendanceDataModel(
      id: json[userId],
      date: DateTime.parse(json[fieldDate]),
      oncomingTime: json[fieldOncomingTime] != null
          ? TimeOfDay(
              hour: int.parse(json[fieldOncomingTime].split(':')[0]),
              minute: int.parse(json[fieldOncomingTime].split(':')[1]),
            )
          : null,
      leavingTime: json[fieldLeavingTime] != null
          ? TimeOfDay(
              hour: int.parse(json[fieldLeavingTime].split(':')[0]),
              minute: int.parse(json[fieldLeavingTime].split(':')[1]),
            )
          : null,
      breakTime: json[fieldBreakTime] != null
          ? Duration(
              hours: int.parse(json[fieldBreakTime].split(':')[0]),
              minutes: int.parse(json[fieldBreakTime].split(':')[1]),
              seconds:
                  int.parse(json[fieldBreakTime].split(':')[2].substring(0, 2)),
            )
          : null,
      totalTime: json[fieldTotalTime] != null
          ? Duration(
              hours: int.parse(json[fieldTotalTime].split(':')[0]),
              minutes: int.parse(json[fieldTotalTime].split(':')[1]),
              seconds:
                  int.parse(json[fieldTotalTime].split(':')[2].substring(0, 2)),
            )
          : null,
      status: json[fieldStatus] == AttendanceStatus.absent.getName.toLowerCase()
          ? AttendanceStatus.absent
          : json[fieldStatus] == AttendanceStatus.present.getName.toLowerCase()
              ? AttendanceStatus.present
              : AttendanceStatus.late,
      attachments: json[fieldAttachments] != null
          ? List<DocModel>.from(
              json[fieldAttachments].map((x) => DocModel.fromMap(x)))
          : null,
    );
  }
  // to json
  Map<String, dynamic> toMap() => {
        fieldDate: date.toString(),
        fieldOncomingTime:
            oncomingTime?.toString().replaceAll(RegExp(r'TimeOfDay\(|\)'), ''),
        fieldLeavingTime:
            leavingTime?.toString().replaceAll(RegExp(r'TimeOfDay\(|\)'), ''),
        fieldBreakTime: breakTime?.toString(),
        fieldTotalTime: totalTime?.toString(),
        fieldStatus: status.getName.toLowerCase(),
        fieldAttachments:
            attachments?.map((DocModel doc) => doc.toMap()).toList(),
      };
}
