import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../../../../../users/logic/add_employee_controller.dart';

import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/helpers/get_dialog_helper.dart';
import '../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/buttons/app_default_button.dart';
import '../../../../../../core/widgets/responsive/adaptive_layout.dart';
import '../../../../../location/presentation/controller/controller/location_controller.dart';
import '../../../controller/controller/check_in_controller.dart';
import '../../../controller/controller/tracking_home_controller.dart';
import '../dialogs/check_out/mobile/mobile_check_out_dialog.dart';
import '../dialogs/check_out/tablet/tablet_check_out_dialog.dart';

/// Represents the Tablet check in header widget.
class TabletCheckInHeader extends GetView<TrackingHomeController> {
  const TabletCheckInHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInController>(builder: (controller) {
      return Container(
        height: 130.h,
        width: double.infinity,
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r), color: AppColors.card),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 53.r,
                  backgroundColor: AppColors.darkGrey,
                ),
                CircleAvatar(
                  radius: 50.r,
                  backgroundImage:
                      Get.find<UserController>().employee!.profileURL == null
                          ? AssetImage(
                              Get.find<UserController>().getEmployeePhoto(),
                            )
                          : NetworkImage(
                              Get.find<UserController>().getEmployeePhoto(),
                            ),
                  backgroundColor: AppColors.darkGrey,
                ),
              ],
            ),
            horizontalSpace(24),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Get.find<UserController>().getEmployeeName().capitalize!,
                  style: AppTextStyles.font21BlackMediumCairo,
                ),
                verticalSpace(16),
                Text(
                    Get.find<UserController>()
                        .getEmployeeJobTitle()
                        .capitalize!,
                    style: AppTextStyles.font16SecondaryBlackCairoMedium),
              ],
            ),
            const Spacer(),
            !controller.checkIn
                ? Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.toggleShowHeader();
                            HapticFeedbackHelper.triggerHapticFeedback(
                              vibration: VibrateType.mediumImpact,
                              hapticFeedback: HapticFeedback.mediumImpact,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                              color: AppColors.blue,
                              width: 1.5.w,
                            ))),
                            child: Text('Hide This Section'.tr,
                                style: AppTextStyles.font12BlackCairo.copyWith(
                                  color: AppColors.blue,
                                )),
                          ),
                        ),
                        verticalSpace(32),
                        AppDefaultButton(
                          style: AppTextStyles.font14TextButtonCairoMedium,
                          text: 'Check In'.tr,
                          width: 250.w,
                          onPressed: () async {
                            await controller.getCurrentLocation(context);
                          },
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.formatTime();
                              },
                              child: Text(
                                controller.formatTimer.value
                                    ? 'Show Timer'
                                    : 'Format Timer',
                                style: AppTextStyles.font14BlackCairoRegular
                                    .copyWith(color: AppColors.red),
                              ),
                            ),
                            Text(
                              controller.formatTimer.value
                                  ? DateTimeHelper.formatDuration(
                                      Duration(
                                          seconds:
                                              controller.currentDuration.value),
                                    )
                                  : DateTimeHelper.formatDurationFromSeconds(
                                      controller.currentDuration.value),
                              style: AppTextStyles.font28BlackSemiBoldCairo,
                            ),
                          ],
                        );
                      }),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Pause Button
                            if (Get.find<LocationController>()
                                .locationModels[0]
                                .allowPause)
                              Obx(
                                () => Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(end: 10.w),
                                  child: AppDefaultButton(
                                    height: 40.h,
                                    onPressed: () {
                                      if (controller.isRunning.value) {
                                        // Pause stopwatch
                                        controller.pauseStopwatch();
                                      } else if (controller.isPaused.value) {
                                        // Resume stopwatch
                                        controller.resumeStopwatch();
                                      }
                                    },
                                    text: controller.isPaused.value
                                        ? 'Resume'.tr
                                        : 'Pause'.tr,
                                    width: 136,
                                    style: AppTextStyles.font18BlackMediumCairo
                                        .copyWith(color: Colors.blue),
                                    color: Colors.black,
                                  ),
                                ),
                              ),

                            AppDefaultButton(
                              height: 40.h,
                              onPressed: () {
                                GetDialogHelper.generalDialog(
                                  child: AdaptiveLayout(
                                    mobileLayout: (context) =>
                                        const MobileCheckOutDialog(),
                                    tabletLayout: (context) =>
                                        const TabletCheckOutDialog(),
                                  ),
                                  context: context,
                                );
                              },
                              text: 'Check Out'.tr,
                              width: 136,
                              style:
                                  AppTextStyles.font18BlackMediumCairo.copyWith(
                                color: AppColors.textButton,
                              ),
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      );
    });
  }
}
