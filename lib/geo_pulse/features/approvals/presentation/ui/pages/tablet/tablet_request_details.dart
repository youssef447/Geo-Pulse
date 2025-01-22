import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/core/extensions/extensions.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';

import '../../../../../users/logic/add_employee_controller.dart';

import '../../../../../../core/constants/strings.dart';
import '../../../controller/tracking_approvals_controller.dart';
import '../../widgets/attachment_section.dart';
import '../../widgets/dropdown/status_dropdown.dart';

/// Description: This is the tablet view of the request details page.
class TabletRequestDetails extends GetView<TrackingApprovalsController> {
  final int index;
  const TabletRequestDetails({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final isLandScape = context.isLandscape;
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
          return Container(
            decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8.r)),
            margin: EdgeInsets.only(
              left: isLandScape ? 29.w : 16.w,
              right: isLandScape ? 50.w : 42.w,
              top: isLandScape ? 28.h : 24.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            child: Column(
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
                                      .approvalRequests[index].requestedUserId)
                                  .contains('assets')
                              ? AssetImage(Get.find<UserController>()
                                  .getEmployeePhoto(controller
                                      .approvalRequests[index].requestedUserId))
                              : NetworkImage(
                                  Get.find<UserController>().getEmployeePhoto(
                                      controller.approvalRequests[index]
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
                                controller
                                    .approvalRequests[index].requestedUserId,
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
                verticalSpace(46),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(AppAssets.calender),
                            horizontalSpace(8),
                            Text(
                              'Date Of Request:'.tr,
                              style:
                                  AppTextStyles.font18SecondaryBlackCairoMedium,
                            ),
                            horizontalSpace(6),
                            Text(
                              DateTimeHelper.formatDate(controller
                                  .approvalRequests[index].requestDate),
                              style: AppTextStyles.font18BlackCairoMedium,
                            ),
                          ],
                        ),
                        verticalSpace(26),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.report,
                              color: AppColors.secondaryBlack,
                            ),
                            horizontalSpace(8),
                            Text(
                              'Type:'.tr,
                              style:
                                  AppTextStyles.font18SecondaryBlackCairoMedium,
                            ),
                            horizontalSpace(6),
                            Text(
                              context.isArabic
                                  ? controller.approvalRequests[index]
                                      .requestType.arabicName
                                  : controller.approvalRequests[index]
                                      .requestType.englishName,
                              style: AppTextStyles.font18BlackCairoMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StatusDropDown(index: index),
                        verticalSpace(26),
                        Row(
                          children: [
                            SvgPicture.asset(AppAssets.duration),
                            horizontalSpace(8),
                            Text(
                              'Total Time:'.tr,
                              style:
                                  AppTextStyles.font18SecondaryBlackCairoMedium,
                            ),
                            horizontalSpace(6),
                            Text(
                              DateTimeHelper.formatDuration(
                                  controller.approvalRequests[index].totalTime),
                              style: AppTextStyles.font18BlackCairoMedium,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                verticalSpace(32),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.report,
                      color: AppColors.secondaryBlack,
                    ),
                    horizontalSpace(8),
                    Text(
                      'Request Description:'.tr,
                      style: AppTextStyles.font18SecondaryBlackCairoMedium,
                    ),
                    horizontalSpace(6),
                    if (controller.approvalRequests[index].description != null)
                      Expanded(
                        child: Text(
                          controller.approvalRequests[index].description!,
                          style: AppTextStyles.font14BlackRegularCairo,
                        ),
                      ),
                  ],
                ),
                verticalSpace(32),
                AttachmentSection(index: index),
              ],
            ),
          );
        },
      ),
    );
  }
}
