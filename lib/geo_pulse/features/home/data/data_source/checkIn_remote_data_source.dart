import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/strings.dart';
import '../models/tracking_model.dart';

class CheckinRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> toggleTookBreak(String email, bool tookBreak) async {
    await _firestore.collection(AppConstanst.trackingTime).doc(email).update({
      TrackingModel.fieldTookBreak: tookBreak,
    });
  }

  Future<TrackingModel?> loadState(String email) async {
    var respose =
        await _firestore.collection(AppConstanst.trackingTime).doc(email).get();
    if (respose.data() != null) {
      return TrackingModel.fromJson(respose.data()!);
    } else {
      return null;
    }
  }

  Future<void> startStopwatch(String email, TrackingModel trackingModel) async {
    await _firestore
        .collection(AppConstanst.trackingTime)
        .doc(email)
        .set(trackingModel.toJson());
  }

  Future<void> startTimer(
    String email,
    int currentDuration,
  ) async {
    _firestore.collection(AppConstanst.trackingTime).doc(email).update({
      TrackingModel.fieldCurrentDuration: currentDuration,
    });
  }

  Future<void> pauseStopwatch(
    String email,
    DateTime lastPausedTime,
    int totalPausedDuration,
  ) async {
    await _firestore.collection(AppConstanst.trackingTime).doc(email).update({
      TrackingModel.fieldIsPaused: true,
      TrackingModel.fieldIsRunning: false,
      TrackingModel.fieldLastPausedTime: lastPausedTime,
      TrackingModel.fieldTotalPausedDuration: totalPausedDuration,
    });
  }

  Future<void> resumeStopwatch(
    String email,
    int totalPausedDuration,
  ) async {
    await _firestore.collection(AppConstanst.trackingTime).doc(email).update({
      TrackingModel.fieldIsRunning: true,
      TrackingModel.fieldIsPaused: false,
      TrackingModel.fieldTotalPausedDuration: totalPausedDuration,
    });
  }

  Future<void> checkOut(String email) async {
    await _firestore.collection(AppConstanst.trackingTime).doc(email).update({
      TrackingModel.fieldIsRunning: false,
      TrackingModel.fieldIsPaused: false,
      TrackingModel.fieldCheckIn: false,
      TrackingModel.fieldCurrentDuration: 0,
    });
  }
}
