import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/core/helpers/date_time_helper.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_colors.dart';
import 'package:geo_pulse/geo_pulse/features/attendance/data/models/attendance_data_model.dart';
import 'package:geo_pulse/geo_pulse/features/attendance/domain/attendence_repo.dart';
import 'package:geo_pulse/geo_pulse/features/dashboard/my_dashboard/data/models/chart_data.dart';
import 'package:geo_pulse/geo_pulse/features/request/data/models/request_model.dart';
import 'package:geo_pulse/geo_pulse/features/request/domain/request_repo.dart';
import 'package:geo_pulse/geo_pulse/features/request_type/data/models/request_type_model.dart';
import 'package:geo_pulse/geo_pulse/features/request_type/presentation/controller/request_types_controller.dart';
import 'package:geo_pulse/geo_pulse/features/users/logic/add_employee_controller.dart';
import '../../../../../core/constants/enums.dart';
import '../../../../users/logic/add_department_controller.dart';
import '../../../../../core/constants/strings.dart';

/// Objectives: This file is responsible for providing the HR dashboard controller that manages the state of the HR screen.

class TrackingHRController extends GetxController {
  final AttendenceRepo attendenceRepo;
  final RequestRepo requestsRepo;

  TrackingHRController(
      {required this.attendenceRepo, required this.requestsRepo});
  // ********** HR Dashboard **********
  bool loading = true;
  @override
  onInit() async {
    super.onInit();

    await Future.wait([
      Get.find<UserController>().getAllEmployees(),
      Get.find<AddDepartmentController>().getAllDepartments(),
    ]);
    await getAllAttandance();

    await getRequestsChartData(null);
    getRequestsHistoryBarChartData();
    getRequestTypesBarChartData();
    loading = false;
    update([AppConstanst.dashboard]);
  }

  Map<int, int> absenceHistoryCount = {};
  Map<int, int> lateHistoryCountHr = {};

  List<AttendanceDataModel> absenceHistory = [];
  List<AttendanceDataModel> lateHistory = [];
  List<AttendanceDataModel> allUsersAttendance = [];
  List<AttendanceDataModel> allUsersAttendanceWithoutFilter = [];
  List<ChartData> requestTypesChartData = [];

  List<ChartData> absenceHistoryBarChartData = [];
  List<ChartData> lateHistoryCountBarChartDataHr = [];
  List<ChartData> lateHistoryMinutesBarChartDataHr = [];
  List<ChartData> requestsCircularChartData = [];
  Map<String, int> requestTypesCount = {};
  Map<int, int> requestHistoryCount = {};
  List<ChartData> requestsHistoryBarChartData = [];

  /// Retrieves all attendance records for all employees from the database.
  ///
  /// This function iterates over the list of employees retrieved from the
  /// database and for each employee, it retrieves all attendance records from
  /// the database. It then adds the attendance records to the [allUsersAttendance]
  /// list and if the attendance status is [AttendanceStatus.absent], it adds the
  /// record to the [absenceHistory] list and updates the [absenceHistoryCount]
  /// map.
  ///
  /// Finally, it calls [getAbsenceHistoryBarChartData] to populate
  /// [absenceHistoryBarChartData] with the absence history data for the current
  /// year.
  Future<void> getAllAttandance([String? departmentid]) async {
    absenceHistory = [];
    lateHistory = [];

    absenceHistoryCount = {};
    lateHistoryCountHr = {};

    if (allUsersAttendance.isEmpty) {
      for (var emailDoc in Get.find<UserController>().allnNewEmployees!) {
        String email = emailDoc.email;
        if (departmentid != null &&
            Get.find<UserController>().getLocaleEmployee(email).departmentid !=
                departmentid) {
          continue;
        }

        // Get requests for each email
        final response = await attendenceRepo.getAllAttendanceData();
        response.fold((faliure) {}, (attendancees) {
          allUsersAttendance = attendancees;
          allUsersAttendanceWithoutFilter = attendancees;

          for (var model in attendancees) {
            if (model.status == AttendanceStatus.absent) {
              absenceHistory.add(model);
              if (absenceHistoryCount[model.date.month] == null) {
                absenceHistoryCount[model.date.month] = 1;
              } else {
                absenceHistoryCount[model.date.month] =
                    absenceHistoryCount[model.date.month]! + 1;
              }
            }
            if (model.status == AttendanceStatus.late) {
              lateHistory.add(model);
              if (lateHistoryCountHr[model.date.month] == null) {
                lateHistoryCountHr[model.date.month] = 1;
              } else {
                lateHistoryCountHr[model.date.month] =
                    lateHistoryCountHr[model.date.month]! + 1;
              }
            }
          }
        });
      }
    } else {
      if (departmentid != null) {
        allUsersAttendance = allUsersAttendanceWithoutFilter
            .where((element) => element.id == departmentid)
            .toList();
      }

      for (AttendanceDataModel model in allUsersAttendance) {
        if (model.status == AttendanceStatus.absent) {
          absenceHistory.add(model);
          if (absenceHistoryCount[model.date.month] == null) {
            absenceHistoryCount[model.date.month] = 1;
          } else {
            absenceHistoryCount[model.date.month] =
                absenceHistoryCount[model.date.month]! + 1;
          }
        }
        if (model.status == AttendanceStatus.late) {
          lateHistory.add(model);
          if (lateHistoryCountHr[model.date.month] == null) {
            lateHistoryCountHr[model.date.month] = 1;
          } else {
            lateHistoryCountHr[model.date.month] =
                lateHistoryCountHr[model.date.month]! + 1;
          }
        }
      }
    }
    getAbsenceHistoryBarChartData();
    getLateHistoryCountBarChartData();
    getLateHistoryMinuteBarChartData();
  }

  /// Populates `absenceHistoryBarChartData` with the absence history data for
  /// the current year. The data is a list of [ChartData] objects, where each
  /// object contains the month as the x-axis label and the number of absences
  /// as the y-axis label.
  void getAbsenceHistoryBarChartData() {
    selectedTimeAbsenceFilter == TimeFilter.year
        ? absenceHistoryBarChartData = yearlyChartHistory(absenceHistory)
        : selectedTimeAbsenceFilter == TimeFilter.week
            ? absenceHistoryBarChartData = weeklyChart(absenceHistory, false)
            : absenceHistoryBarChartData = monthlyChart(absenceHistory, false);

    update([AppConstanst.dashboard]);
  }

  void getLateHistoryCountBarChartData() {
    selectedTimeLateCountFilter == TimeFilter.year
        ? lateHistoryCountBarChartDataHr = yearlyChartHistory(lateHistory)
        : selectedTimeLateCountFilter == TimeFilter.week
            ? lateHistoryCountBarChartDataHr = weeklyChart(lateHistory, false)
            : lateHistoryCountBarChartDataHr = monthlyChart(lateHistory);
    update([AppConstanst.dashboard]);
  }

  /// Generates chart data representing the minutes of late occurrences.

  void getLateHistoryMinuteBarChartData() {
    selectedTimeLateMinutesFilter == TimeFilter.year
        ? lateHistoryMinutesBarChartDataHr =
            yearlyChartHistory(lateHistory, true)
        : selectedTimeLateMinutesFilter == TimeFilter.week
            ? lateHistoryMinutesBarChartDataHr = weeklyChart(lateHistory, true)
            : lateHistoryMinutesBarChartDataHr = monthlyChart(lateHistory);

    update([AppConstanst.dashboard]);
  }

  /// Generates monthly chart data for the number of late occurrences.
  ///
  /// The data is filtered by the current year and then grouped by month.
  /// The x-axis labels are the month names in English and Arabic.
  /// The y-axis labels are the total number of late occurrences for each month.
  ///
  List<ChartData> monthlyChart(List<AttendanceDataModel> attendanceModel,
      [bool? mins]) {
    return List.generate(12, ((index) {
      return ChartData(
        xAxisLabel: DateTimeHelper.months[index],
        xAxisLabelArabic:
            DateTimeHelper.monthsMap[DateTimeHelper.months[index]]!,
        yAxisLabel: mins ?? false
            ? getLateHistoryMinutes(
                attendanceModel
                    .where((element) =>
                        DateTime.now().year == element.date.year &&
                        element.date.month == index + 1)
                    .toList(),
              )
            : attendanceModel
                .where((element) =>
                    DateTime.now().year == element.date.year &&
                    element.date.month == index + 1)
                .toList()
                .length,
      );
    }));
  }

  List<ChartData> requestsMonthlyChart() {
    return List.generate(12, ((index) {
      return ChartData(
        xAxisLabel: DateTimeHelper.months[index],
        xAxisLabelArabic:
            DateTimeHelper.monthsMap[DateTimeHelper.months[index]]!,
        yAxisLabel: requestHistoryCount[index + 1] ?? 0,
      );
    }));
  }

  /// Generates yearly chart data for the number of late/absence occurrences.
  ///
  /// The data is filtered by year and then grouped by year.
  /// The x-axis labels are the year numbers in English and Arabic.
  /// The y-axis labels are the total number of late occurrences for each year.
  List<ChartData> yearlyChartHistory(List<AttendanceDataModel> attendanceModel,
      [bool? mins]) {
    return List.generate(4, ((year) {
      return ChartData(
        xAxisLabel: (DateTime.now().year - year).toString(),
        xAxisLabelArabic:
            DateTimeHelper.formatInt((DateTime.now().year - year)),
        yAxisLabel: mins ?? false
            ? getLateHistoryMinutes(attendanceModel
                .where((element) =>
                    DateTime.now().year - year == element.date.year)
                .toList())
            : attendanceModel
                .where((e) => DateTime.now().year - year == e.date.year)
                .toList()
                .length,
      );
    }));
  }

  List<ChartData> yearlyChartRequestHistory([bool? mins]) {
    return List.generate(4, ((year) {
      return ChartData(
        xAxisLabel: (DateTime.now().year - year).toString(),
        xAxisLabelArabic:
            DateTimeHelper.formatInt((DateTime.now().year - year)),
        yAxisLabel: allRequests
            .where((e) => DateTime.now().year - year == e.requestDate.year)
            .toList()
            .length,
      );
    }));
  }

  /// Generates weekly absence history bar chart data.

  List<ChartData> weeklyChart(
      List<AttendanceDataModel> attendanceModel, bool ifMinutes) {
    List<String> lastCurrentMonths = [
      DateTimeHelper.monthNames[
          DateTime.now().month == 1 ? 12 : DateTime.now().month - 1]!,
      DateTimeHelper.monthNames[DateTime.now().month]!
    ];
    List<ChartData> historyBarChartData = [
      // First week of the last month
      ChartData(
          xAxisLabel: '${lastCurrentMonths[0]} Week 1',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[0]]} الاسبوع الاول',
          yAxisLabel: ifMinutes
              ? getLateHistoryMinutes(attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[0] &&
                      element.date.day <= 7)
                  .toList())
              : attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[0] &&
                      element.date.day <= 7)
                  .length),
      // Second week of the last month
      ChartData(
          xAxisLabel: '${lastCurrentMonths[0]} Week 2',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[0]]} الاسبوع الثاني',
          yAxisLabel: ifMinutes
              ? getLateHistoryMinutes(attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[0] &&
                      element.date.day <= 14 &&
                      element.date.day >= 8)
                  .toList())
              : attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[0] &&
                      element.date.day <= 14 &&
                      element.date.day >= 8)
                  .length),
      // Third week of the last month
      ChartData(
          xAxisLabel: '${lastCurrentMonths[0]} Week 3',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[0]]} الاسبوع الثالث',
          yAxisLabel: ifMinutes
              ? getLateHistoryMinutes(attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[0] &&
                      element.date.day <= 21 &&
                      element.date.day >= 15)
                  .toList())
              : attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[0] &&
                      element.date.day <= 21 &&
                      element.date.day >= 15)
                  .length),
      // Fourth week of the last month
      ChartData(
          xAxisLabel: '${lastCurrentMonths[0]} Week 4',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[0]]} الاسبوع الرابع',
          yAxisLabel: ifMinutes
              ? getLateHistoryMinutes(attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[0] &&
                      element.date.day <= 28 &&
                      element.date.day >= 22)
                  .toList())
              : attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[0] &&
                      element.date.day <= 28 &&
                      element.date.day >= 22)
                  .length),
      // fifth week of the current month
      ChartData(
          xAxisLabel: '${lastCurrentMonths[0]} Week 5',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[0]]} الاسبوع الخامس',
          yAxisLabel: ifMinutes
              ? getLateHistoryMinutes(attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[0] &&
                      element.date.day >= 29)
                  .toList())
              : attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[0] &&
                      element.date.day >= 29)
                  .length),
      // First week of the current month
      ChartData(
          xAxisLabel: '${lastCurrentMonths[1]} Week 1',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[0]]} الاسبوع الاول',
          yAxisLabel: ifMinutes
              ? getLateHistoryMinutes(attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[1] &&
                      element.date.day <= 7)
                  .toList())
              : attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[1] &&
                      element.date.day <= 7)
                  .length),
      // Second week of the current month
      ChartData(
          xAxisLabel: '${lastCurrentMonths[1]} Week 2',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[1]]} الاسبوع الثاني',
          yAxisLabel: ifMinutes
              ? getLateHistoryMinutes(attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[1] &&
                      element.date.day <= 14 &&
                      element.date.day >= 8)
                  .toList())
              : attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[1] &&
                      element.date.day <= 14 &&
                      element.date.day >= 8)
                  .length),
      // Third week of the current month
      ChartData(
          xAxisLabel: '${lastCurrentMonths[1]} Week 3',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[1]]} الاسبوع الثالث',
          yAxisLabel: ifMinutes
              ? getLateHistoryMinutes(attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[1] &&
                      element.date.day <= 21 &&
                      element.date.day >= 15)
                  .toList())
              : attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[1] &&
                      element.date.day <= 21 &&
                      element.date.day >= 15)
                  .length),
      // Fourth week of the current month
      ChartData(
          xAxisLabel: '${lastCurrentMonths[1]} Week 4',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[1]]} الاسبوع الرابع',
          yAxisLabel: ifMinutes
              ? getLateHistoryMinutes(attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[1] &&
                      element.date.day <= 28 &&
                      element.date.day >= 22)
                  .toList())
              : attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[1] &&
                      element.date.day <= 28 &&
                      element.date.day >= 22)
                  .length),
      // Fifth week of the current month
      ChartData(
          xAxisLabel: '${lastCurrentMonths[1]} Week 5',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[1]]} الاسبوع الخامس',
          yAxisLabel: ifMinutes
              ? getLateHistoryMinutes(attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[1] &&
                      element.date.day >= 29)
                  .toList())
              : attendanceModel
                  .where((element) =>
                      DateTimeHelper.getMonthNameFromDateTime(element.date) ==
                          lastCurrentMonths[1] &&
                      element.date.day >= 29)
                  .length),
    ];

    return historyBarChartData.toList();
  }

  /// Calculates the total or extreme late minutes from a list of attendance data.
  ///
  /// The function determines the total late minutes for the given attendance records.
  /// If no filter is applied, it accumulates all late minutes. If the filter is set to
  /// `AverageFilter.max`, it finds the maximum late minutes in the list. For `AverageFilter.min`,
  /// it finds the minimum late minutes. The late minutes are calculated as the difference
  /// between the oncoming time and 8:00 AM.
  int getLateHistoryMinutes(List<AttendanceDataModel> attendanceModel) {
    int lateMinutes = 0;

    for (var element in attendanceModel) {
      lateMinutes += DateTimeHelper.formatTimeOfDayToDateTime(
              element.oncomingTime!, element.date)
          .difference(DateTime(
            element.date.year,
            element.date.month,
            element.date.day,
            8,
            0,
          ))
          .inMinutes;
    }
    return lateMinutes == 1000 ? 0 : lateMinutes;
  }

  List<RequestModel> allRequests = [];

  /// Calculates the number of approved, pending and rejected requests and stores
  ///  them in a list of [ChartData] for chart display.
  int totalRequestCount = 0;

  /// Calculates the number of approved, pending and rejected requests and stores
  ///  them in a list of [ChartData] for chart display.
  ///
  /// If a department is provided, it will only count the requests that belong
  /// to that department.
  ///
  /// If a date range is provided, it will only count the requests that fall
  /// within that range.
  ///
  /// [department] The department to filter by.
  Future<void> getRequestsChartData(
    String? department,
  ) async {
    // Reset the counts

    int approvedRequests = 0;
    int pendingRequests = 0;
    int rejectedRequests = 0;
    totalRequestCount = 0;
    requestTypesCount = {};
    requestHistoryCount = {};
    final result = await requestsRepo.getAllRequests(department);
    result.fold((e) {}, (res) {
      allRequests = res;
      // Loop through all requests
      for (RequestModel request in res) {
        totalRequestCount++;
        //  count all requests
        if (request.requestStatus == RequestStatus.approved) {
          approvedRequests++;
        } else if (request.requestStatus == RequestStatus.pending) {
          pendingRequests++;
        } else {
          rejectedRequests++;
        }

        // Count the requests by type
        if (requestTypesCount[request.requestType.englishName] == null) {
          requestTypesCount[request.requestType.englishName] = 1;
        } else {
          requestTypesCount[request.requestType.englishName] =
              requestTypesCount[request.requestType.englishName]! + 1;
        }

        // Count the requests by month
        if (requestHistoryCount[request.requestDate.month] == null) {
          requestHistoryCount[request.requestDate.month] = 1;
        } else {
          requestHistoryCount[request.requestDate.month] =
              requestHistoryCount[request.requestDate.month]! + 1;
        }
      }

      // Create the chart data
      requestsCircularChartData = [
        ChartData(
          xAxisLabel: RequestStatus.approved.getName,
          yAxisLabel: approvedRequests,
          xAxisLabelArabic: AppConstanst.acceptedArabic,
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
    });
  }

/*   /// Gets the request types for the HR approval requests.
  ///
  /// This method fetches the request types from the FireStore database and
  /// populates the [requestTypesChartData] list with the count of each request
  /// type. The list is sorted in descending order by the count of each request
  /// type.
  void getHRRequestTypes() {
    /// Create an empty list to store the chart data.

    requestTypesChartData = [];

    /// Get the request types and their counts from the FireStore database.
    var mapEntries = requestTypesCount.entries.toList();
    mapEntries.sort((a, b) => b.value.compareTo(a.value));
    Map<String, int> sortedMap = Map.fromEntries(mapEntries);
    List<String> label = sortedMap.keys.toList();
    List<int> values = sortedMap.values.toList();

    /// Create a list of colors to be used for the chart.
    List<Color> colors = [
      AppColors.primary,
      AppColors.grey,
      AppColors.black,
      AppColors.secondaryPrimary,
    ];

    /// If the list of request types is empty, add an empty chart data item.
    if (Get.find<RequestTypeController>().requestTypeModels.isEmpty) {
      requestTypesChartData.add(ChartData(
        xAxisLabel: AppConstanst.transaction,
        xAxisLabelArabic: AppConstanst.transactionArabic,
        yAxisLabel: 0,
        chartItemColor: colors[0],
      ));
    } else if (label.isEmpty) {
      requestTypesChartData.add(ChartData(
        xAxisLabel:
            Get.find<RequestTypeController>().requestTypeModels[0].englishName,
        xAxisLabelArabic:
            Get.find<RequestTypeController>().requestTypeModels[0].arabicName,
        yAxisLabel: 0,
        chartItemColor: colors[0],
      ));
    } else {
      /// Iterate over the request types and add a chart data item for each
      /// request type. The list is limited to the first 4 request types.
      for (int i = 0; i < (label.length < 4 ? label.length : 4); i++) {
        requestTypesChartData.add(
          ChartData(
            xAxisLabel: label[i].capitalize!,
            xAxisLabelArabic: label[i] == AppConstanst.transaction
                ? AppConstanst.transactionArabic
                : getRequestTypeinArabic(label[i]),
            yAxisLabel: values[i],
            chartItemColor: colors[i],
          ),
        );
      }
    }
  } */

  String getRequestTypeinArabic(String requestTypeName) {
    RequestTypeModel requestTypeModel = Get.find<RequestTypeController>()
        .requestTypeModels
        .firstWhere((element) =>
            element.englishName.toLowerCase() == requestTypeName.toLowerCase());

    return requestTypeModel.arabicName;
  }

  /// Populates `requestTypesChartData` with the count of each request type.
  void getRequestTypesBarChartData() {
    List<RequestTypeModel> requestTypeModels =
        Get.find<RequestTypeController>().requestTypeModels;
    requestTypesChartData = [];

    for (int i = 0; i < requestTypeModels.length; i++) {
      requestTypesChartData.add(
        ChartData(
          xAxisLabel: requestTypeModels[i].englishName,
          xAxisLabelArabic: requestTypeModels[i].arabicName,
          yAxisLabel:
              requestTypesCount[requestTypeModels[i].englishName] == null
                  ? 0
                  : requestTypesCount[requestTypeModels[i].englishName]!,
        ),
      );
    }
  }

  void getRequestsHistoryBarChartData() {
    selectedTimeRequestFilter == TimeFilter.year
        ? requestsHistoryBarChartData = yearlyChartRequestHistory()
        : selectedTimeRequestFilter == TimeFilter.week
            ? requestsHistoryBarChartData = requestWeeklyChart()
            : requestsHistoryBarChartData = requestsMonthlyChart();
  }

  /// Generates weekly chart data for the number of  requests.
  List<ChartData> requestWeeklyChart() {
    List<String> lastCurrentMonths = [
      DateTimeHelper.monthNames[
          DateTime.now().month == 1 ? 12 : DateTime.now().month - 1]!,
      DateTimeHelper.monthNames[DateTime.now().month]!
    ];

    List<ChartData> requestsHistoryBarChartData = [
      ChartData(
          xAxisLabel: '${lastCurrentMonths[0]} Week 1',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[0]]} الاسبوع الاول',
          yAxisLabel: allRequests
              .where((element) =>
                  DateTimeHelper.getMonthNameFromDateTime(
                          element.requestDate) ==
                      lastCurrentMonths[0] &&
                  element.requestDate.day <= 7)
              .length),
      ChartData(
          xAxisLabel: '${lastCurrentMonths[0]} Week 2',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[0]]} الاسبوع الثاني',
          yAxisLabel: allRequests
              .where((element) =>
                  DateTimeHelper.getMonthNameFromDateTime(
                          element.requestDate) ==
                      lastCurrentMonths[0] &&
                  element.requestDate.day <= 14 &&
                  element.requestDate.day >= 8)
              .length),
      ChartData(
          xAxisLabel: '${lastCurrentMonths[0]} Week 3',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[0]]} الاسبوع الثالث',
          yAxisLabel: allRequests
              .where((element) =>
                  DateTimeHelper.getMonthNameFromDateTime(
                          element.requestDate) ==
                      lastCurrentMonths[0] &&
                  element.requestDate.day <= 21 &&
                  element.requestDate.day >= 15)
              .length),
      ChartData(
          xAxisLabel: '${lastCurrentMonths[0]} Week 4',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[0]]} الاسبوع الرابع',
          yAxisLabel: allRequests
              .where((element) =>
                  DateTimeHelper.getMonthNameFromDateTime(
                          element.requestDate) ==
                      lastCurrentMonths[0] &&
                  element.requestDate.day <= 31 &&
                  element.requestDate.day >= 22)
              .length),
      ChartData(
          xAxisLabel: '${lastCurrentMonths[1]} Week 1',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[1]]} الاسبوع الاول',
          yAxisLabel: allRequests
              .where((element) =>
                  DateTimeHelper.getMonthNameFromDateTime(
                          element.requestDate) ==
                      lastCurrentMonths[1] &&
                  element.requestDate.day <= 7)
              .length),
      ChartData(
          xAxisLabel: '${lastCurrentMonths[1]} Week 2',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[1]]} الاسبوع الثاني',
          yAxisLabel: allRequests
              .where((element) =>
                  DateTimeHelper.getMonthNameFromDateTime(
                          element.requestDate) ==
                      lastCurrentMonths[1] &&
                  element.requestDate.day <= 14 &&
                  element.requestDate.day >= 8)
              .length),

      ChartData(
          xAxisLabel: '${lastCurrentMonths[1]} Week 3',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[1]]} الاسبوع الثالث',
          yAxisLabel: allRequests
              .where((element) =>
                  DateTimeHelper.getMonthNameFromDateTime(
                          element.requestDate) ==
                      lastCurrentMonths[1] &&
                  element.requestDate.day <= 21 &&
                  element.requestDate.day >= 15)
              .length),
      // Fourth week of the last month
      ChartData(
          xAxisLabel: '${lastCurrentMonths[1]} Week 4',
          xAxisLabelArabic:
              '${DateTimeHelper.monthsMap[lastCurrentMonths[1]]} الاسبوع الرابع',
          yAxisLabel: allRequests
              .where((element) =>
                  DateTimeHelper.getMonthNameFromDateTime(
                          element.requestDate) ==
                      lastCurrentMonths[1] &&
                  element.requestDate.day <= 28 &&
                  element.requestDate.day >= 22)
              .length),
    ];
    return requestsHistoryBarChartData;
  }

  /// Selected department filter for the dashboard.
  String? selectedDepartmentFilter;

  /// Display name for the selected department filter.
  String departmentFilterName = 'Department'.tr;

  /// Time-based filters for different statistics on the dashboard.
  TimeFilter? selectedTimeAbsenceFilter;
  TimeFilter? selectedTimeLateCountFilter;
  TimeFilter? selectedTimeLateMinutesFilter;
  TimeFilter? selectedTimeRequestFilter;

  /// Display names for the time-based filters.
  String absenceFilterName = AppConstanst.time.tr;
  String lateCountFilterName = AppConstanst.time.tr;
  String lateMinutesFilterName = AppConstanst.time.tr;
  String lateMinutesAverage = 'Total'.tr;
  String requestFilterName = AppConstanst.time.tr;

  /// Selected location filter for the dashboard.
  String? selectedLocationFilter;

  /// Display name for the selected location filter.
  String locationFilterName = 'Location'.tr;

  /// Flag to determine whether data should be displayed on the dashboard.
  bool? showData = true;

  /// Sets the department filter, updates the relevant data, and refreshes the UI.
  setDepartmentFilter(String filter) {
    selectedDepartmentFilter = filter;

    /// Update the department filter name using `AddDepartmentController`.
    departmentFilterName =
        Get.find<AddDepartmentController>().getDepartmentName(filter, null);

    // Fetch and update various charts and data using other controllers.
    getRequestsChartData(filter);
    //  getHRRequestTypes();
    getRequestsHistoryBarChartData();
    getRequestTypesBarChartData();
    getAllAttandance(filter);

    // Update the relevant parts of the UI.
    update([AppConstanst.dashboard]);

    update([AppConstanst.hrDashboardFilters]);
  }

  /// Sets the location filter and refreshes the UI.
  setLocationFilter(String filter) {
    selectedLocationFilter = filter;
    locationFilterName = filter;
    update([AppConstanst.hrDashboardFilters]);
  }

  /// Sets the time filter for absence data and refreshes the relevant chart.
  setTimeAbsenceFilter(TimeFilter filter) {
    selectedTimeAbsenceFilter = filter;
    absenceFilterName = filter.getName;
    getAbsenceHistoryBarChartData();
    update([AppConstanst.hrDashboardFilters]);
  }

  /// Sets the time filter for late count data and refreshes the relevant chart.
  setTimeLateCountFilter(TimeFilter filter) {
    selectedTimeLateCountFilter = filter;
    lateCountFilterName = filter.getName;
    getLateHistoryCountBarChartData();
    update([AppConstanst.hrDashboardFilters]);
  }

  /// Sets the time filter for late minutes data and refreshes the relevant chart.
  setTimeLateMinutesFilter(TimeFilter filter) {
    selectedTimeLateMinutesFilter = filter;
    lateMinutesFilterName = filter.getName;
    getLateHistoryMinuteBarChartData();
    update([AppConstanst.hrDashboardFilters]);
  }

  /// Sets the time filter for requests and refreshes the relevant charts.
  setTimeRequestFilter(TimeFilter filter) {
    selectedTimeRequestFilter = filter;
    requestFilterName = filter.getName;

    /// Update request history and other charts.
    getRequestsHistoryBarChartData();
    update([AppConstanst.dashboard]);
    update([AppConstanst.hrDashboardFilters]);
  }
}
