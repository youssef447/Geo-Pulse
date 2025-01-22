// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import '../../../../core/error_handling/faliure.dart';
import '../../../../features/home/data/models/tracking_model.dart';

import '../../domain/checkIn_repo.dart';
import '../data_source/checkIn_remote_data_source.dart';

class CheckinRepoImpl extends CheckInRepo {
  final CheckinRemoteDataSource checkinRemoteDataSource;
  CheckinRepoImpl({
    required this.checkinRemoteDataSource,
  });

  @override
  Future<Either<Faliure, void>> checkOut(String email) async {
    try {
      await checkinRemoteDataSource.checkOut(email);

      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, TrackingModel?>> loadState(String email) async {
    try {
      TrackingModel? trackingModel =
          await checkinRemoteDataSource.loadState(email);

      return Right(trackingModel);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> pauseStopwatch(
      String email, DateTime lastPausedTime, int totalPausedDuration) async {
    try {
      await checkinRemoteDataSource.pauseStopwatch(
          email, lastPausedTime, totalPausedDuration);
      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> resumeStopwatch(
      String email, int totalPausedDuration) async {
    try {
      await checkinRemoteDataSource.resumeStopwatch(email, totalPausedDuration);
      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> startStopwatch(
      String email, TrackingModel trackingModel) async {
    try {
      await checkinRemoteDataSource.startStopwatch(email, trackingModel);
      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> startTimer(
      String email, int currentDuration) async {
    try {
      await checkinRemoteDataSource.startTimer(email, currentDuration);
      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> toggleTookBreak(
      String email, bool tookBreak) async {
    try {
      await checkinRemoteDataSource.toggleTookBreak(email, tookBreak);
      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }
}
