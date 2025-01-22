import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/constants/enums.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/helpers/get_dialog_helper.dart';
import '../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../core/helpers/share_helper.dart';
import '../../../../core/helpers/toast_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dialog/default_dialog.dart';
import '../../../../core/widgets/loading/loading.dart';
import '../../../users/logic/add_employee_controller.dart';
import '../../../home/presentation/controller/controller/tracking_home_controller.dart';
import '../../../notification_serevice/notification_controller.dart';
import '../../../request_type/data/models/request_type_model.dart';
import '../../../request_type/presentation/controller/request_types_controller.dart';
import '../../constants/table_columns.dart';
import '../../data/models/doc_model.dart';
import '../../data/models/request_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/request_repo.dart';

///This file is responsible for handling the requests logic
class TrackingRequestsController extends GetxController {
  final RequestRepo requestRepo;

  TrackingRequestsController({required this.requestRepo});
  List<RequestModel> filteredRequests = [];
  List<RequestModel> aLLRequests = [];
  List<String> tableColumns = RequestColumnsConstants.requestHeaders;

  /// Determines if a reminder can be sent for the given Request
  ///
  /// A reminder can be sent if:
  /// 1. The reminder has never been sent and the request status is pending.
  /// 2. The reminder was sent before, the request status is pending, and at least 48 hours have passed since the last reminder.
  bool canSendReminder(RequestModel model) {
    if (model.requestStatus != RequestStatus.pending) {
      return false;
    }
    // Check if the reminder has never been sent
    if (model.reminderSentDate == null) {
      return true;
    }

    // Calculate the difference in hours between now and the last reminder date
    final hoursSinceLastReminder =
        DateTime.now().difference(model.reminderSentDate!).inHours;

    // Allow sending a reminder only if 48 or more hours have passed
    return hoursSinceLastReminder >= 48;
  }

  /// Sends a reminder notification for a pending request.

  /// This function updates the request's reminder sent date,
  /// modifies the request in the database, and sends a notification
  void sendReminder(RequestModel model, int index) async {
    RequestModel newModel = RequestModel.fromMap(model.toMap());
    newModel.reminderSentDate = DateTime.now();
    model.reminderSentDate = DateTime.now();

    final result = await requestRepo.sendReminder(
      newModel,
      Get.find<UserController>()
          .getLocaleEmployee(newModel.requestedUserId)
          .supervisor,
    );
    result.fold((failure) {}, (_) {
      filteredRequests[index] = model;
      update([AppConstanst.request]);
      update([AppConstanst.reminder]);

      String empArabicName =
          Get.find<UserController>().getEmployeeNameEnglishArabic(false);
      String empEnglishName =
          Get.find<UserController>().getEmployeeNameEnglishArabic(true);

      Get.find<AppNotificationController>().sendNotification(
        topic: 'request',
        title: "Reminder: Pending ${model.requestType.englishName} Request",
        arabicTitle:
            "تذكير: طلب ${model.requestType.arabicName} بانتظار الموافقة",
        body:
            "Please review the ${model.requestType.englishName} request from $empEnglishName that is still awaiting your approval.",
        arabicBody:
            "يرجى مراجعة طلب ${model.requestType.arabicName} من $empArabicName الذي لا يزال بانتظار موافقتك.",
        type: AppConstanst.attendanceRequestType,
        attendanceRequestId: newModel.id,
      );
    });
  }

  //Send Request Dialog
  final descriptionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  String dropDownArrow = AppAssets.down;
  FilePickerResult? result;

  RequestTypeModel? selectedReqType;
  bool allDayValue = true;

  /// Toggles the all-day value of the request dialog.
  ///
  /// This method inverts the `allDayValue` and updates the UI
  /// by calling the `update` method with the `requestDialog` id.
  void toggleAllDay() {
    /// Trigger haptic feedback for a medium impact vibration
    HapticFeedbackHelper.triggerHapticFeedback(
      vibration: VibrateType.mediumImpact,
      hapticFeedback: HapticFeedback.mediumImpact,
    );

    /// Invert the all-day value
    allDayValue = !allDayValue;

    /// Update the UI
    update([AppConstanst.requestDialog]);
  }

  //Firesbase instance
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    getRequests();
  }

  ///Sends a request to the server and saves it in the database.
  void sendRequest(BuildContext context) async {
    String requestId = DateTime.now().toString();

    if (validateRequests()) {
      showLoadingIndicator();
      // await uploadrequestDocs();
      RequestModel model = RequestModel(
        requestDate: DateTime.now(),
        id: requestId,
        requestType: selectedReqType!,
        startDate: startDate!,
        endDate: endDate!,
        startTime:
            startTimeController.text == '' ? null : startTimeController.text,
        endTime: endTimeController.text == '' ? null : endTimeController.text,
        requestStatus: RequestStatus.pending,
        totalTime: ShareHelper.calculateDifference(startDate!,
            startTimeController.text, endDate!, endTimeController.text),
        requestedUserId: Get.find<UserController>().employee!.email,
        description: descriptionController.text,
        attachments: docs,
        hrApproval: selectedReqType!.hrApproval.getName,
        reminderSentDate: null,
      );
      final res = await requestRepo.sendRequest(
        requestModel: model,
        userId: Get.find<UserController>().employee!.email,
        requestId: requestId,
      );
      hideLoadingIndicator();

      res.fold((fail) {
        GetDialogHelper.generalDialog(
            child: DefaultDialog(
              lottieAsset: AppAssets.trash,
              title: 'Error',
              subTitle: fail.message,
            ),
            context: context);
      }, (_) {
        model.requestType = selectedReqType!;
        filteredRequests.add(model);
        update([
          AppConstanst.request,
        ]);
        if (context.mounted) {
          GetDialogHelper.generalDialog(
            barrierDismissible: false,
            context: context,
            child: DefaultDialog(
                width: context.isTablett ? 411.w : 343.w,
                lottieAsset: AppAssets.successful,
                title: 'Successful'.tr,
                subTitle:
                    '${'You Successful Send'.tr} ${selectedReqType?.englishName.tr}'),
          );
        }
        String empArabicName =
            Get.find<UserController>().getEmployeeNameEnglishArabic(false);
        String empEnglishName =
            Get.find<UserController>().getEmployeeNameEnglishArabic(true);
        Get.find<AppNotificationController>().sendNotification(
          topic: 'request',
          title: "new ${selectedReqType?.englishName} request",
          arabicTitle: "طلب ${selectedReqType?.arabicName} جديد",
          body:
              "$empEnglishName has requested your approval for a ${selectedReqType?.englishName} request.",
          arabicBody:
              "لقد طلب $empArabicName موافقتك على طلب ${selectedReqType?.arabicName}.",
          type: AppConstanst.attendanceRequestType,
          attendanceRequestId: requestId,
        );
        resetResources();
      });
    }
  }

  Future<void> uploadrequestDocs() async {
    // upload docs
    if (docs.isNotEmpty) {
      for (int i = 0; i < docs.length; i++) {
        // upload to firebase storage
        String fileName = docs[i].fileName! + DateTime.now().toString();
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("${AppConstanst.attendanceDocs}/$fileName");
        final metadata =
            SettableMetadata(contentType: AppConstanst.applicationPdf);

        final uploadTask = await storageRef.putFile(docs[i].doc!, metadata);

        final url = await uploadTask.ref.getDownloadURL();
        if (await canLaunchUrl(Uri.parse(url))) {
          docs[i].link = url;
        }
      }
    }
  }

//requests search
  void searchRequest(String query) {
    if (Get.locale.toString().contains('ar')) {
      filteredRequests = aLLRequests
          .where((element) => element.requestType.arabicName
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    } else {
      filteredRequests = aLLRequests
          .where((element) => element.requestType.englishName
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
    update([AppConstanst.request]);
    Get.find<TrackingHomeController>().update([
      AppConstanst.home,
    ]);
  }

  /// FILTER REQUEST STATUS
  void filterRequestStatus(int status) {
    if (status == 0) {
      filteredRequests = aLLRequests;
    } else {
      String statusName = status == 1
          ? RequestStatus.approved.getName.toLowerCase()
          : status == 2
              ? RequestStatus.pending.getName.toLowerCase()
              : RequestStatus.rejected.getName.toLowerCase();
      filteredRequests = aLLRequests
          .where(
            (element) =>
                element.requestStatus.getName.toLowerCase() == statusName,
          )
          .toList();
    }

    update([AppConstanst.request]);

    Get.find<TrackingHomeController>().update([
      AppConstanst.home,
    ]);
  }

  bool isGettingRequests = false;

  /// GET ALL REQUESTS
  Future<void> getRequests() async {
    isGettingRequests = true;

    final response = await requestRepo
        .getRequests(Get.find<UserController>().employee!.email);
    response.fold((failure) {
      isGettingRequests = false;
      GetDialogHelper.generalDialog(
          child: DefaultDialog(
            lottieAsset: AppAssets.trash,
            title: 'Error Getting Requests'.tr,
            subTitle: failure.message,
          ),
          context: Get.context!);
    }, (requests) {
      isGettingRequests = false;
      filteredRequests = [];
      aLLRequests = [];
      // filteredRequests = requests;
      for (var model in requests) {
        RequestTypeModel requestTypeModel = Get.find<RequestTypeController>()
            .requestTypeModels
            .firstWhere((element) => element.id == model.requestType.id);

        model.requestType = requestTypeModel;
        filteredRequests.add(model);
      }
      aLLRequests = filteredRequests.map((e) => e).toList();

      update([AppConstanst.request]);
    });
  }

  /// get request status items counts
  int filterRequestStatusCount(int status) {
    int count = 0;
    switch (status) {
      case 0:
        count = aLLRequests.length;
      case 1:
        count = aLLRequests
            .where((element) => element.requestStatus == RequestStatus.approved)
            .length;
      case 2:
        count = aLLRequests
            .where((element) => element.requestStatus == RequestStatus.pending)
            .length;
      case 3:
        count = aLLRequests
            .where((element) => element.requestStatus == RequestStatus.rejected)
            .length;
    }
    return count;
  }

  bool validateRequests() {
    if (validateReqType()) {
      final model =
          Get.find<RequestTypeController>().requestTypeModels.firstWhere(
                (model) => model.englishName == selectedReqType?.englishName,
              );

      return validateDate() &&
          validateAttachment(model.addingAttachments) &&
          validateDescription(model.addingDescription);
    } else {
      return false;
    }
  }

//upload attachments
  List<DocModel> docs = [];
  uploadAttachments() async {
    result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: [
          'pdf',
          'txt',
        ]);
    if (result != null) {
      docs.addAll(result!.files.map((e) {
        return DocModel(
          doc: File(e.path!),
        );
      }).toList());
      update([AppConstanst.attachment]);

      enableSendReqBtn();
    }
  }

  removeAttachment(DocModel model) {
    final index =
        docs.indexWhere((element) => element.fileName == model.fileName);

    docs.removeAt(index);
    update([AppConstanst.attachment]);
    if (startDate == null &&
        endDate == null &&
        selectedReqType == null &&
        descriptionController.text.isEmpty &&
        docs.isEmpty) {
      disableSendReqBtn();
    }
  }

  bool validateAttachment(RequiredOptionalStatus status) {
    if (status == RequiredOptionalStatus.optional) {
      return true;
    }
    if (docs.isEmpty) {
      FlutterToastHelper.showToast(
        msg: 'Attachments Required'.tr,
        backgroundColor: AppColors.primary,
      );
      return false;
    }
    return true;
  }

//dropDown
  toggleArrow(bool? opened) {
    dropDownArrow = opened ?? false ? AppAssets.down : AppAssets.down;
    update([AppConstanst.requestDialog]);
  }

  selectReqType(RequestTypeModel value) {
    selectedReqType = value;
    update([AppConstanst.requestDialog]);
    enableSendReqBtn();
  }

  bool validateReqType() {
    if (selectedReqType == null) {
      FlutterToastHelper.showToast(
        msg: 'Request Type Required'.tr,
        backgroundColor: AppColors.primary,
      );
      return false;
    }
    return true;
  }

  bool validateDate() {
    if (startDate == null) {
      FlutterToastHelper.showToast(
        msg: 'Start Date Required'.tr,
        backgroundColor: AppColors.primary,
      );
      return false;
    } else if (endDate == null) {
      FlutterToastHelper.showToast(
        msg: 'End Date Required'.tr,
        backgroundColor: AppColors.primary,
      );
      return false;
    }
    return true;
  }

  bool validateDescription(RequiredOptionalStatus status) {
    if (status == RequiredOptionalStatus.optional) {
      return true;
    }
    if (descriptionController.text.isEmpty) {
      FlutterToastHelper.showToast(
        msg: 'Description Required'.tr,
        backgroundColor: AppColors.primary,
      );
      return false;
    }
    return true;
  }

  bool enabledSendReqBtn = false;
  enableSendReqBtn() {
    //check if already enabled to avoid unecessary rebuild
    if (!enabledSendReqBtn) {
      enabledSendReqBtn = true;
      update([AppConstanst.sendReqBtn]);
    }
  }

  disableSendReqBtn() {
    enabledSendReqBtn = false;
    update([AppConstanst.sendReqBtn]);
  }

//reset resources
  resetResources() {
    selectedReqType = null;
    endTimeController.clear();
    startTimeController.clear();
    endDateController.clear();
    startDateController.clear();
    descriptionController.clear();
    startDate = null;
    endDate = null;
    docs = [];
  }

  ///Filter Requests
  ///Calendar
  void filterCalendarRequests(DateTime date) {
    filteredRequests = aLLRequests
        .where(
          (element) =>
              element.requestDate.month == date.month &&
              element.requestDate.year == date.year,
        )
        .toList();
    update([AppConstanst.request]);
  }

  ///Filter Requests
  ///dialog
  void filterRequests(
      {DateTime? startDate,
      String? type,
      int? totalTimeMinutes,
      TimeFilter? period}) {
    // List<RequestModel> aLLRequestsFiltered =List.of(aLLRequests)  ;
    filteredRequests = aLLRequests;
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
      filteredRequests = filteredRequests
          .where((element) => (element.requestDate.year == 2024 &&
              element.requestDate.month == 10 &&
              element.requestDate.day == 14))
          .toList();
    }
    if (type != null) {
      filteredRequests = filteredRequests
          .where((element) => element.requestType == type)
          .toList();
    }

    if (totalTimeMinutes != null) {
      filteredRequests = filteredRequests
          .where((element) => element.totalTime.inMinutes == duration)
          .toList();
    }
    update([AppConstanst.request]);
  }

  /// Reset Filter Requests
  void resetFilterRequests() {
    filteredRequests = aLLRequests;
    update([AppConstanst.request]);
  }

  ///sort by total time and date
  void sortRequest(String? sortBy) {
    if (sortBy == SortFilter.totalTime.getName) {
      filteredRequests.sort((a, b) => b.totalTime.compareTo(a.totalTime));
    } else {
      filteredRequests.sort((a, b) => b.requestDate.compareTo(a.requestDate));
    }
    update([AppConstanst.request]);
  }

////End Of the Controller
}
