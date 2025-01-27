class NotificationData {
  final String arabicTitle, arabicBody, englishTitle, englishBody;
  final String? attendanceRequestId;
  final String clickAction;

  NotificationData({
    this.attendanceRequestId,
    this.clickAction = "FLUTTER_NOTIFICATION_CLICK",
    required this.englishTitle,
    required this.arabicTitle,
    required this.englishBody,
    required this.arabicBody,
  });

  Map<String, dynamic> toMap() {
    return {
      "click_action": clickAction,
      "Arabic_Title": arabicTitle,
      "English_Title": englishTitle,
      "Arabic_Body": arabicBody,
      "English_Body": englishBody,
      "Attendance_Request_Id": attendanceRequestId,
    };
  }

  // from map

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      clickAction: map["click_action"] ?? "FLUTTER_NOTIFICATION_CLICK",
      englishTitle: map["English_Title"],
      arabicTitle: map["Arabic_Title"],
      englishBody: map["English_Body"],
      arabicBody: map["Arabic_Body"],
      attendanceRequestId: map["Attendance_Request_Id"],
    );
  }
}
