import 'package:get/get.dart';

import '../../../../../core/constants/enums.dart';
import '../../../../../core/constants/strings.dart';

import '../../../../users/logic/add_employee_controller.dart';
import '../../../../home/presentation/controller/controller/tracking_home_controller.dart';

import '../../../data/models/attendance_data_model.dart';
import '../../../domain/attendence_repo.dart';

/// handle logic fro Attendance page

class TrackingAttendanceController extends GetxController {
  final AttendenceRepo attendenceRepo;
  TrackingAttendanceController({required this.attendenceRepo});

  List<AttendanceDataModel> attendanceDataModel = [];
  List<AttendanceDataModel> allAttendanceDataModel = [];

  List<DateTime> holidayDates = [];

  @override
  onInit() async {
    super.onInit();
    getAttendanceData();
  }

  bool isGettingAttendances = false;

  //GET ATTENDANCE DATA
  Future<void> getAttendanceData() async {
    isGettingAttendances = true;
    attendanceDataModel = [];
    allAttendanceDataModel = [];
    final response = await attendenceRepo
        .getAttendanceData(Get.find<UserController>().employee!.email);
    isGettingAttendances = false;
    response.fold((faliure) {
      print('ehh ${faliure.message}');
    }, (dataList) {
      attendanceDataModel = dataList;
      allAttendanceDataModel = dataList;

      update([AppConstanst.attendanceList, AppConstanst.attendanceTable]);
    });
  }

// add attendence
  /// Adds an attendance record for the current employee to the Firestore database.
  ///
  /// This function stores the attendance data in the Firestore collection
  /// 'Attendances', appending it to the 'EmployeeAttendances' subcollection
  /// using the formatted date as the document ID.
  ///
  /// After successfully adding the record, it updates the local
  /// attendance data models and triggers UI updates for the attendance
  /// list, attendance table, and home page.
  Future<void> addAttendance(AttendanceDataModel model) async {
    // Get the email of the current employee
    final String employeeEmail = Get.find<UserController>().employee!.email;

    // Add the attendance record to Firestore
    final response = await attendenceRepo.addAttendance(model, employeeEmail);
    response.fold((faliure) {}, (_) {
      // Update local attendance data models
      attendanceDataModel.add(model);
      allAttendanceDataModel = attendanceDataModel;

      // Trigger UI updates
      update([AppConstanst.attendanceList, AppConstanst.attendanceTable]);
      Get.find<TrackingHomeController>().update([AppConstanst.home]);
    });
  }

  // approval requests filter month
  filterAttendanceByMonth(DateTime date) {
    attendanceDataModel = allAttendanceDataModel
        .where(
          (element) =>
              element.date.month == date.month &&
              element.date.year == date.year,
        )
        .toList();
    update([AppConstanst.attendanceList]);
  }

// check if absent
  /// Determines if the given [date] is a workday based on the given [workdays] list.
  bool isWorkday(DateTime date, List<String?> workdays) {
    final dayName = date.weekday == DateTime.sunday
        ? "Sunday"
        : date.weekday == DateTime.monday
            ? "Monday"
            : date.weekday == DateTime.tuesday
                ? "Tuesday"
                : date.weekday == DateTime.wednesday
                    ? "Wednesday"
                    : date.weekday == DateTime.thursday
                        ? "Thursday"
                        : date.weekday == DateTime.friday
                            ? "Friday"
                            : "Saturday";
    return workdays.contains(dayName.toLowerCase());
  }

  /// Retrieves the official holidays from the database.
  ///
  /// The function retrieves the official holidays from the 'Official_Holidays'
  /// collection in the Firestore database and stores them in the
  /// [holidayDates] list.
  Future<void> getOfficialHolidays() async {
    final response = await attendenceRepo.getOfficialHolidays();
    response.fold((faliure) {
      print(faliure.message);
    }, (dataList) {
      holidayDates = dataList;
    });
  }

  /// Returns the count of attendance records matching the specified status.

  /// Returns the count of records matching the specified status.
  int filterAttendanceStatusCount(int status) {
    int count = 0;
    switch (status) {
      case 0:
        // Count all attendance records
        count = allAttendanceDataModel.length;
        break;
      case 1:
        // Count records with 'Present' status
        count = allAttendanceDataModel
            .where((element) => element.status == AttendanceStatus.present)
            .length;
        break;
      case 2:
        // Count records with 'Late' status
        count = allAttendanceDataModel
            .where((element) => element.status == AttendanceStatus.late)
            .length;
        break;
      case 3:
        // Count records with 'Absent' status
        count = allAttendanceDataModel
            .where((element) => element.status == AttendanceStatus.absent)
            .length;
        break;
    }
    return count;
  }

  /// Filters attendance records based on the specified status.
  ///
  /// The [status] parameter can be one of the following values:
  ///
  /// - 0: All records
  /// - 1: 'Present'
  /// - 2: 'Late'
  /// - 3: 'Absent'
  /// - 4: 'Excused'
  void filterAttendanceStatus(int status) {
    if (status == 0) {
      // Show all attendance records
      attendanceDataModel = allAttendanceDataModel;
    } else {
      // Filter attendance records based on the specified status
      String statusName = status == 1
          ? AttendanceStatus.present.getName.toLowerCase()
          : status == 2
              ? AttendanceStatus.late.getName.toLowerCase()
              : AttendanceStatus.absent.getName.toLowerCase();

      attendanceDataModel = allAttendanceDataModel
          .where(
            (element) => element.status.getName.toLowerCase() == statusName,
          )
          .toList();
    }

    // Update the UI
    update([AppConstanst.attendanceList, AppConstanst.attendanceTable]);

    // Update the home page
    Get.find<TrackingHomeController>().update([
      AppConstanst.home,
    ]);
  }

  /// Filter attendance records based on the specified start date, status, total time, and time period.
  void filterAttendance(
      {DateTime? startDate,
      String? status,
      int? totalTimeMinutes,
      TimeFilter? period}) {
    attendanceDataModel = allAttendanceDataModel;
    int duration;
    int totalMinutes = totalTimeMinutes ?? 0;

    duration = period == TimeFilter.day
        ? totalMinutes * 24 * 60
        : period == TimeFilter.week
            ? totalMinutes * 7 * 24 * 60
            : period == TimeFilter.month
                ? totalMinutes * 30 * 24 * 60
                : period == TimeFilter.year
                    ? totalMinutes * 365 * 24 * 60
                    : totalMinutes * 24 * 60;

    if (startDate != null) {
      attendanceDataModel = attendanceDataModel
          .where((element) => (element.date.year == 2024 &&
              element.date.month == 10 &&
              element.date.day == 14))
          .toList();
    }

    if (totalTimeMinutes != null) {
      attendanceDataModel = attendanceDataModel
          .where((element) => element.totalTime?.inMinutes == duration)
          .toList();
    }

    if (status != null) {
      attendanceDataModel = attendanceDataModel
          .where((element) => element.status.getName == status)
          .toList();
    }
    update([AppConstanst.attendanceList, AppConstanst.attendanceTable]);
  }

  /// Resets the attendance filter to show all records.
  ///
  /// This function resets the `attendanceDataModel` to include all attendance
  /// records from `allAttendanceDataModel`, ensuring that no filters are applied.
  /// It then updates the UI components associated with the attendance list and table.
  void resetFiltertAttendance() {
    attendanceDataModel = allAttendanceDataModel; // Reset the filter
    update([
      AppConstanst.attendanceList,
      AppConstanst.attendanceTable
    ]); // Update the UI
  }

  /// Sorts the attendance data model based on the specified criterion.
  void sortAttendance(String? sortBy) {
    if (sortBy == SortFilter.totalTime.getName) {
      // Sort by total time, handling null values
      attendanceDataModel.sort((a, b) {
        if (a.totalTime == null && b.totalTime == null) return 0;
        if (a.totalTime == null) return 1;
        if (b.totalTime == null) return -1;
        return b.totalTime!.compareTo(a.totalTime!);
      });
    } else {
      // Sort by date
      attendanceDataModel.sort((a, b) => b.date.compareTo(a.date));
    }
    // Update the UI
    update([AppConstanst.attendanceList, AppConstanst.attendanceTable]);
  }

  /// Searches attendance records by status name and updates the UI accordingly.
  void searchAttendance(String query) {
    // Filter attendance records by status name
    attendanceDataModel = allAttendanceDataModel
        .where((element) =>
            element.status.getName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    // Update the UI
    update([AppConstanst.attendanceList, AppConstanst.attendanceTable]);
    Get.find<TrackingHomeController>().update([
      AppConstanst.home,
    ]);
  }

  //***************************************************END DASHBOARD *****************************************
//reset resources
}
