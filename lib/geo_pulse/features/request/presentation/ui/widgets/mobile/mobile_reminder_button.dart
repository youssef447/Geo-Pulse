import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/enums.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/helpers/get_dialog_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/dialog/default_dialog.dart';
import '../../../controller/requests_controller.dart';

/// This file is responsible for providing the default mobile reminder button widget .
class MobileReminderButton extends StatelessWidget {
  final int modelIndex;
  const MobileReminderButton({required this.modelIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackingRequestsController>(
        id: AppConstanst.reminder,
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              if (controller
                  .canSendReminder(controller.filteredRequests[modelIndex])) {
                controller.sendReminder(
                    controller.filteredRequests[modelIndex], modelIndex);
              } else {
                if (controller.filteredRequests[modelIndex].requestStatus ==
                    RequestStatus.pending) {
                  GetDialogHelper.generalDialog(
                    barrierDismissible: false,
                    child: DefaultDialog(
                      width: 343.w,
                      lottieAsset: AppAssets.notification,
                      title:
                          '${'A reminder was sent on'.tr} ${DateTimeHelper.formatDate(
                        controller
                            .filteredRequests[modelIndex].reminderSentDate!,
                      )}',
                      subTitle:
                          'You can only send a reminder once every two days . Feel free to contact your supervisor directly for assistance'
                              .tr,
                    ),
                    context: context,
                  );
                }
              }
            },
            child: Container(
              width: 25.w,
              height: 25.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: controller.canSendReminder(
                        controller.filteredRequests[modelIndex])
                    ? AppColors.primary
                    : AppColors.darkWhiteShadow,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: SvgPicture.asset(
                AppAssets.time,
                color: controller.canSendReminder(
                        controller.filteredRequests[modelIndex])
                    ? AppColors.icon
                    : AppColors.white,
              ),
            ),
          );
        });
  }
}
