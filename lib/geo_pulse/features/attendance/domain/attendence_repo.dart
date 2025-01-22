import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/error_handling/faliure.dart';

import '../data/models/attendance_data_model.dart';

abstract class AttendenceRepo {
  Future<Either<Faliure, String>> uploadrequestDoc(String fileName, File file);
  Future<Either<Faliure, void>> addAttendance(
      AttendanceDataModel model, String employeeEmail);
  Future<Either<Faliure, List<AttendanceDataModel>>> getAttendanceData(
      String employeeEmail);
  Future<Either<Faliure, List<AttendanceDataModel>>> getAllAttendanceData();

  Future<Either<Faliure, List<DateTime>>> getOfficialHolidays();
}
