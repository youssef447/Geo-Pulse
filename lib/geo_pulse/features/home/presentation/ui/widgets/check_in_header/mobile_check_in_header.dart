import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tracking_module/tracking_module/features/users/logic/add_employee_controller.dart';

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

/// Represents the mobile check in header widget.
class MobileCheckInHeader extends GetView<TrackingHomeController> {
  const MobileCheckInHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckInController>(builder: (controller) {
      return !controller.checkIn
          ? Container(
              height: 140.h,
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.card),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: 28.r,
                            backgroundColor: AppColors.darkGrey,
                          ),
                          CircleAvatar(
                            radius: 25.r,
                            backgroundImage: Get.find<UserController>()
                                        .employee!
                                        .profileURL ==
                                    null
                                ? AssetImage(
                                    Get.find<UserController>()
                                        .getEmployeePhoto(),
                                  )
                                : NetworkImage(
                                    Get.find<UserController>()
                                        .getEmployeePhoto(),
                                  ),
                            backgroundColor: AppColors.darkGrey,
                          ),
                        ],
                      ),
                      horizontalSpace(4),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${Get.find<UserController>().employee!.firstName} ${Get.find<UserController>().employee!.lastName}',
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.font16TextMediumCairo),
                            Text(Get.find<UserController>().employee!.jobTitle,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles
                                    .font14SecondaryBlackCairoRegular),
                          ],
                        ),
                      ),
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
                          child: Text(
                            'Hide This Section'.tr,
                            style: AppTextStyles.font10BlueCairo,
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 40.h,
                          child: AppDefaultButton(
                            style: AppTextStyles.font14TextButtonCairoMedium,
                            radius: 8.r,
                            text: 'Check In'.tr,
                            width: 103.w,
                            onPressed: () async {
                              await controller.getCurrentLocation(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          : Container(
              height: 180.h,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.card),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Obx(() {
                    // Remaining seconds

                    return Text(
                      controller.formatTimer.value
                          ? DateTimeHelper.formatDuration(
                              Duration(
                                  seconds: controller.currentDuration.value),
                            )
                          : DateTimeHelper.formatDurationFromSeconds(
                              controller.currentDuration.value),
                      style: AppTextStyles.font28BlackSemiBoldCairo,
                    );
                  }),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Pause Button
                        if (Get.find<LocationController>()
                            .locationModels[0]
                            .allowPause) ...[
                          Obx(
                            () => AppDefaultButton(
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
                              width: 136.w,
                              style: AppTextStyles.font18BlackMediumCairo
                                  .copyWith(color: Colors.blue),
                              color: Colors.black,
                            ),
                          ),
                        ],
                        horizontalSpace(10),
                        AppDefaultButton(
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
                          width: 136.w,
                          style: AppTextStyles.font18BlackMediumCairo.copyWith(
                            color: AppColors.textButton,
                          ),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
    });
  }
}
