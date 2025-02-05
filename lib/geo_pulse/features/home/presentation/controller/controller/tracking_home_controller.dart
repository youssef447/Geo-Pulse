import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/features/users/models/user_model.dart';
import '../../../../../core/extensions/extensions.dart';

import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/routes/route_arguments.dart';
import '../../../../../features/home/presentation/controller/controller/check_in_controller.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/enums.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/helpers/date_time_helper.dart';
import '../../../../../core/helpers/get_dialog_helper.dart';
import '../../../../../core/helpers/responsive_helper.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../approvals/presentation/controller/tracking_approvals_controller.dart';
import '../../../../approvals/presentation/ui/pages/mobile/mobile_approvals_tab.dart';
import '../../../../approvals/presentation/ui/pages/tablet/tablet_approvals_tab.dart';
import '../../../../attendance/presentation/controller/controller/attendance_controller.dart';
import '../../../../attendance/data/models/attendance_data_model.dart';

import '../../../../attendance/presentation/ui/page/mobile/attendance_mobile_page.dart';
import '../../../../attendance/presentation/ui/page/tablet/attendance_tablet_page.dart';
import '../../../../dashboard/hr_dashboard/presentation/ui/pages/hr_dashboard_tab.dart';
import '../../../../dashboard/my_dashboard/presentation/ui/page/dashboard_tab.dart';
import '../../../../notification_service/services/local_notification_service.dart';
import '../../../../notification_service/services/push_notification_service.dart';
import '../../../../notifications/presentation/controller/notification_controller.dart';
import '../../../../users/logic/add_employee_controller.dart';
import '../../../../location/presentation/ui/pages/mobile/mobile_location_tab.dart';
import '../../../../location/presentation/ui/pages/tablet/tablet_location_tab.dart';
import '../../../../request/presentation/controller/requests_controller.dart';
import '../../../../request/presentation/ui/pages/mobile/mobile_request_tab.dart';
import '../../../../request/presentation/ui/pages/send_request.dart';
import '../../../../request/presentation/ui/pages/tablet/tablet_requests_tab.dart';
import '../../../../request_type/presentation/controller/request_types_controller.dart';
import '../../../../request_type/data/models/request_type_model.dart';
import '../../../../request_type/presentation/ui/widgets/tabs/mobile_request_type_tab.dart';
import '../../../../request_type/presentation/ui/widgets/tabs/tablet_request_type_tab.dart';

import '../../../data/models/status_item_model.dart';

/// This class is the controller for the tracking home page.
class TrackingHomeController extends GetxController
    with GetTickerProviderStateMixin {
  UserModel? user;
  bool loading = true;
  late final TabController tabController;

  final searchController = TextEditingController();

  List<HomeTabs> homeTabs = [];

  /// Sets the home tabs based on the user's position.
  /// Return Type : void
  setHomeTabs() {
    homeTabs = [
      HomeTabs.dashboard,
      HomeTabs.attendance,
      HomeTabs.requests,
    ];

    if (Get.find<UserController>().employee!.position == UserPosition.manager) {
      homeTabs.add(HomeTabs.approvals);
    } else if (Get.find<UserController>().employee!.position ==
        UserPosition.hr) {
      homeTabs.add(HomeTabs.approvals);
      homeTabs.add(HomeTabs.requstTypes);
      homeTabs.add(HomeTabs.locations);
    }
  }

  /// Returns the current tab based on the index of the tab controller.
  /// Return Type : HomeTabs
  HomeTabs getCurrentTab() {
    if (tabController.index == 0) {
      return HomeTabs.dashboard;
    }
    if (tabController.index == 1) {
      return HomeTabs.attendance;
    }
    if (tabController.index == 2) {
      return HomeTabs.requests;
    }
    if (tabController.index == 3) {
      return HomeTabs.approvals;
    }
    if (tabController.index == 4) {
      return HomeTabs.requstTypes;
    }
    return HomeTabs.locations;
  }

  var isAnimatable = true;
  var selectedLanguage = Get.locale?.languageCode == 'ar' ? 'AR' : 'ENG';
  var isArabic = Get.locale?.languageCode == 'ar';

  /// Toggles the application's animation state.
  ///
  /// This method switches the `isAnimatable` variable between true and false,
  /// effectively enabling or disabling animations. It also triggers a UI rebuild
  /// by calling `Get.forceAppUpdate()`.
  void toggleAnimation() {
    isAnimatable = !isAnimatable;
    Get.forceAppUpdate();
  }

  /// Toggles the application's language state.
  ///
  /// This method switches the `selectedLanguage` variable between 'ENG' and 'AR',
  /// effectively enabling or disabling the Arabic language. It also triggers a
  /// locale change by calling `Get.updateLocale()` with the corresponding locale.
  ///
  void toggleLanguage() {
    if (selectedLanguage == 'ENG') {
      Get.updateLocale(const Locale('ar', 'EG'));
      selectedLanguage = 'AR';
    } else {
      Get.updateLocale(const Locale('en', 'US'));
      selectedLanguage = 'ENG';
    }
  }

  /// Index for the current layout being displayed on the HR dashboard.
  int hrLayoutIndex = 0;

  /// Toggles the HR dashboard layout based on the selected index.
  toggleHRDashboardLayout(index) {
    hrLayoutIndex = index;

    /// Update the layout switch and layout sections of the UI.
    update([AppConstanst.hrDashboardSwitch]);
    update([AppConstanst.hrDashboardLayout]);
  }

  List<String> requestTypes =
      Get.find<RequestTypeController>().getRequestTypesAsStrings();

  /// This function is called when the user taps on the floating button in the [HomeScreen].
  ///
  /// It determines which tab is currently selected and shows a dialog based on that.
  ///
  /// If the selected tab is [AttendanceTab] (index 1), it shows the [AddTransactionDialog].
  ///
  /// If the selected tab is [RequestsTab] (index 2), it shows the [SendRequest] dialog.
  ///
  /// If the selected tab is [RequestTypeTab] (index 4), it resets the selected request type
  /// and navigates to the [RequestTypeScreen].
  ///
  /// If the selected tab is [LocationTab] (index 5), it navigates to the [AddLocationScreen].
  void onButtonTap(BuildContext context) {
    if (getCurrentTab() == HomeTabs.requests) {
      GetDialogHelper.generalDialog(
        child: const SendRequest(),
        context: context,
      );
    } else if (getCurrentTab() == HomeTabs.requstTypes) {
      Get.find<RequestTypeController>().resetselectedRequestType();
      context.navigateTo(
        Routes.requestType,
        arguments: {
          RouteArguments.title: 'Add Request Type'.tr,
        },
      );
    } else if (getCurrentTab() == HomeTabs.locations) {
      context.navigateTo(
        Routes.addLocation,
      );
    }
  }

  @override
  void onClose() {
    Get.find<CheckInController>().timer?.cancel();
    super.onClose();
  }

  late List<Widget> tabs;
  @override
  void onInit() async {
    super.onInit();
    await Get.find<UserController>().getNewEmployee('nlcylrxGqh3I7DqljB4r');
    if (Platform.isAndroid || Platform.isIOS) {
      await PushNotificationService.initNotifications();
    }
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await Get.find<AppNotificationController>().fetchNotifications();

    await Get.find<CheckInController>().loadState();

    Get.find<CheckInController>().currentLocationAddress.addListener(() {
      Get.find<CheckInController>().update([AppConstanst.checkInDialog]);
    });

    setHomeTabs();
    setTabViews();
    tabController = TabController(
      length: homeTabs.length,
      vsync: this,
    )..addListener(
        () {
          update([AppConstanst.home]);
        },
      );

    filteredAttendance = [];
    getAttendanceStatusItems();
    getRequestStatusItems();
    loading = false;
    update([AppConstanst.home]);
  }

  ///Set the tabs views according to the user type.

  ///according to the current user.
  void setTabViews([UserModel? user]) {
    final isHr =
        Get.find<UserController>().employee!.position == UserPosition.hr ||
            user != null && user.position == UserPosition.hr;
    final notEmployee = Get.find<UserController>().employee!.position !=
            UserPosition.employee ||
        user != null && user.position != UserPosition.employee;
    if (isHr) {
      tabs = getHrTabViews();
    }
    //Manager
    else if (notEmployee) {
      tabs = getManagerTabViews();
    } else {
      tabs = getEmployeeTabViews();
    }
  }

  List<Widget> getEmployeeTabViews() {
    return [
      const DashboardTab(),
      ResponsiveHelper(
        mobileWidget: AttendanceMobilePage(
          readOnly: user != null,
        ),
        tabletWidget: AttendanceTabletPage(
          readOnly: user != null,
        ),
      ),
      ResponsiveHelper(
        mobileWidget: MobiletRequestsTab(
          readOnly: user != null,
        ),
        tabletWidget: TabletRequestsTab(
          readOnly: user != null,
        ),
      ),
    ];
  }

  List<Widget> getManagerTabViews() {
    return [
      ...getEmployeeTabViews(),
      ResponsiveHelper(
        mobileWidget: MobileApprovalsTab(
          readOnly: user != null,
        ),
        tabletWidget: TabletApprovalsTab(
          readOnly: user != null,
        ),
      ),
    ];
  }

  List<Widget> getHrTabViews() {
    return [
      const HRDashboardTab(),
      ResponsiveHelper(
        mobileWidget: AttendanceMobilePage(
          readOnly: user != null,
        ),
        tabletWidget: AttendanceTabletPage(
          readOnly: user != null,
        ),
      ),
      ResponsiveHelper(
        mobileWidget: MobiletRequestsTab(
          readOnly: user != null,
        ),
        tabletWidget: TabletRequestsTab(
          readOnly: user != null,
        ),
      ),
      ResponsiveHelper(
        mobileWidget: MobileApprovalsTab(
          readOnly: user != null,
        ),
        tabletWidget: TabletApprovalsTab(
          readOnly: user != null,
        ),
      ),
      ResponsiveHelper(
        mobileWidget: MobileRequestsTypeTab(
          readOnly: user != null,
        ),
        tabletWidget: TabletRequestsTypeTab(
          readOnly: user != null,
        ),
      ),
      ResponsiveHelper(
        mobileWidget: MobileLocationTab(
          readOnly: user != null,
        ),
        tabletWidget: TabletLocationTab(
          readOnly: user != null,
        ),
      ),
    ];
  }

  List<StatusItemModel> attendanceStatusItems = [];
  List<StatusItemModel> requestStatusItems = [];
  int currentAttendanceStatusIndex = 0;
  int currentRequestStatusIndex = 0;

  void getRequestStatusItems() {
    requestStatusItems = [
      StatusItemModel(
        statusTextColor: AppColors.text,
        statusText: AppConstanst.all.capitalize!.tr,
        statusItemCount:
            Get.find<TrackingRequestsController>().aLLRequests.length,
        isContainerPrimaryColor: true,
      ),
      StatusItemModel(
        statusTextColor: AppColors.green,
        statusText: RequestStatus.approved.getName.tr,
        statusItemCount: Get.find<TrackingRequestsController>()
            .aLLRequests
            .where((element) => element.requestStatus == RequestStatus.approved)
            .length,
      ),
      StatusItemModel(
        statusTextColor: AppColors.orange,
        statusText: RequestStatus.pending.getName.tr,
        statusItemCount: Get.find<TrackingRequestsController>()
            .aLLRequests
            .where((element) => element.requestStatus == RequestStatus.pending)
            .length,
      ),
      StatusItemModel(
        statusTextColor: AppColors.darkRed,
        statusText: RequestStatus.rejected.getName.tr,
        statusItemCount: Get.find<TrackingRequestsController>()
            .aLLRequests
            .where((element) => element.requestStatus == RequestStatus.rejected)
            .length,
      ),
    ];
  }

  void getAttendanceStatusItems() {
    attendanceStatusItems = [
      StatusItemModel(
        statusTextColor: AppColors.text,
        statusText: AppConstanst.all.capitalize!.tr,
        statusItemCount: Get.find<TrackingAttendanceController>()
            .allAttendanceDataModel
            .length,
        isContainerPrimaryColor: true,
      ),
      StatusItemModel(
        statusTextColor: AppColors.green,
        statusText: AttendanceStatus.present.getName.tr,
        statusItemCount: Get.find<TrackingAttendanceController>()
            .allAttendanceDataModel
            .where((element) => element.status == AttendanceStatus.present)
            .length,
      ),
      StatusItemModel(
        statusTextColor: AppColors.orange,
        statusText: AttendanceStatus.late.getName.tr,
        statusItemCount: Get.find<TrackingAttendanceController>()
            .allAttendanceDataModel
            .where((element) => element.status == AttendanceStatus.late)
            .length,
      ),
      StatusItemModel(
        statusTextColor: AppColors.darkRed,
        statusText: AttendanceStatus.absent.getName.tr,
        statusItemCount: Get.find<TrackingAttendanceController>()
            .allAttendanceDataModel
            .where((element) => element.status == AttendanceStatus.absent)
            .length,
      ),
    ];
  }

  //-------------------Filter Logic-------------------//
  String dropDownArrow = AppAssets.down;
  bool enabledRequestApplyFilter = false;
  bool enabledAttendanceApplyFilter = false;
  bool enabledApprovalApplyFilter = false;
  toggleArrow(bool? opened) {
    dropDownArrow = opened ?? false ? AppAssets.down : AppAssets.down;
    update([AppConstanst.filterDialog]);
  }

  DateTime? selectedReqDate; // = DateTime.now();
  final dateReqController = TextEditingController();
  final totalTimeReqController = TextEditingController();
  DateTime? selectedAttendanceDate;
  final dateAttendanceController = TextEditingController();
  final totalTimeAttendanceController = TextEditingController();
  DateTime? selectedApprovalsDate;
  final dateApprovalsController = TextEditingController();
  final totalTimeApprovalsController = TextEditingController();
  RequestTypeModel? selectedReqType;
  RequestTypeModel? selectedApprovalReqType;
  AttendanceStatus? attendanceStatus;

  RequestStatus? apporvalsStatus;

  TimeFilter? timeReqFilter;
  TimeFilter? timeApprovalsFilter;
  TimeFilter? timeAttendanceFilter;
  List<TimeFilter> filterTypes = [
    TimeFilter.day,
    TimeFilter.week,
    TimeFilter.month,
    TimeFilter.year,
  ];

  /// Called when the user selects a time filter from the dropdown in the filter dialog.
  ///
  /// Updates the selected time filter for the current tab and enables the filter button.
  ///
  /// [value] is the selected time filter from the dropdown
  void onTimeFilterChanged(TimeFilter value) {
    tabController.index == 1
        ? timeAttendanceFilter = value
        : tabController.index == 2
            ? timeReqFilter = value
            : timeApprovalsFilter = value;
    update([AppConstanst.filterDialog]);
    enableFilterBtn();
  }

  /// Enables the filter button for the current tab.
  ///
  /// This method checks the index of the currently selected tab using the [tabController].
  /// Based on the tab index, it calls the respective method to enable the filter button
  /// for attendance, request, or approvals.
  void enableFilterBtn() {
    tabController.index == 1
        ? enableAttendanceFilterBtn()
        : tabController.index == 2
            ? enableReqFilterBtn()
            : enableApprovalsFilterBtn();
  }

  /// Called when the user selects a date from the calendar or inputs a date manually in the filter dialog.
  ///
  /// This method updates the selected date for the current tab and enables the filter button.
  ///
  /// [dateTime] is the selected date to update the filter dialog with.
  void onDateChanged(DateTime? dateTime) {
    if (dateTime != null) {
      selectFilterDate(dateTime);
      enableFilterBtn();
    }
  }

  /// Updates the selected date in the filter dialog based on the current tab and selected date.
  ///
  /// [dateTime] is the selected date to update the filter dialog with.
  void selectFilterDate(DateTime dateTime) {
    if (getCurrentTab() == HomeTabs.attendance) {
      dateAttendanceController.text = DateTimeHelper.formatDate(dateTime);
      selectedAttendanceDate = dateTime;
    } else if (getCurrentTab() == HomeTabs.requests) {
      dateReqController.text = DateTimeHelper.formatDate(dateTime);
      selectedReqDate = dateTime;
    } else if (getCurrentTab() == HomeTabs.approvals) {
      dateApprovalsController.text = DateTimeHelper.formatDate(dateTime);
      selectedApprovalsDate = dateTime;
    }
  }

  /// Enables the filter button in the filter dialog for the request tab.

  void enableReqFilterBtn() {
    //check if already enabled to avoid unecessary rebuild
    if (!enabledRequestApplyFilter) {
      enabledRequestApplyFilter = true;
      update([AppConstanst.filterBtn]);
    }
  }

  /// Enables the filter button in the filter dialog for the approvals tab.

  void enableApprovalsFilterBtn() {
    //check if already enabled to avoid unecessary rebuild
    if (!enabledApprovalApplyFilter) {
      enabledApprovalApplyFilter = true;
      update([AppConstanst.filterBtn]);
    }
  }

  /// Enables the filter button in the filter dialog for the attendance tab.

  void enableAttendanceFilterBtn() {
    //check if already enabled to avoid unecessary rebuild
    if (!enabledAttendanceApplyFilter) {
      enabledAttendanceApplyFilter = true;
      update([AppConstanst.filterBtn]);
    }
  }

  /// Disables the filter button in the filter dialog for the attendance tab.

  void disableAttendanceFilterBtn() {
    enabledAttendanceApplyFilter = false;
    update([AppConstanst.filterBtn]);
  }

  /// Disables the filter button in the filter dialog for the requests tab.

  void disableRequestsFilterBtn() {
    enabledRequestApplyFilter = false;
    update([AppConstanst.filterBtn]);
  }

  /// Disables the filter button in the filter dialog for the approvals tab.

  void disableApprovalsFilterBtn() {
    enabledApprovalApplyFilter = false;
    update([AppConstanst.filterBtn]);
  }

  /// Disables the filter button in the filter dialog for the current tab.

  void disableFilterBtn() {
    getCurrentTab() == HomeTabs.attendance
        ? disableAttendanceFilterBtn()
        : getCurrentTab() == HomeTabs.requests
            ? disableRequestsFilterBtn()
            : disableApprovalsFilterBtn();
  }

  /// Selects the attendance status to filter the attendance by

  void selectAttendanceStatus(AttendanceStatus status) {
    attendanceStatus = status;
    update([AppConstanst.filterDialog]);
    enableFilterBtn();
  }

  /// Selects the request type to filter the requests or approvals by

  void selectReqType(RequestTypeModel value) {
    tabController.index == 2
        ? selectedReqType = value
        : selectedApprovalReqType = value;
    update([AppConstanst.filterDialog]);
    enableFilterBtn();
  }

  /// Selects the approval request status to filter the approvals by

  void selectApprovalsReqStatus(RequestStatus value) {
    apporvalsStatus = value;
    update([AppConstanst.filterDialog]);
    enableFilterBtn();
  }

  ///Filters the attendance and requests by the selected month.

  void filterMonth(DateTime? date) {
    selectedReqDate = date!;
    filteredAttendance = [];

    // filter requests

    Get.find<TrackingRequestsController>().filterCalendarRequests(date);

    // filter approval requests
    Get.find<TrackingApprovalsController>().filterApprovalrequests(date);
  }

  /// Resets the request filter dialog to its initial state.

  void resetReqFilter() {
    selectedReqType = null;
    // attendanceStatus = null;
    dateReqController.clear();
    totalTimeReqController.clear();
    selectedReqDate = DateTime.now();
    timeReqFilter = null;
    // filteredRequests = loggedInUser.requests;
    update([AppConstanst.filterDialog]);
    disableFilterBtn();
    update([AppConstanst.home]);
    Get.find<TrackingRequestsController>().resetFilterRequests();
    Get.back();
  }

  /// Resets the attendance filter dialog to its initial state.

  void resetAttendanceFilter() {
    attendanceStatus = null;
    dateAttendanceController.clear();
    totalTimeAttendanceController.clear();
    selectedAttendanceDate = DateTime.now();
    timeAttendanceFilter = null;
    filteredAttendance = [];
    update([AppConstanst.filterDialog]);
    disableFilterBtn();
    update([AppConstanst.home]);
    Get.find<TrackingAttendanceController>().resetFiltertAttendance();
    Get.back();
  }

  /// Resets the approvals filter dialog to its initial state.

  void resetApprovalsFilter() {
    timeApprovalsFilter = null;
    dateApprovalsController.clear();
    totalTimeApprovalsController.clear();
    selectedApprovalsDate = DateTime.now();
    selectedApprovalReqType = null;
    apporvalsStatus = null;

    update([AppConstanst.filterDialog]);
    disableFilterBtn();
    update([AppConstanst.home]);
    Get.find<TrackingApprovalsController>().resetFilterApprovalRequests();
    Get.back();
  }

  late List<AttendanceDataModel> filteredAttendance;

  /// Applies the selected filter to the given type

  void applyFilter(BuildContext context, String? filterType) {
    filterType == AppConstanst.request
        ? Get.find<TrackingRequestsController>().filterRequests(
            type: selectedReqType?.englishName,
            period: timeReqFilter,
            startDate: selectedReqDate,
            totalTimeMinutes: totalTimeReqController.text.isEmpty
                ? null
                : int.parse(totalTimeReqController.text),
          )
        : filterType == AppConstanst.attendance
            ? Get.find<TrackingAttendanceController>().filterAttendance(
                status: attendanceStatus?.getName,
                period: timeAttendanceFilter,
                startDate: selectedAttendanceDate,
                totalTimeMinutes: totalTimeAttendanceController.text.isEmpty
                    ? null
                    : int.parse(totalTimeAttendanceController.text),
              )
            : Get.find<TrackingApprovalsController>().filterApprovalRequests(
                type: selectedApprovalReqType?.englishName,
                status: apporvalsStatus?.getName,
                period: timeApprovalsFilter,
                startDate: selectedApprovalsDate,
                totalTimeMinutes: totalTimeApprovalsController.text.isEmpty
                    ? null
                    : int.parse(totalTimeApprovalsController.text),
              );

    Get.back();
  }
}
