import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error_handling/faliure.dart';
import '../../../../features/attendance/data/models/attendance_data_model.dart';

import '../../domain/attendence_repo.dart';
import '../data_source/attendence_remote_data_source.dart';

class AttendenceRepoImpl extends AttendenceRepo {
  final AttendenceRemoteDataSource remoteDataSource;

  AttendenceRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Faliure, String>> uploadrequestDoc(
      String fileName, File file) async {
    try {
      String url = await remoteDataSource.uploadrequestDoc(fileName, file);
      return Right(url);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> addAttendance(
      AttendanceDataModel model, String employeeEmail) async {
    try {
      await remoteDataSource.addAttendance(model, employeeEmail);
      return Right(null);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, List<AttendanceDataModel>>> getAttendanceData(
      String employeeEmail) async {
    try {
      List<AttendanceDataModel> dataList =
          await remoteDataSource.getAttendanceData(employeeEmail);
      return Right(dataList);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, List<AttendanceDataModel>>>
      getAllAttendanceData() async {
    try {
      List<AttendanceDataModel> result = [];
      final map = await remoteDataSource.getAllAttendanceData();

      for (var data in map) {
        result.add(AttendanceDataModel.fromMap(data));
      }

      return Right(result);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, List<DateTime>>> getOfficialHolidays() async {
    try {
      List<DateTime> dataList = await remoteDataSource.getOfficialHolidays();
      return Right(dataList);
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }
}
