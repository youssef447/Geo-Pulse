import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../core/constants/enums.dart';

import '../../../../../../../../core/constants/strings.dart';
import '../../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../../core/widgets/dropdown/app_dropdown.dart';
import '../../../../../../../../core/widgets/fields/default_form_field.dart';
import '../../../../../controller/controller/tracking_home_controller.dart';
import 'apporvals_status_dropdown.dart';

/// Date: 4/10/2024
/// By: Youssef Ashraf
/// Representation: This is the Time and Period fields widget.
///Shared across all tabs filter to select total time for a specific period
class TimePeriodFields extends GetView<TrackingHomeController> {
  const TimePeriodFields({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackingHomeController>(
        id: AppConstanst.filterDialog,
        builder: (controller) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SortFilter.totalTime.getName.tr,
                      style: AppTextStyles.font14BlackCairoMedium,
                    ),
                    verticalSpace(7),
                    SizedBox(
                      height: 40.h,
                      child: AppTextFormField(
                        hintText: SortFilter.totalTime.getName.tr,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 8.h,
                        ),
                        hintStyle:
                            AppTextStyles.font12SecondaryBlackCairoRegular,
                        style: AppTextStyles.font14BlackCairoRegular,
                        showBorder: true,
                        maxLines: 1,
                        width: double.infinity,
                        controller: controller.tabController.index == 1
                            ? controller.totalTimeAttendanceController
                            : controller.tabController.index == 2
                                ? controller.totalTimeReqController
                                : controller.totalTimeApprovalsController,
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            controller.enableFilterBtn();
                          } else {
                            controller.disableFilterBtn();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.tabController.index == 3)
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 18.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Request Status'.tr,
                          style: AppTextStyles.font14BlackCairoMedium,
                        ),
                        verticalSpace(7),
                        const ApporvalsStatusDropdown(),
                      ],
                    ),
                  ),
                ),
              horizontalSpace(18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Period'.tr,
                      style: AppTextStyles.font14BlackCairoMedium,
                    ),
                    verticalSpace(7),
                    AppDropdown(
                      height: 40.h,
                      value: controller.tabController.index == 1
                          ? controller.timeAttendanceFilter
                          : controller.tabController.index == 2
                              ? controller.timeReqFilter
                              : controller.timeApprovalsFilter,
                      textButton: controller.tabController.index == 1
                          ? controller.timeAttendanceFilter?.getName.tr ??
                              'Select Period'.tr
                          : controller.tabController.index == 2
                              ? controller.timeReqFilter?.getName.tr ??
                                  'Select Period'.tr
                              : controller.timeApprovalsFilter?.getName.tr ??
                                  'Select Period'.tr,
                      items: controller.filterTypes.map((e) {
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
                        controller.onTimeFilterChanged(value);
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
