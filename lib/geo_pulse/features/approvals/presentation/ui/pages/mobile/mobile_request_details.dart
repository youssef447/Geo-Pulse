import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/core/extensions/extensions.dart';

import '../../../../../../core/animations/scale_animation.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/appbar/custom_app_bar.dart';
import '../../../../../users/logic/add_employee_controller.dart';
import '../../../controller/tracking_approvals_controller.dart';
import '../../widgets/attachment_section.dart';
import '../../widgets/dropdown/status_dropdown.dart';

/// Description: This is the mobile view of the request details page.
class MobileRequestDetails extends GetView<TrackingApprovalsController> {
  final int index;
  const MobileRequestDetails({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: context.isArabic
            ? controller.approvalRequests[index].requestType.arabicName
            : controller.approvalRequests[index].requestType.englishName,
        centerTitle: false,
      ),
      body: GetBuilder<TrackingApprovalsController>(
        id: AppConstanst.requestDetails,
        builder: (controller) {
          return ScaleAnimation(
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8.r)),
              margin: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.w,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 64.h,
                          width: 64.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            image: DecorationImage(
                              image: Get.find<UserController>()
                                      .getEmployeePhoto(controller
                                          .approvalRequests[index]
                                          .requestedUserId)
                                      .contains('assets')
                                  ? AssetImage(Get.find<UserController>()
                                      .getEmployeePhoto(controller
                                          .approvalRequests[index]
                                          .requestedUserId))
                                  : NetworkImage(
                                      Get.find<UserController>()
                                          .getEmployeePhoto(controller
                                              .approvalRequests[index]
                                              .requestedUserId),
                                    ),
                            ),
                          ),
                        ),
                        horizontalSpace(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Get.find<UserController>()
                                  .getEmployeeName(
                                    controller.approvalRequests[index]
                                        .requestedUserId,
                                  )
                                  .capitalize!,
                              style: AppTextStyles.font18BlackCairoRegular,
                            ),
                            Text(
                              Get.find<UserController>()
                                  .getEmployeeJobTitle(controller
                                      .approvalRequests[index].requestedUserId)
                                  .capitalize!,
                              style: AppTextStyles.font14BlackCairoRegular,
                            ),
                          ],
                        )
                      ],
                    ),
                    verticalSpace(47),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.calender,
                          width: 16.w,
                          height: 16.h,
                        ),
                        horizontalSpace(8),
                        Text(
                          'Date Of Request:'.tr,
                          style: AppTextStyles.font14SecondaryBlackCairo,
                        ),
                        horizontalSpace(6),
                        Text(
                          DateTimeHelper.formatDate(
                              controller.approvalRequests[index].requestDate),
                          style: AppTextStyles.font14BlackCairoMedium,
                        ),
                      ],
                    ),
                    verticalSpace(22),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.report,
                          color: AppColors.secondaryBlack,
                        ),
                        horizontalSpace(8),
                        Text(
                          'Type:'.tr,
                          style: AppTextStyles.font14SecondaryBlackCairo,
                        ),
                        horizontalSpace(6),
                        Flexible(
                          child: Text(
                            context.isArabic
                                ? controller.approvalRequests[index].requestType
                                    .arabicName
                                : controller.approvalRequests[index].requestType
                                    .englishName,
                            style: AppTextStyles.font14BlackCairoMedium,
                          ),
                        ),
                      ],
                    ),
                    verticalSpace(22),
                    StatusDropDown(index: index),
                    verticalSpace(22),
                    Row(
                      children: [
                        SvgPicture.asset(AppAssets.duration),
                        horizontalSpace(8),
                        Text(
                          'Total Time:'.tr,
                          style: AppTextStyles.font14SecondaryBlackCairo,
                        ),
                        horizontalSpace(6),
                        Text(
                          DateTimeHelper.formatDuration(
                              controller.approvalRequests[index].totalTime),
                          style: AppTextStyles.font14BlackCairoMedium,
                        ),
                      ],
                    ),
                    verticalSpace(22),
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.report,
                          color: AppColors.secondaryBlack,
                        ),
                        horizontalSpace(8),
                        Text(
                          'Request Description:'.tr,
                          style: AppTextStyles.font14SecondaryBlackCairo,
                        ),
                      ],
                    ),
                    verticalSpace(6),
                    if (controller.approvalRequests[index].description != null)
                      Text(
                        controller.approvalRequests[index].description!,
                        style: AppTextStyles.font14BlackCairoMedium,
                      ),
                    verticalSpace(32),
                    AttachmentSection(index: index),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
