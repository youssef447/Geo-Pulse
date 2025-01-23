import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../../core/constants/strings.dart';
import '../../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../../core/widgets/dropdown/app_dropdown.dart';
import '../../../../../../../../core/widgets/fields/date_picker_field.dart';
import '../../../../../../../request_type/presentation/controller/request_types_controller.dart';
import '../../../../../controller/controller/tracking_home_controller.dart';

/// Representation: This is the date and type fields widget.
class DateTypeFields extends GetView<TrackingHomeController> {
  const DateTypeFields({
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
                            controller.tabController.index == 2
                                ? controller.dateReqController
                                : controller.dateApprovalsController,
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
                      'Type'.tr,
                      style: AppTextStyles.font14BlackCairoMedium,
                    ),
                    verticalSpace(7),
                    AppDropdown(
                      height: 40.h,
                      menuWidth: 311.w,
                      width: double.infinity,
                      value: controller.tabController.index == 2
                          ? controller.selectedReqType
                          : controller.selectedApprovalReqType,
                      textButton: controller.tabController.index == 2
                          ? context.isArabic
                              ? controller.selectedReqType?.arabicName ??
                                  'Leave Type'.tr
                              : controller.selectedReqType?.englishName ??
                                  'Leave Type'.tr
                          : context.isArabic
                              ? controller
                                      .selectedApprovalReqType?.arabicName ??
                                  'Leave Type'.tr
                              : controller
                                      .selectedApprovalReqType?.englishName ??
                                  'Leave Type'.tr,
                      items: Get.find<RequestTypeController>()
                          .requestTypeModels
                          .map((e) {
                        return DropdownMenuItem(
                          alignment: AlignmentDirectional.centerStart,
                          value: e,
                          child: Text(
                            context.isArabic ? e.arabicName : e.englishName,
                            style: AppTextStyles.font14SecondaryBlackCairo,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectReqType(value);
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
