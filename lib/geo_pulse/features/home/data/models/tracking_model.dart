import 'package:cloud_firestore/cloud_firestore.dart';

class TrackingModel {
  Timestamp? checkInTime;
  bool? isRunning;
  bool? isPaused;
  int? currentDuration;
  bool? tookBreak;
  bool? checkIn;
  int? totalPausedDuration;

  TrackingModel({
    this.checkInTime,
    required this.isRunning,
    required this.isPaused,
    required this.currentDuration,
    required this.tookBreak,
    required this.checkIn,
    this.totalPausedDuration,
  });

  // Static constants for keys
  static const String fieldCheckInTime = 'Check_In_Time';
  static const String fieldIsRunning = 'Is_Running';
  static const String fieldIsPaused = 'Is_Paused';
  static const String fieldCurrentDuration = 'Current_Duration';
  static const String fieldTookBreak = 'Took_Break';
  static const String fieldCheckIn = 'Check_In';
  static const String fieldTotalPausedDuration = 'Total_Paused_Duration';
  static const String fieldLastPausedTime = 'Last_Paused_Time';

  // Convert from JSON
  factory TrackingModel.fromJson(Map<String, dynamic> json) {
    return TrackingModel(
      checkInTime: json[fieldCheckInTime],
      isRunning: json[fieldIsRunning] as bool?,
      isPaused: json[fieldIsPaused] as bool?,
      currentDuration: json[fieldCurrentDuration],
      tookBreak: json[fieldTookBreak] as bool?,
      checkIn: json[fieldCheckIn] as bool?,
      totalPausedDuration: json[fieldTotalPausedDuration],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      fieldCheckInTime: checkInTime,
      fieldIsRunning: isRunning,
      fieldIsPaused: isPaused,
      fieldCurrentDuration: currentDuration,
      fieldTookBreak: tookBreak,
      fieldCheckIn: checkIn,
      fieldTotalPausedDuration: totalPausedDuration,
    };
  }
}
