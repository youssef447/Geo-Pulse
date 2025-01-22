import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/theme/app_font_weights.dart';
import '../../../../../attendance/presentation/controller/controller/attendance_controller.dart';
import '../../../../../request/presentation/controller/requests_controller.dart';
import '../../../../data/models/status_item_model.dart';
import '../../../controller/controller/tracking_home_controller.dart';
import 'status_item.dart';

/// Represents the status Row widget Wich is In Home Page.
class StatusRow extends GetView<TrackingHomeController> {
  final List<StatusItemModel> statusItems;
  final bool? attendance;

  const StatusRow({
    super.key,
    required this.statusItems,
    this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAttendance = attendance ?? false;

    return statusItems.isEmpty
        ? const SizedBox()
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
                margin: EdgeInsetsDirectional.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: context.isTablett ? 0 : 8.w,
                    bottom: 8.h,
                    top: 8.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(statusItems.length, (index) {
                      final currentItem = statusItems[index];

                      return GestureDetector(
                        onTap: () {
                          if (isAttendance) {
                            controller.currentAttendanceStatusIndex = index;
                            Get.find<TrackingAttendanceController>()
                                .filterAttendanceStatus(index);
                            controller.update([AppConstanst.home]);
                          } else {
                            controller.currentRequestStatusIndex = index;
                            Get.find<TrackingRequestsController>()
                                .filterRequestStatus(index);
                            controller.update([AppConstanst.home]);
                          }
                        },
                        child: StatusItem(
                          statusTextColor: currentItem.statusTextColor,
                          statusText: currentItem.statusText,
                          statusItemCount: isAttendance
                              ? Get.find<TrackingAttendanceController>()
                                  .filterAttendanceStatusCount(index)
                              : Get.find<TrackingRequestsController>()
                                  .filterRequestStatusCount(index),
                          isContainerPrimaryColor: isAttendance
                              ? controller.currentAttendanceStatusIndex == index
                              : controller.currentRequestStatusIndex == index,
                          fontWeight: isAttendance
                              ? controller.currentAttendanceStatusIndex == index
                                  ? AppFontWeights.extraBold
                                  : AppFontWeights.semiBold
                              : controller.currentRequestStatusIndex == index
                                  ? AppFontWeights.extraBold
                                  : AppFontWeights.semiBold,
                        ),
                      );
                    }),
                  ),
                )));
  }
}
