// This file provides the `TrackingDashboardController` which is responsible for managing the state and data of the dashboard.
// It handles fetching attendance and request data, as well as defining dashboard categories with corresponding colors.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/core/constants/strings.dart';
import 'package:geo_pulse/geo_pulse/core/helpers/date_time_helper.dart';
import 'package:geo_pulse/geo_pulse/features/attendance/data/models/attendance_data_model.dart';
import 'package:geo_pulse/geo_pulse/features/dashboard/my_dashboard/data/models/chart_data.dart';
import 'package:geo_pulse/geo_pulse/features/request/data/models/request_model.dart';
import 'package:geo_pulse/geo_pulse/features/users/logic/add_employee_controller.dart';

import '../../../../../core/constants/enums.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../attendance/domain/attendence_repo.dart';
import '../../../../request/domain/request_repo.dart';
import '../../data/enums/dashboard_category.dart';

class TrackingDashboardController extends GetxController {
  final AttendenceRepo attendenceRepo;
  final RequestRepo requestRepo;

  TrackingDashboardController(
      {required this.attendenceRepo, required this.requestRepo});
  bool loading = true;
  String? errorMessage;

  /// Flag to determine whether data should be shown or not.
  bool? showData = true;

  /// Initializes the controller and fetches initial dashboard data.
  @override
  void onInit() async {
    super.onInit();

    await getDashboardData();
  }

  // List to hold attendance data fetched from the logged-in user's data.
  List<AttendanceDataModel> attendanceData = [];

  // List to hold request data fetched from the logged-in user's data.
  List<RequestModel> requestsData = [];

  /// Fetches attendance data from the logged-in user's details.

  Future<void> getAttendanceData() async {
    final response = await attendenceRepo
        .getAttendanceData(Get.find<UserController>().employee!.email);

    response.fold((faliure) {
      errorMessage = faliure.message;
    }, (dataList) {
      attendanceData = dataList;

      getLateHistoryChartData();
      getTotalPresentDays();
      getTotalLateDays();
      getTotalAbsentDays();
      getVacationCredit();
    });
  }

  List<ChartData> requestsChartData = [];

  /// Fetches request data from the logged-in user's details.
  Future<void> getRequestsData() async {
    final response = await requestRepo
        .getRequests(Get.find<UserController>().employee!.email);
    response.fold((failure) {
      errorMessage = failure.message;
    }, (requests) {
      requestsData = requests;
      getRequestsChartData();
    });
  }

  /// get chart data
  /// Calculates the number of approved, pending and rejected requests and stores
  ///  them in a list of [ChartData] for chart display.
  void getRequestsChartData() {
    int approvedRequests = 0;
    int pendingRequests = 0;
    int rejectedRequests = 0;

    for (RequestModel request in requestsData) {
      if (request.requestStatus == RequestStatus.approved) {
        approvedRequests++;
      } else if (request.requestStatus == RequestStatus.pending) {
        pendingRequests++;
      } else {
        rejectedRequests++;
      }
    }

    requestsChartData = [
      ChartData(
        xAxisLabel: RequestStatus.approved.getName,
        xAxisLabelArabic: AppConstanst.acceptedArabic,
        yAxisLabel: approvedRequests,
        chartItemColor: AppColors.lightGreen,
      ),
      ChartData(
        xAxisLabel: RequestStatus.pending.getName,
        xAxisLabelArabic: AppConstanst.pendingArabic,
        yAxisLabel: pendingRequests,
        chartItemColor: AppColors.orange,
      ),
      ChartData(
        xAxisLabel: RequestStatus.rejected.getName,
        xAxisLabelArabic: AppConstanst.rejectedArabic,
        yAxisLabel: rejectedRequests,
        chartItemColor: AppColors.darkRed,
      ),
    ];
  }

  /// A map defining dashboard categories with their respective colors.
  final Map<DashboardCategory, Color> dashboardTitles = {
    DashboardCategory.present: AppColors.lightGreen,
    DashboardCategory.late: AppColors.orange,
    DashboardCategory.absent: AppColors.darkRed,
    DashboardCategory.vacationCredit: AppColors.yellow,
  };

  getLateHistoryChartData() {
    for (var element in attendanceData) {
      if (element.status == AttendanceStatus.late) {
        if (lateHistoryCount.containsKey(element.date.month)) {
          lateHistoryCount[element.date.month] =
              lateHistoryCount[element.date.month]! + 1;
        } else {
          lateHistoryCount[element.date.month] = 1;
        }
        if (lateMinutesHistory.containsKey(element.date.month)) {
          lateMinutesHistory[element.date.month] =
              lateMinutesHistory[element.date.month]! +
                  getLateMinutes(element.date);
        } else {
          lateMinutesHistory[element.date.month] = getLateMinutes(element.date);
        }
      }
    }
    lateHistoryChartData = lateMonthlyCountChart();
  }

  int getLateMinutes(DateTime date) {
    final defaultTime = DateTime(date.year, date.month, date.day, 8, 0);
    return date.difference(defaultTime).inMinutes;
  }

  List<ChartData> lateMonthlyCountChart() {
    return List.generate(12, ((index) {
      return ChartData(
        xAxisLabel: DateTimeHelper.months[index],
        xAxisLabelArabic:
            DateTimeHelper.monthsMap[DateTimeHelper.months[index]]!,
        yAxisLabel: lateHistoryCount[index + 1] ?? 0,
      );
    }));
  }

  List<ChartData> lateMonthlyMinsChart() {
    return List.generate(12, ((index) {
      return ChartData(
        xAxisLabel: DateTimeHelper.months[index],
        xAxisLabelArabic:
            DateTimeHelper.monthsMap[DateTimeHelper.months[index]]!,
        yAxisLabel: lateMinutesHistory[index + 1] ?? 0,
      );
    }));
  }

  /// Fetches all necessary data for the dashboard, including attendance and requests.
  Future<void> getDashboardData() async {
    await Future.wait([
      getAttendanceData(),
      getRequestsData(),
    ]);
    loading = false;

    update([AppConstanst.dashboard]);
  }

  int barChartIndex = 0;

  int intervalBarChart = 1;
  List<ChartData> lateHistoryChartData = [];
  Map<int, int> lateHistoryCount = {};
  Map<int, int> lateMinutesHistory = {};

  /// Switches the data and interval of the late history bar chart based on
  void toggleLateHistoryChart(index) {
    // Update the current bar chart index
    barChartIndex = index;

    if (barChartIndex == 0) {
      lateHistoryChartData = lateMonthlyCountChart();
      intervalBarChart = 1; // Set interval for occurrence count
    } else {
      intervalBarChart = 50; // Set interval for late minutes
      lateHistoryChartData = lateMonthlyMinsChart();
    }

    // Update the late history chart data

    // Trigger update on the dashboard bar chart
    update([AppConstanst.barChart]);
  }

  //*****************************************DASHBOARD CARD VALUES*****************************************
  /// Calculates the total number of days when the employee was present.
  ///
  final dashboardCardValues = [];
  final dashboardCardSubtitles = [];
  getTotalPresentDays() {
    int totalDays = 0;
    for (AttendanceDataModel attendance in attendanceData) {
      if (attendance.status == AttendanceStatus.present) {
        totalDays++;
      }
    }
    dashboardCardValues.add(totalDays);
    dashboardCardSubtitles.add(AppConstanst.totalDays.tr);
  }

  /// Calculates the total number of days when the employee was absent.
  getTotalAbsentDays() {
    int totalDays = 0;
    // Iterate over the attendance records and count the number of absent days
    for (var attendance in attendanceData) {
      if (attendance.status == AttendanceStatus.absent) {
        totalDays++;
      }
    }

    // Add the total count and subtitle to the dashboard card
    dashboardCardValues.add(totalDays);
    dashboardCardSubtitles.add(AppConstanst.totalDays.tr);
  }

  /// Calculates the total number of days when the employee was late.
  getTotalLateDays() {
    int totalDays = 0;

    // Iterate over the attendance records and count the number of late days
    for (var attendance in attendanceData) {
      if (attendance.status == AttendanceStatus.late) {
        totalDays++;
      }
    }

    // Add the total count and subtitle to the dashboard card
    dashboardCardValues.add(totalDays);
    dashboardCardSubtitles.add(AppConstanst.totalDays.tr);
  }

  /// Calculates the total number of vacation credit days the employee has.
  getVacationCredit() {
    int totalDays = 45;

    // Iterate over the attendance records and subtract the number of absent days
    for (var attendance in attendanceData) {
      if (attendance.status == AttendanceStatus.absent) {
        totalDays--;

        if (totalDays == 0) {
          break;
        }
      }
    }

    // Add the total count and subtitle to the dashboard card
    dashboardCardValues.add(totalDays);
    dashboardCardSubtitles.add(AppConstanst.totalDays.tr);
  }
}
