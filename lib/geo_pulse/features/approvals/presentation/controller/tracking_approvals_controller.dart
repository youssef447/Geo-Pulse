import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tracking_module/tracking_module/features/request/domain/request_repo.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/enums.dart';

import '../../../../features/notification_serevice/notification_controller.dart';
import '../../../../features/request_type/data/models/request_type_model.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/helpers/get_dialog_helper.dart';
import '../../../users/logic/add_employee_controller.dart';
import '../../../home/presentation/controller/controller/tracking_home_controller.dart';

import '../../../request/data/models/request_model.dart';
import '../../../request_type/presentation/controller/request_types_controller.dart';
import '../../constants/table_columns.dart';
import '../../domain/repository/approval_repo.dart';
import '../ui/widgets/dialogs/rejection_dialog.dart';

///Approvals controller which is Sepecific to Manager and Hr
class TrackingApprovalsController extends GetxController {
  final ApprovalRepo approvalRepo;
  final RequestRepo requestsRepo;

  TrackingApprovalsController(
      {required this.approvalRepo, required this.requestsRepo});

  late final rejectionController = TextEditingController();

  // Changes depending on readonly or not
  List<String> tableColumns = ApprovalsColumnsConstants.approvalsHeaders;

  List<RequestModel> approvalRequests = [];
  List<RequestModel> aLLApprovalRequests = [];

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void onInit() async {
    super.onInit();
    try {
      await Get.find<UserController>().getAllEmployees();
      getRequiredRequests();
    } catch (e) {
      print(e.toString());
    }
  }

  /// Rejects the request at the given index

  void rejectRequest(int index) {
    // Show the rejection dialog
    selectedReqStatus = RequestStatus.rejected;
    update([AppConstanst.statusDropdown]);

    // Update the request status to rejected and add the reason of rejection
    approvalRequests[index].requestStatus = RequestStatus.rejected;
    approvalRequests[index].hrApproval =
        RequestStatus.rejected.getName.toLowerCase();

    Get.back();

    // Add the reason of rejection to the request model
    approvalRequests[index].reasonOfRejection =
        rejectionController.text.toLowerCase();
    // Update the request in the database
    updateApprovals(approvalRequests[index]).then((_) {
      RequestTypeModel requestTypes = Get.find<RequestTypeController>()
          .requestTypeModels
          .firstWhere((element) =>
              element.id == approvalRequests[index].requestType.id);

      Get.find<AppNotificationController>().sendNotification(
        topic: approvalRequests[index].requestedUserId,
        title: "${requestTypes.englishName} request",
        arabicTitle: "طلب ${requestTypes.arabicName}",
        body:
            "Your ${requestTypes.englishName} request has been rejected by Human Resources.",
        arabicBody:
            "تم رفض طلب: ${requestTypes.arabicName} الخاص بك من قبل قسم الموارد البشرية.",
        type: AppConstanst.attendanceRequestType,
        attendanceRequestId: approvalRequests[index].id,
      );
    });

    update([AppConstanst.approvals]);

    resetResources();
  }

  /// Approve a request and send a notification to the user. If the request type is "transaction", add an attendance record to the user's attendance history.

  void approveRequest(int index) async {
    approvalRequests[index].requestStatus = RequestStatus.approved;
    approvalRequests[index].hrApproval =
        RequestStatus.approved.getName.toLowerCase();
    // add excuse

    updateApprovals(approvalRequests[index]).then((_) {
      RequestTypeModel requestTypes = Get.find<RequestTypeController>()
          .requestTypeModels
          .firstWhere((element) =>
              element.id == approvalRequests[index].requestType.id);

      Get.find<AppNotificationController>().sendNotification(
        topic: approvalRequests[index].requestedUserId,
        title: "${requestTypes.englishName} request",
        arabicTitle: "طلب ${requestTypes.arabicName}",
        body:
            "Your ${requestTypes.englishName} request has been approved by Human Resources.",
        arabicBody:
            "تمت الموافقة علي طلب: ${requestTypes.arabicName} الخاص بك من قبل قسم الموارد البشرية.",
        type: AppConstanst.attendanceRequestType,
        attendanceRequestId: approvalRequests[index].id,
      );
      update([AppConstanst.approvals]);
    });
  }

  /// Pends the request at the given index
  ///
  /// This method is called when the user clicks on the pend button
  /// in the request details page. It updates the request status to
  /// `pending` and adds the reason of pend to the request model.
  ///
  /// [index] is the index of the request to be pended
  void pendRequest(int index) {
    approvalRequests[index].requestStatus = RequestStatus.pending;

    update([AppConstanst.approvals]);
  }

  String dropDownArrow = AppAssets.down;
  late RequestStatus selectedReqStatus;
  List<RequestStatus> reqStatusList = [
    RequestStatus.pending,
    RequestStatus.approved,
    RequestStatus.rejected,
  ];

  /// Updates the arrow icon for the status dropdown
  ///
  /// [opened] is the value of the dropdown's open state
  ///
  void toggleArrow(bool? opened) {
    dropDownArrow = opened ?? false ? AppAssets.down : AppAssets.down;
    update([AppConstanst.statusDropdown]);
  }

  /// Handles the selection of a request status from the dropdown
  ///
  /// Shows a dialog for rejection and calls [approveRequest] or [pendRequest]
  /// depending on the selected status
  ///
  /// [value] is the selected status
  /// [context] is the build context of the dropdown
  /// [index] is the index of the request in the list
  void selectReqStatus(
      {required RequestStatus value,
      required BuildContext context,
      required int index}) {
    if (value == RequestStatus.rejected) {
      GetDialogHelper.generalDialog(
        child: RejectionDialog(modelIndex: index),
        context: context,
      );
    } else if (value == RequestStatus.approved) {
      approveRequest(index);
      selectedReqStatus = value;
      update([AppConstanst.requestDetails]);
    } else {
      pendRequest(index);
      selectedReqStatus = value;
      update([AppConstanst.requestDetails]);
    }
  }

  /// Updates a request in the approval requests list
  ///
  /// This method is used to update a request in the approval requests list
  /// after a manager or HR has approved or rejected a request.
  ///

  ///
  Future<void> updateApprovals(RequestModel model) async {
    // Create a new request model from the given one
    RequestModel newModel = RequestModel.fromMap(model.toMap());

    // Update the request type id of the new model
    newModel.requestType = Get.find<RequestTypeController>()
        .getRequestTypeId(model.requestType.id);

    await approvalRepo.updateApprovals(newModel);
    // Update the request in the database
    update([AppConstanst.approvals]);
  }

  resetResources() {
    rejectionController.clear();
  }

  bool isGettingRequests = true;

  /// Gets all requests that need HR approval.

  Future<void> getRequiredRequests() async {
    // Clear the lists
    approvalRequests = [];
    aLLApprovalRequests = [];

    final response = await requestsRepo.getRequiredRequests();

    isGettingRequests = false;

    response.fold((failure) {}, (requests) {
      aLLApprovalRequests = requests;
      approvalRequests = aLLApprovalRequests.map((e) => e).toList();
    });

    // Trigger an update to the UI
    update([AppConstanst.approvals]);
  }

  String getRequestTypeinArabic(String requestTypeName) {
    RequestTypeModel requestTypeModel = Get.find<RequestTypeController>()
        .requestTypeModels
        .firstWhere((element) =>
            element.englishName.toLowerCase() == requestTypeName.toLowerCase());

    return requestTypeModel.arabicName;
  }

  //requests search
  /// Searches approval requests by request type and employee name
  ///
  /// This method searches the approval requests by the request type and the
  /// employee name. The search is case insensitive.
  ///
  /// [query] is the search query.
  void searchApprovalRequest(String query) {
    /// Filter approval requests to match the search query
    approvalRequests = aLLApprovalRequests
        .where((element) =>

            /// Check if the request type matches the search query
            element.requestType.englishName
                .toLowerCase()
                .contains(query.toLowerCase()) ||

            /// Check if the employee name matches the search query
            Get.find<UserController>()
                .getEmployeeName(element.requestedUserId)
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();

    /// Trigger an update to the UI
    update([AppConstanst.approvals]);

    /// Also trigger an update to the home page
    Get.find<TrackingHomeController>().update([
      AppConstanst.home,
    ]);
  }

  /// Filter approval requests by date
  ///
  /// This method filters the approval requests to include only those that
  /// match the provided [date]'s month and year.
  ///
  /// [date] is the reference date used for filtering.
  void filterApprovalrequests(DateTime date) {
    approvalRequests = aLLApprovalRequests
        .where(
          (element) =>
              element.requestDate.month == date.month &&
              element.requestDate.year == date.year,
        )
        .toList();
    update([AppConstanst.approvals]);
  }

  /// Filter approval requests
  ///
  /// This function filters the approval requests based on the given parameters.
  ///
  /// [startDate] is the start date of the filter. If provided, the requests are
  /// filtered to include only those with a request date that is after or equal
  /// to the given date.
  ///
  /// [type] is the type of the request. If provided, the requests are filtered
  /// to include only those with the given type.
  ///
  /// [totalTimeMinutes] is the total time of the request. If provided, the
  /// requests are filtered to include only those with a total time in minutes
  /// that is equal to the given value.
  ///
  /// [period] is the period of the filter. If provided, the requests are filtered
  /// to include only those with a total time in minutes that is equal to the
  /// given period multiplied by the given [totalTimeMinutes].
  ///
  /// [status] is the status of the request. If provided, the requests are
  /// filtered to include only those with the given status.
  void filterApprovalRequests({
    DateTime? startDate,
    String? type,
    String? status,
    int? totalTimeMinutes,
    TimeFilter? period,
  }) {
    // List<RequestModel> aLLRequestsFiltered =List.of(aLLRequests)  ;
    approvalRequests = aLLApprovalRequests;
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
      // Filter the requests to include only those with a request date that is
      // after or equal to the given date.
      approvalRequests = approvalRequests
          .where((element) =>
              element.requestDate.year >= startDate.year &&
              element.requestDate.month >= startDate.month &&
              element.requestDate.day >= startDate.day)
          .toList();
    }
    if (type != null) {
      // Filter the requests to include only those with the given type.
      approvalRequests = approvalRequests
          .where((element) => element.requestType.englishName == type)
          .toList();
    }

    if (totalTimeMinutes != null) {
      // Filter the requests to include only those with a total time in minutes
      // that is equal to the given value.
      approvalRequests = approvalRequests
          .where((element) => element.totalTime.inMinutes == duration)
          .toList();
    }

    if (status != null) {
      // Filter the requests to include only those with the given status.
      approvalRequests = approvalRequests
          .where((element) => element.requestStatus.getName == status)
          .toList();
    }
    update([AppConstanst.approvals]);
  }

  /// Reset Filter Requests
  void resetFilterApprovalRequests() {
    approvalRequests = aLLApprovalRequests;
    update([AppConstanst.approvals]);
  }

  /// Sort the approval requests based on the given sortBy parameter.

  void sortApprovalRequest(String? sortBy) {
    if (sortBy == SortFilter.totalTime.getName) {
      /// Sort the requests by total time in descending order.
      approvalRequests.sort((a, b) => b.totalTime.compareTo(a.totalTime));
    } else {
      /// Sort the requests by request date in descending order.
      approvalRequests.sort((a, b) => b.requestDate.compareTo(a.requestDate));
    }

    update([AppConstanst.approvals]);
  }
}
