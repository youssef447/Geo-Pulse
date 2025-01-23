import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../../../core/constants/enums.dart';

import '../../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../../core/constants/strings.dart';
import '../../../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../../core/widgets/buttons/app_text_button.dart';
import '../../../../../../../../core/widgets/buttons/default_switch_button.dart';
import '../../../../../../../location/presentation/controller/controller/location_controller.dart';
import '../../../../../controller/controller/check_in_controller.dart';
import '../../../../../controller/controller/tracking_home_controller.dart';

/// Representation: This is the mobile view of the check out dialog.
class MobileCheckOutDialog extends GetView<TrackingHomeController> {
  const MobileCheckOutDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInController>(
        id: AppConstanst.checkOutDialog,
        builder: (controller) {
          return Container(
            height: 330.h,
            width: 343.w,
            decoration: BoxDecoration(
              color: AppColors.dialog,
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 15.r,
                      child: SvgPicture.asset(
                        AppAssets.checkout,
                        color: AppColors.icon,
                      ),
                    ),
                    horizontalSpace(8),
                    Text(
                      'Check Out'.tr,
                      style: AppTextStyles.font18BlackMediumCairo,
                    ),
                  ],
                ),
                verticalSpace(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeFieldColumn(
                        'Start Time'.tr,
                        DateTimeHelper.formatTime(
                            controller.checkInTime.toDate())),
                    _buildTimeFieldColumn('End Time'.tr,
                        DateTimeHelper.formatTime(DateTime.now())),
                  ],
                ),
                verticalSpace(8),
                if (Get.find<LocationController>()
                    .locationModels[0]
                    .allowBreaksInAttendance) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Take a break'.tr,
                        style: AppTextStyles.font14BlackCairoRegular,
                      ),
                      DefaultSwitchButton(
                        value: controller.tookBreak,
                        onChanged: (value) {
                          controller.toggleTookBreak();
                        },
                      ),
                    ],
                  ),
                  Text(
                    '${'Did you take your'.tr} ${DateTimeHelper.formatInt(Get.find<LocationController>().locationModels[0].allowPeriodTimeNumber!)} ${Get.find<LocationController>().locationModels[0].allowPeriodTime?.getName == 'hrs' ? Get.locale.toString().contains('ar') ? 'ساعة' : 'Hours' : Get.locale.toString().contains('ar') ? 'دقيقة' : 'Minutes'} ${'break?'.tr}',
                    style: AppTextStyles.font12SecondaryBlackCairoRegular,
                  ),
                  verticalSpace(16),
                ],
                Text(
                  SortFilter.totalTime.getName.tr,
                  style: AppTextStyles.font14BlackCairoRegular,
                ),
                verticalSpace(16),
                AppTextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller.checkOut();
                    controller.toggleCheckIn();
                  },
                  width: double.infinity,
                  height: 40.h,
                  text: 'End Shift'.tr,
                  textStyle: AppTextStyles.font16ButtonMediumCairo,
                  backgroundColor: AppColors.primary,
                  borderRadius: 4.r,
                ),
              ],
            ),
          );
        });
  }

  _buildTimeFieldColumn(text, time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: AppTextStyles.font14BlackCairoMedium,
        ),
        verticalSpace(4),
        Container(
          width: 140.w,
          height: 38.h,
          decoration: BoxDecoration(
            color: AppColors.field,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(
              color: Colors.transparent,
              width: 1.w,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.all(8.w),
            child: Text(
              time,
              style: AppTextStyles.font12SecondaryBlackCairoRegular,
            ),
          ),
        ),
      ],
    );
  }
}
