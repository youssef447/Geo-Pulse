import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/enums.dart';

import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../controller/controller/attendance_controller.dart';

/// A card widget displaying detailed attendance data for a specific day.

class AttendanceMobileCard extends GetView<TrackingAttendanceController> {
  final int modelIndex;

  const AttendanceMobileCard({
    super.key,
    required this.modelIndex,
  });

  @override
  Widget build(BuildContext context) {
    final month = DateTimeHelper.formatDate(
            controller.attendanceDataModel[modelIndex].date)
        .split(' ')[0];
    final day = DateTimeHelper.formatDate(
            controller.attendanceDataModel[modelIndex].date)
        .split(' ')[1]
        .split(',')[0];
    final attendanceModel = controller.attendanceDataModel[modelIndex];
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 8.h,
      ),
      height: 82.h,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: attendanceModel.status.getColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40.h,
                width: 40.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: attendanceModel.status.getColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "$day\n",
                      style: AppTextStyles.font16BlackMediumCairo.copyWith(
                        color: attendanceModel.status.getColor,
                        fontWeight: FontWeight.w800,
                        height: 0.9,
                      ),
                      children: [
                        TextSpan(
                          text: month.toUpperCase(),
                          style: AppTextStyles.font14BlackRegularCairo.copyWith(
                            color: attendanceModel.status.getColor,
                            height: 0.9,
                          ),
                        )
                      ]),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  attendanceModel.status.getName.tr,
                  style: AppTextStyles.font14BlackRegularCairo
                      .copyWith(color: attendanceModel.status.getColor),
                ),
              ),
            ],
          ),
          _buildTimeColumn(
              "Check In".tr,
              attendanceModel.oncomingTime != null
                  ? DateTimeHelper.formatTime(
                      DateTimeHelper.formatTimeOfDayToDateTime(
                          attendanceModel.oncomingTime!, null))
                  : '_'),
          horizontalSpace(12),
          _buildTimeColumn(
              "Check Out".tr,
              attendanceModel.leavingTime != null
                  ? DateTimeHelper.formatTime(
                      DateTimeHelper.formatTimeOfDayToDateTime(
                          attendanceModel.leavingTime!, null))
                  : '_'),
          horizontalSpace(12),
          _buildTimeColumn(
              "Total Time".tr,
              attendanceModel.totalTime != null
                  ? DateTimeHelper.formatDuration(
                      attendanceModel.totalTime!,
                    )
                  : '_'),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(String label, String time) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.font12BlackCairoRegular
                .copyWith(color: AppColors.inputColor)),
        verticalSpace(18),
        Text(time, style: AppTextStyles.font14BlackRegularCairo),
      ],
    );
  }
}
