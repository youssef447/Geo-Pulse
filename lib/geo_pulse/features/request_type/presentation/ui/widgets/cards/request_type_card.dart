import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../controller/request_types_controller.dart';
import '../request_type_dropdown_button.dart';

/// Objectives: This file is responsible for providing the request type card widget.

class RequestTypeCard extends GetView<RequestTypeController> {
  final int modelIndex;
  final bool readOnly;
  const RequestTypeCard({
    super.key,
    required this.modelIndex,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.only(
        start: 16.w,
        end: 10.w,
        bottom: 12.h,
        top: 12.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: AppColors.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.isArabic
                    ? controller.requestTypeModels[modelIndex].arabicName
                    : controller.requestTypeModels[modelIndex].englishName,
                style: AppTextStyles.font16BlackMediumCairo,
              ),
              const Spacer(),
              if (!readOnly)
                RequestTypeDropdownButton(
                  index: modelIndex,
                ),
            ],
          ),
          verticalSpace(16),
          Text(
            'Description'.tr,
            style: AppTextStyles.font14SecondaryBlackCairo,
          ),
          verticalSpace(4),
          Text(
            context.isArabic
                ? controller.requestTypeModels[modelIndex].arabicDescription
                : controller.requestTypeModels[modelIndex].englishDescription,
            style: AppTextStyles.font14BlackCairoMedium,
          ),
          verticalSpace(10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Hr Approval  '.tr,
                style: AppTextStyles.font14SecondaryBlackCairo,
                children: [
                  TextSpan(
                    text: controller
                        .requestTypeModels[modelIndex].hrApproval.name.tr,
                    style: AppTextStyles.font14BlackCairoMedium,
                  )
                ]),
          ),
          verticalSpace(8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Adding Description  '.tr,
                style: AppTextStyles.font14SecondaryBlackCairo,
                children: [
                  TextSpan(
                    text: controller.requestTypeModels[modelIndex]
                        .addingDescription.name.tr,
                    style: AppTextStyles.font14BlackCairoMedium,
                  )
                ]),
          ),
          verticalSpace(8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: 'Adding Attachment  '.tr,
                style: AppTextStyles.font14SecondaryBlackCairo,
                children: [
                  TextSpan(
                    text: controller.requestTypeModels[modelIndex]
                        .addingAttachments.name.tr,
                    style: AppTextStyles.font14BlackCairoMedium,
                  )
                ]),
          ),
        ],
      ),
    );
  }
}
