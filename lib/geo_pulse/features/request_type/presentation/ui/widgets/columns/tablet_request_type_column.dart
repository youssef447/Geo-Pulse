import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/enums.dart';
import '../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/buttons/app_text_button.dart';
import '../../../../../../core/widgets/dropdown/app_dropdown.dart';
import '../../../../../../features/request_type/presentation/controller/request_types_controller.dart';

import '../availability_chips.dart';
import '../dropdown/availability_dropdown.dart';
import '../fields/label_form_field.dart';

/// Objectives: This file is responsible for providing the tablet request type column widget used when adding or editing a request type.

class TabletRequestTypeColumn extends GetView<RequestTypeController> {
  final String title;
  final bool editEnabled;

  const TabletRequestTypeColumn({
    super.key,
    required this.title,
    required this.editEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<RequestTypeController>(
          id: 'requestTypeColumn',
          builder: (controller) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                          title,
                          style: AppTextStyles.font20BlackMediumCairo,
                        ),
                      ],
                    ),
                    verticalSpace(16),
                    Row(
                      children: [
                        Expanded(
                          child: LabelFormField(
                            helperText: '  ',
                            editEnabled: editEnabled,
                            text: 'Request Name',
                            hintText: 'Text Here',
                            textController:
                                controller.requestTypeEnglishNameController,
                            crossA: context.isArabic
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                          ),
                        ),
                        horizontalSpace(16),
                        Expanded(
                          child: LabelFormField(
                            helperText: '  ',
                            editEnabled: editEnabled,
                            text: 'اسم الطلب',
                            hintText: 'اكتب هنا',
                            textController:
                                controller.requestTypeArabicNameController,
                            isRTL: true,
                            crossA: context.isArabic
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(8),
                    LabelFormField(
                      editEnabled: editEnabled,
                      text: 'Request Description',
                      hintText: 'Text Here',
                      textController:
                          controller.requestTypeEnglishDescriptionController,
                      maxLength: 500,
                      expand: true,
                      crossA: context.isArabic
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                    ),
                    verticalSpace(16),
                    LabelFormField(
                      editEnabled: editEnabled,
                      text: 'وصف الطلب',
                      hintText: 'اكتب هنا',
                      textController:
                          controller.requestTypeArabicDescriptionController,
                      isRTL: true,
                      maxLength: 500,
                      expand: true,
                      crossA: context.isArabic
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.end,
                    ),
                    verticalSpace(16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'HR Approval'.tr,
                                style: AppTextStyles.font14BlackCairoMedium,
                              ),
                              verticalSpace(8),
                              AppDropdown(
                                height: 40.h,
                                showDropdownIcon: editEnabled,
                                value: controller.hrApprovalStatus,
                                textButton: controller.hrApprovalStatus == null
                                    ? 'Choose Here'.tr
                                    : controller.hrApprovalStatus!.getName.tr,
                                items: editEnabled
                                    ? requiredOptionalStatusList.map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: buildMenuItem(e.getName),
                                        );
                                      }).toList()
                                    : [],
                                onChanged: (value) {
                                  controller.setHrApprovalStatus(value);
                                },
                              ),
                            ],
                          ),
                        ),
                        horizontalSpace(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Adding Description'.tr,
                                style: AppTextStyles.font14BlackCairoMedium,
                              ),
                              verticalSpace(8),
                              AppDropdown(
                                height: 40.h,
                                showDropdownIcon: editEnabled,
                                value: controller.addingDescriptionStatus,
                                textButton:
                                    controller.addingDescriptionStatus == null
                                        ? 'Choose Here'.tr
                                        : controller.addingDescriptionStatus!
                                            .getName.tr,
                                items: editEnabled
                                    ? requiredOptionalStatusList.map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: buildMenuItem(e.getName),
                                        );
                                      }).toList()
                                    : [],
                                onChanged: (value) {
                                  controller.setAddingDescriptionStatus(value);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Adding Attachments'.tr,
                                style: AppTextStyles.font14BlackCairoMedium,
                              ),
                              verticalSpace(8),
                              AppDropdown(
                                height: 40.h,
                                showDropdownIcon: editEnabled,
                                value: controller.addingAttachmentStatus,
                                textButton:
                                    controller.addingAttachmentStatus == null
                                        ? 'Choose Here'.tr
                                        : controller
                                            .addingAttachmentStatus!.getName.tr,
                                items: editEnabled
                                    ? requiredOptionalStatusList.map((e) {
                                        return DropdownMenuItem(
                                          value: e,
                                          child: buildMenuItem(e.getName),
                                        );
                                      }).toList()
                                    : [],
                                onChanged: (value) {
                                  controller.setAddingAttachmentStatus(value);
                                },
                              ),
                            ],
                          ),
                        ),
                        horizontalSpace(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Availability'.tr,
                                style: AppTextStyles.font14BlackCairoMedium,
                              ),
                              verticalSpace(8),
                              Column(
                                children: [
                                  if (editEnabled)
                                    AvailabilityDropdown(
                                        editEnabled: editEnabled),
                                  if (!editEnabled)
                                    // show only if not adding or editing
                                    AvailabilityChips(
                                      isAddingNewRequestType: editEnabled,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (editEnabled)
                      Obx(
                        () => Padding(
                          padding: EdgeInsetsDirectional.only(top: 20.h),
                          child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: AppTextButton(
                              onPressed: () {
                                if (controller.isValid.value) {
                                  controller.saveRequestType();
                                }
                              },
                              width: 90.w,
                              height: 40.h,
                              text: 'Save'.tr,
                              textStyle:
                                  AppTextStyles.font18BlackCairoMedium.copyWith(
                                color: controller.isValid.value
                                    ? AppColors.textButton
                                    : AppColors.black,
                              ),
                              backgroundColor: controller.isValid.value
                                  ? AppColors.primary
                                  : AppColors.whiteShadow,
                              borderRadius: 4.r,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  buildMenuItem(String text) {
    return Text(
      text.tr,
      style: AppTextStyles.font14SecondaryBlackCairo,
    );
  }
}
