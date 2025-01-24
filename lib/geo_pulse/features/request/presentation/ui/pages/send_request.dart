import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../core/extensions/extensions.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../core/helpers/spacing_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/dropdown/app_dropdown.dart';
import '../../../../../core/widgets/fields/date_fields_row.dart';
import '../../../../../core/widgets/fields/default_form_field.dart';
import '../../../../../core/widgets/fields/time_fields_row.dart';
import '../../../../request_type/presentation/controller/request_types_controller.dart';
import '../../controller/requests_controller.dart';
import '../widgets/attachments/dialog_attachments_section.dart';

///Send Request Dialog in Mobile , Tablet View
class SendRequest extends GetView<TrackingRequestsController> {
  const SendRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        controller.resetResources();
      },
      child: Container(
        width: context.isPhone ? 343.w : 603.w,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8.r),
        ),
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: GetBuilder<TrackingRequestsController>(
            id: AppConstanst.requestDialog,
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          HapticFeedbackHelper.triggerHapticFeedback(
                            vibration: VibrateType.mediumImpact,
                            hapticFeedback: HapticFeedback.mediumImpact,
                          );
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset(
                          context.isArabic
                              ? AppAssets.arrowForward
                              : AppAssets.arrowBack,
                          color: AppColors.text,
                          width: 24.w,
                          height: 24.h,
                        ),
                      ),
                      horizontalSpace(8),
                      Text(
                        'Send Request'.tr,
                        style: AppTextStyles.font16BlackMediumCairo,
                      ),
                    ],
                  ),
                  verticalSpace(24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request Type'.tr,
                        style: AppTextStyles.font14BlackCairoMedium,
                      ),
                      verticalSpace(16),
                      AppDropdown(
                        height: 40.h,
                        value: controller.selectedReqType,
                        textButton: context.isArabic
                            ? controller.selectedReqType?.arabicName ??
                                'Leave Type'.tr
                            : controller.selectedReqType?.englishName ??
                                'Leave Type'.tr,
                        items: Get.find<RequestTypeController>()
                            .requestTypeModels
                            .map((e) {
                          return DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: e,
                            child: Text(
                                context.isArabic ? e.arabicName : e.englishName,
                                style: AppTextStyles.font14BlackCairoMedium),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectReqType(value);
                        },
                      ),
                      verticalSpace(16),
                      DateFieldsRow(
                        endDateController: controller.endDateController,
                        onEndDateChanged: (date) {
                          controller.endDate = date;
                        },
                        onStartDateChanged: (date) {
                          controller.startDate = date;
                        },
                        startDateController: controller.startDateController,
                      ),
                    ],
                  ),
                  verticalSpace(16),
                  Row(
                    children: [
                      Checkbox(
                        value: controller.allDayValue,
                        onChanged: (value) => controller.toggleAllDay(),
                        checkColor: AppColors.white,
                        activeColor: AppColors.secondaryPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        side: BorderSide(color: AppColors.border),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: const VisualDensity(horizontal: -4),
                      ),
                      horizontalSpace(6),
                      Text(
                        'All Day'.tr,
                        style: AppTextStyles.font14BlackCairoMedium,
                      ),
                    ],
                  ),
                  horizontalSpace(60),
                  if (!controller.allDayValue)
                    TimeFieldsRow(
                      endTimeController: controller.endTimeController,
                      startTimeController: controller.startTimeController,
                    ),
                  verticalSpace(24),
                  Text(
                    'Request Description'.tr,
                    style: AppTextStyles.font16BlackMediumCairo,
                  ),
                  verticalSpace(8),
                  AppTextFormField(
                    hintText: 'Enter Description'.tr,
                    maxLength: 300,
                    maxLines: 4,
                    hintStyle: AppTextStyles.font12SecondaryBlackCairoRegular,
                    style: AppTextStyles.font12SecondaryBlackCairoRegular,
                    height: 110.h,
                    showBorder: true,
                    width: double.infinity,
                    controller: controller.descriptionController,
                  ),
                  verticalSpace(16),
                  const DialogAttachmentsSection(),
                  verticalSpace(16),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedbackHelper.triggerHapticFeedback(
                          vibration: VibrateType.mediumImpact,
                          hapticFeedback: HapticFeedback.mediumImpact,
                        );
                        controller.sendRequest(context);
                      },
                      child: Container(
                        height: 35.h,
                        width: context.isTablett ? 69.h : double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: AppColors.primary,
                        ),
                        child: Text(
                          'Send'.tr,
                          style: AppTextStyles.font14BlackCairoMedium
                              .copyWith(color: AppColors.textButton),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
