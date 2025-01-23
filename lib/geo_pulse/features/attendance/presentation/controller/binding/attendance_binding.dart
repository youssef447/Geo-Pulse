/// Date: 6/10/2024
/// By:
/// binding for TrackingAttendanceController
import 'package:get/get.dart';

import '../../../data/data_source/attendence_remote_data_source.dart';
import '../../../data/repository/attendence_repo_impl.dart';
import '../controller/attendance_controller.dart';

class AttendanceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrackingAttendanceController(
        attendenceRepo: AttendenceRepoImpl(
            remoteDataSource: AttendenceRemoteDataSource())));
  }
}
