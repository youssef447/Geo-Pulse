import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/constants/strings.dart';
import '../../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../controller/controller/tracking_home_controller.dart';
import 'fields/date_type_fields.dart';
import 'fields/time_period_fields.dart';

///Req Filter Dialog in Tablet , Mobile View

class ReqFilterDialog extends GetView<TrackingHomeController> {
  const ReqFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isReq = controller.tabController.index == 2;
    return Container(
      width: context.isTablett ? 603.w : 343.w,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.dialog,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.secondaryPrimary,
                radius: 15.r,
                child: SvgPicture.asset(
                  AppAssets.sort,
                  height: 16.h,
                  width: 16.w,
                  color: AppColors.icon,
                ),
              ),
              horizontalSpace(8),
              Text(
                'Filter'.tr,
                style: AppTextStyles.font16BlackMediumCairo,
              ),
            ],
          ),
          verticalSpace(11),
          const DateTypeFields(),
          verticalSpace(16),
          const TimePeriodFields(),
          verticalSpace(16),
          GetBuilder<TrackingHomeController>(
              id: AppConstanst.filterBtn,
              builder: (controller) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        HapticFeedbackHelper.triggerHapticFeedback(
                          vibration: VibrateType.mediumImpact,
                          hapticFeedback: HapticFeedback.mediumImpact,
                        );
                        controller.tabController.index == 2
                            ? controller.resetReqFilter()
                            : controller.resetApprovalsFilter();
                      },
                      child: Container(
                        height: 35.h,
                        width: 69.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: AppColors.darkWhite,
                        ),
                        child: Text(
                          'Reset'.tr,
                          style: AppTextStyles.font14BlackCairoMedium.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        HapticFeedbackHelper.triggerHapticFeedback(
                          vibration: VibrateType.mediumImpact,
                          hapticFeedback: HapticFeedback.mediumImpact,
                        );
                        controller.applyFilter(
                            context,
                            isReq
                                ? AppConstanst.request
                                : AppConstanst.approvals);
                      },
                      child: Container(
                        height: 35.h,
                        width: 69.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: isReq
                              ? controller.enabledRequestApplyFilter
                                  ? AppColors.primary
                                  : AppColors.whiteShadow
                              : controller.enabledApprovalApplyFilter
                                  ? AppColors.primary
                                  : AppColors.whiteShadow,
                        ),
                        child: Text(
                          'Apply'.tr,
                          style: AppTextStyles.font14BlackCairoMedium.copyWith(
                            color: isReq
                                ? controller.enabledRequestApplyFilter
                                    ? AppColors.textButton
                                    : AppColors.black
                                : controller.enabledApprovalApplyFilter
                                    ? AppColors.textButton
                                    : AppColors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
