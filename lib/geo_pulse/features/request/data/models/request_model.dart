// ignore_for_file: prefer_null_aware_operators

import 'package:tracking_module/tracking_module/features/request_type/data/models/request_type_model.dart';

import '../../../../core/constants/enums.dart';
import 'doc_model.dart';

class RequestModel {
  // Model fields
  String id;
  RequestTypeModel requestType;
  DateTime startDate;
  DateTime endDate;
  String? startTime;
  String? endTime;
  DateTime requestDate;
  RequestStatus requestStatus;
  Duration totalTime;
  String? description;
  DateTime? reminderSentDate;
  String? reasonOfRejection;

  String hrApproval;
  List<DocModel>? attachments;
  String requestedUserId;

  RequestModel({
    required this.id,
    required this.requestType,
    required this.startDate,
    required this.endDate,
    required this.requestStatus,
    required this.totalTime,
    required this.hrApproval,
    required this.requestedUserId,
    this.description,
    this.attachments,
    this.reminderSentDate,
    this.reasonOfRejection,
    this.startTime,
    this.endTime,
    required this.requestDate,
  });

  // to json
  Map<String, dynamic> toMap() {
    return {
      fieldId: id,
      fieldRequestType: requestType.toJson(),
      fieldStartDate: startDate.toString(),
      fieldEndDate: endDate.toString(),
      fieldRequestDate: requestDate.toString(),
      fieldRequestStatus: requestStatus.getName.toLowerCase(),
      fieldTotalTime: totalTime.inMinutes,
      fieldDescription: description?.toLowerCase(),
      fieldAttachments:
          attachments?.map((DocModel doc) => doc.toMap()).toList(),
      fieldRequestedUserId: requestedUserId,
      fieldReminderSentDate:
          reminderSentDate != null ? reminderSentDate.toString() : null,
      fieldReasonOfRejection: reasonOfRejection?.toLowerCase(),
      fieldStartTime: startTime,
      fieldEndTime: endTime,
      fieldHrApproval: hrApproval,
    };
  }

  // from Map
  factory RequestModel.fromMap(Map<String, dynamic> json) {
    return RequestModel(
      id: json[fieldId],
      requestType: RequestTypeModel.fromJson(
          json[fieldRequestType] as Map<String, dynamic>),
      startDate: DateTime.parse(json[fieldStartDate]),
      endDate: DateTime.parse(json[fieldEndDate]),
      requestDate: DateTime.parse(json[fieldRequestDate]),
      requestStatus: json[fieldRequestStatus] == 'approved'
          ? RequestStatus.approved
          : json[fieldRequestStatus] ==
                  RequestStatus.pending.getName.toLowerCase()
              ? RequestStatus.pending
              : RequestStatus.rejected,
      totalTime: Duration(minutes: json[fieldTotalTime]),
      description: json[fieldDescription],
      attachments: json[fieldAttachments] != null
          ? List<DocModel>.from(
              json[fieldAttachments].map((x) => DocModel.fromMap(x)))
          : null,
      requestedUserId: json[fieldRequestedUserId],
      reminderSentDate: json[fieldReminderSentDate] != null
          ? DateTime.parse(json[fieldReminderSentDate])
          : null,
      reasonOfRejection: json[fieldReasonOfRejection],
      startTime: json[fieldStartTime],
      endTime: json[fieldEndTime],
      hrApproval: json[fieldHrApproval],
    );
  }

  // Static constants for field keys
  static const String fieldId = 'Id';
  static const String fieldRequestType = 'Request_Type';
  static const String fieldStartDate = 'Start_Date';
  static const String fieldEndDate = 'End_Date';
  static const String fieldRequestDate = 'Request_Date';
  static const String fieldRequestStatus = 'Request_Status';
  static const String fieldTotalTime = 'Total_Time';
  static const String fieldDescription = 'Description';
  static const String fieldAttachments = 'Attachments';
  static const String fieldRequestedUserId = 'Requested_User_Id';
  static const String fieldReminderSentDate = 'Reminder_Sent_Date';
  static const String fieldReasonOfRejection = 'Reason_Of_Rejection';
  static const String fieldStartTime = 'Start_Time';
  static const String fieldEndTime = 'End_Time';
  static const String fieldHrApproval = 'HR_Approval';
}
