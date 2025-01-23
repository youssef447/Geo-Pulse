import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../core/constants/enums.dart';

import '../../../../../../../../core/constants/strings.dart';
import '../../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../../core/widgets/dropdown/app_dropdown.dart';
import '../../../../../../../../core/widgets/fields/date_picker_field.dart';
import '../../../../../controller/controller/tracking_home_controller.dart';

/// Representation: This is the date and status fields widget.
class DateStatusFields extends GetView<TrackingHomeController> {
  const DateStatusFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackingHomeController>(
        id: AppConstanst.filterDialog,
        builder: (controller) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Date'.tr,
                      style: AppTextStyles.font14BlackCairoMedium,
                    ),
                    verticalSpace(7),
                    SizedBox(
                      height: 40.h,
                      child: DatePickerField(
                        width: double.infinity,
                        onDateChanged: (date) {
                          controller.onDateChanged(date);
                        },
                        textEditingController:
                            controller.dateAttendanceController,
                        hintText: 'Choose Date'.tr,
                      ),
                    ),
                  ],
                ),
              ),
              horizontalSpace(18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status'.tr,
                      style: AppTextStyles.font14BlackCairoMedium,
                    ),
                    verticalSpace(7),
                    AppDropdown(
                      height: 40.h,
                      width: double.infinity,
                      value: controller.attendanceStatus,
                      textButton: controller.attendanceStatus?.getName.tr ??
                          'status'.tr,
                      items: AttendanceStatus.values.map((e) {
                        return DropdownMenuItem(
                          alignment: AlignmentDirectional.centerStart,
                          value: e,
                          child: Text(
                            e.getName.tr,
                            style: AppTextStyles.font14SecondaryBlackCairo,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectAttendanceStatus(value);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
