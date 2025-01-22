import 'package:dartz/dartz.dart';

import '../../../core/error_handling/faliure.dart';
import '../data/models/tracking_model.dart';

abstract class CheckInRepo {
  Future<Either<Faliure, void>> toggleTookBreak(String email, bool tookBreak);
  Future<Either<Faliure, TrackingModel?>> loadState(
    String email,
  );
  Future<Either<Faliure, void>> startStopwatch(
    String email,
    TrackingModel trackingModel,
  );
  Future<Either<Faliure, void>> startTimer(
    String email,
    int currentDuration,
  );
  Future<Either<Faliure, void>> pauseStopwatch(
    String email,
    DateTime lastPausedTime,
    int totalPausedDuration,
  );
  Future<Either<Faliure, void>> resumeStopwatch(
    String email,
    int totalPausedDuration,
  );
  Future<Either<Faliure, void>> checkOut(
    String email,
  );
}
