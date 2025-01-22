import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/enums.dart';

import '../../features/approvals/presentation/constants/approvals_columns_name.dart';
import '../../features/approvals/presentation/controller/tracking_approvals_controller.dart';
import '../../features/attendance/presentation/constants/attendance_columns_name.dart';
import '../../features/attendance/presentation/controller/controller/attendance_controller.dart';
import '../../features/users/logic/add_employee_controller.dart';
import '../../features/home/presentation/controller/controller/tracking_home_controller.dart';
import '../../features/location/presentation/controller/controller/location_controller.dart';
import '../../features/location/presentation/ui/constants/location_columns_name.dart';
import '../../features/request/presentation/constants/request_columns_name.dart';
import '../../features/request/presentation/controller/requests_controller.dart';
import '../../features/request_type/presentation/constants/request_type_columns_name.dart';
import '../../features/request_type/presentation/controller/request_types_controller.dart';
import '../constants/app_assets.dart';
import 'date_time_helper.dart';
import 'share_helper.dart';

///This function is responsible for exporting the table data of the current screen to a pdf and sharing it.
///The function is called when the user clicks on the "Export" button in the bottom right corner of the screen.
Future<void> exportTable() async {
  TabController tabController =
      Get.find<TrackingHomeController>().tabController;
  //attendance
  if (tabController.index == 1) {
    final controller = Get.find<TrackingAttendanceController>();
    final headers = AttendanceColumnsName.attendanceColumnsName;

    final data = controller.attendanceDataModel.map((model) {
      return [
        DateTimeHelper.formatDate(model.date),
        model.status.getName.tr,
        model.oncomingTime == null
            ? '-'
            : DateTimeHelper.formatTime(
                DateTimeHelper.formatTimeOfDayToDateTime(
                    model.oncomingTime!, null),
              ),
        model.leavingTime == null
            ? '-'
            : DateTimeHelper.formatTime(
                DateTimeHelper.formatTimeOfDayToDateTime(
                    model.leavingTime!, null),
              ),
        model.breakTime == null
            ? '-'
            : DateTimeHelper.formatDuration(model.breakTime!),
        model.totalTime == null
            ? '-'
            : DateTimeHelper.formatDuration(model.totalTime!),
      ];
    }).toList();

    await ShareHelper.printDoc(data, headers);
  }
  //requests
  else if (tabController.index == 2) {
    final controller = Get.find<TrackingRequestsController>();
    final headers = RequestColumnsName.requestTableColumns
        .where(
          (element) => element.tr != 'Action'.tr,
        )
        .toList();

    final data = controller.filteredRequests.map((model) {
      return [
        DateTimeHelper.formatDate(model.requestDate),
        model.requestStatus.getName.tr,
        Get.locale.toString().contains('ar')
            ? model.requestType.arabicName
            : model.requestType.englishName,
        DateTimeHelper.formatDuration(model.totalTime),
        model.description ?? '-',
      ];
    }).toList();

    await ShareHelper.printDoc(data, headers);
  }
  //Approvals
  else if (tabController.index == 3) {
    final controller = Get.find<TrackingApprovalsController>();
    final headers = ApprovalsColumnsName.approvalsColumnsNameTab
        .where(
          (element) => element.tr != 'Action'.tr,
        )
        .toList();

    final data = controller.approvalRequests.map((model) {
      return [
        AppAssets.userProfile,
        Get.find<UserController>()
            .getEmployeeNameFirstOrLast(model.requestedUserId, true)
            .capitalize!,
        Get.find<UserController>()
            .getEmployeeNameFirstOrLast(model.requestedUserId, false)
            .capitalize!,
        DateTimeHelper.formatDate(model.requestDate),
        model.requestStatus.getName.tr,
        Get.locale.toString().contains('ar')
            ? model.requestType.arabicName
            : model.requestType.englishName,
        DateTimeHelper.formatDuration(model.totalTime),
      ];
    }).toList();

    List<Uint8List> images = [];

    final ByteData byteData = await rootBundle.load(AppAssets.userProfile);

    images = List.generate(
      Get.find<TrackingApprovalsController>().approvalRequests.length,
      (index) {
        return byteData.buffer.asUint8List();
      },
    );

    await ShareHelper.printDoc(
      data,
      headers,
      images,
    );
  }
  //Request Types
  else if (tabController.index == 4) {
    final controller = Get.find<RequestTypeController>();
    final headers = RequestTypeColumnsName.requestTypeColumnsName
        .where(
          (element) => element != '',
        )
        .toList();

    final data = controller.requestTypeModels.map((model) {
      return [
        model.englishName.tr,
        model.englishDescription,
        model.hrApproval.getName.tr,
        model.addingDescription.getName.tr,
        model.addingAttachments.getName.tr,
      ];
    }).toList();

    await ShareHelper.printDoc(data, headers);
  }
  //Locations
  else if (tabController.index == 5) {
    final controller = Get.find<LocationController>();
    final headers = LocationColumnsName.locationColumnsName
        .where(
          (element) => element != '',
        )
        .toList();

    final data = controller.locationModels.map((model) {
      return [
        model.locationNameEnglish,
        '${model.address.city}, ${model.address.country}',
        model.googleMapsLink,
        '${model.latitude} , ${model.longitude}',
        //   model.locationAccuracy.getName.tr,
        DateTimeHelper.formatInt(model.geoFencingPerimeter),
      ];
    }).toList();

    await ShareHelper.printDoc(data, headers);
  }
}
