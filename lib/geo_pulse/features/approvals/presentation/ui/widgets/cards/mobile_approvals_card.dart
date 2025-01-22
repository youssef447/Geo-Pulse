import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/constants/enums.dart';

import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/routes/route_arguments.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../users/logic/add_employee_controller.dart';
import '../../../controller/tracking_approvals_controller.dart';
import '../buttons/approve_buttons.dart';

///Approvals Card in Mobile View
class MobileApprovalsCard extends GetView<TrackingApprovalsController> {
  final int index;
  final bool readOnly;
  MobileApprovalsCard({super.key, required this.index, required this.readOnly});
//todo change mode
  final bool hr =
      Get.find<UserController>().employee!.position == UserPosition.hr;

  @override
  Widget build(BuildContext context) {
    final date = DateTimeHelper.formatDate(
        controller.approvalRequests[index].requestDate);
    final time = DateTimeHelper.formatTime(
        controller.approvalRequests[index].requestDate);
    return GestureDetector(
      onTap: () {
        HapticFeedbackHelper.triggerHapticFeedback(
          vibration: VibrateType.mediumImpact,
          hapticFeedback: HapticFeedback.mediumImpact,
        );
        controller.selectedReqStatus =
            controller.approvalRequests[index].requestStatus;
        context.navigateTo(
          Routes.requestDetails,
          arguments: {
            RouteArguments.requestModelIndex: index,
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 82.h,
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          border: Border.all(
            color: controller.approvalRequests[index].requestStatus.getColor,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 35.h,
                  width: 35.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: Get.find<UserController>()
                              .getEmployeePhoto(controller
                                  .approvalRequests[index].requestedUserId)
                              .contains('assets')
                          ? AssetImage(Get.find<UserController>()
                              .getEmployeePhoto(controller
                                  .approvalRequests[index].requestedUserId))
                          : NetworkImage(
                              Get.find<UserController>().getEmployeePhoto(
                                  controller
                                      .approvalRequests[index].requestedUserId),
                            ),
                    ),
                  ),
                ),
                Text(
                  Get.find<UserController>().getEmployeeName(
                      controller.approvalRequests[index].requestedUserId),
                  overflow: TextOverflow.ellipsis,
                  style:
                      AppTextStyles.font12BlackCairoRegular.copyWith(height: 1),
                ),
                Text(
                  '$date ${'at'.tr} $time',
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.font8SecondaryBlackRegularCairo,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0.h),
              child: SizedBox(
                width: 70.w,
                child: _buildLabelColumn(
                  "Type".tr,
                  context.isArabic
                      ? controller
                          .approvalRequests[index].requestType.arabicName
                      : controller
                          .approvalRequests[index].requestType.englishName,
                ),
              ),
            ),
            _buildLabelColumn("Status".tr,
                controller.approvalRequests[index].requestStatus.getName.tr),
            if (controller.approvalRequests[index].requestStatus ==
                    RequestStatus.pending &&
                hr)
              Row(
                children: [
                  horizontalSpace(20),
                  if (!readOnly)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Action".tr,
                            style:
                                AppTextStyles.font12BlackCairoRegular.copyWith(
                              color: AppColors.inputColor,
                            )),
                        ApproveButtons(
                          modelIndex: index,
                        ),
                      ],
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          label,
          style: AppTextStyles.font12BlackCairoRegular
              .copyWith(color: AppColors.inputColor),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.font12BlackCairoRegular
                .copyWith(color: value.getColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
