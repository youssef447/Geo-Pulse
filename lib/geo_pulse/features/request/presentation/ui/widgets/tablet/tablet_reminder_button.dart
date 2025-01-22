import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/enums.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/helpers/get_dialog_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_font_weights.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/dialog/default_dialog.dart';
import '../../../controller/requests_controller.dart';

/// This file is responsible for providing the default Tablet reminder button widget .
class TabletReminderButton extends StatelessWidget {
  final int modelIndex;
  const TabletReminderButton({required this.modelIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackingRequestsController>(
        id: AppConstanst.reminder,
        builder: (controller) {
          final bool alreadySent = controller
              .canSendReminder(controller.filteredRequests[modelIndex]);
          return GestureDetector(
            onTap: () {
              if (alreadySent) {
                controller.sendReminder(
                    controller.filteredRequests[modelIndex], modelIndex);
              } else {
                if (controller.filteredRequests[modelIndex].requestStatus ==
                    RequestStatus.pending) {
                  GetDialogHelper.generalDialog(
                    barrierDismissible: false,
                    child: DefaultDialog(
                      width: context.isTablett ? 411.w : 343.w,
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
              height: 25.h,
              alignment: Alignment.center,
              width: 98.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                color:
                    alreadySent ? AppColors.darkWhiteShadow : AppColors.primary,
              ),
              child: Text(
                alreadySent ? 'Reminder Sent'.tr : 'Send Reminder'.tr,
                style: AppTextStyles.font12SecondaryBlackCairoMedium.copyWith(
                  color: alreadySent ? AppColors.white : AppColors.textButton,
                  fontWeight: AppFontWeights.regular,
                ),
              ),
            ),
          );
        });
  }
}
