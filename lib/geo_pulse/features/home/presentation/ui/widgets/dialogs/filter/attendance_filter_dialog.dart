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
import 'fields/date_status_fields.dart';
import 'fields/time_period_fields.dart';

///Attendance Filter Dialog in Mobile, Tablet View

class AttendanceFilterDialog extends GetView<TrackingHomeController> {
  const AttendanceFilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
          const DateStatusFields(),
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
                        controller.resetAttendanceFilter();
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
                            context, AppConstanst.attendance);
                      },
                      child: Container(
                        height: 35.h,
                        width: 69.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          color: controller.enabledAttendanceApplyFilter
                              ? AppColors.primary
                              : AppColors.whiteShadow,
                        ),
                        child: Text(
                          'Apply'.tr,
                          style: AppTextStyles.font14BlackCairoMedium.copyWith(
                            color: controller.enabledAttendanceApplyFilter
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
