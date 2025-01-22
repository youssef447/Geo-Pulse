import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/core/constants/enums.dart';
import '../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../core/animations/horizontal_animation.dart';
import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/helpers/functions.dart';
import '../../../../../../../core/helpers/get_dialog_helper.dart';
import '../../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/fields/default_form_field.dart';
import '../../../../../../approvals/presentation/controller/tracking_approvals_controller.dart';
import '../../../../../../attendance/presentation/controller/controller/attendance_controller.dart';
import '../../../../../../location/presentation/controller/controller/location_controller.dart';
import '../../../../../../request/presentation/controller/requests_controller.dart';
import '../../../../../../request_type/presentation/controller/request_types_controller.dart';
import '../../../../controller/controller/tracking_home_controller.dart';
import '../../dialogs/filter/attendance_filter_dialog.dart';
import '../../dialogs/filter/req_filter.dart';
import '../../../../../../../core/widgets/cards/chip_card.dart';

/// Objectives: This file is responsible for providing the search filter widget which has search field and filter buttons.
class MobileFilter extends GetView<TrackingHomeController> {
  final VoidCallback? onButtonTap;
  final HomeTabs currentTab;
  final bool readOnly;

  const MobileFilter({
    super.key,
    this.onButtonTap,
    required this.currentTab,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    final isAttendnace = currentTab == HomeTabs.attendance;
    final isRequest = currentTab == HomeTabs.requests;
    final isApprovals = currentTab == HomeTabs.approvals;
    final isReqType = currentTab == HomeTabs.requstTypes;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 12.h,
      ),
      child: SlideAnimation(
        leftToRight: context.isArabic ? false : true,
        child: !isApprovals && !isAttendnace
            ? Column(
                children: [
                  SearchField(controller: controller, currentTab: currentTab),
                  if (!readOnly)
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 12.h),
                      child: GestureDetector(
                        onTap: onButtonTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 9.h,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: AppColors.primary,
                          ),
                          child: Text(
                            isRequest
                                ? 'Send Request'.tr
                                : isReqType
                                    ? 'Add Request Type'.tr
                                    : 'Add Location'.tr,
                            style: AppTextStyles.font16ButtonMediumCairo,
                          ),
                        ),
                      ),
                    ),
                  // verticalSpace(16),
                ],
              )
            : SearchField(controller: controller, currentTab: currentTab),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.currentTab,
  });

  final TrackingHomeController controller;
  final HomeTabs currentTab;
  @override
  Widget build(BuildContext context) {
    final isAttendnace = currentTab == HomeTabs.attendance;
    final isRequests = currentTab == HomeTabs.requests;
    final isApprovals = currentTab == HomeTabs.approvals;
    final isReqType = currentTab == HomeTabs.requstTypes;
    final isLocation = currentTab == HomeTabs.locations;
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              height: 40.h,
              child: AppTextFormField(
                maxLines: 1,
                hintText: 'Search Here...'.tr,
                collapsed: true,
                backGroundColor: AppTheme.isDark ?? false
                    ? AppColors.field
                    : AppColors.white,
                hintStyle: context.isTablett
                    ? AppTextStyles.font16BlackMediumCairo
                    : AppTextStyles.font12BlackCairo,
                controller: controller.searchController,
                onChanged: (value) {
                  if (isAttendnace) {
                    Get.find<TrackingAttendanceController>()
                        .searchAttendance(value);
                  } else if (isRequests) {
                    Get.find<TrackingRequestsController>().searchRequest(value);
                  } else if (isApprovals) {
                    Get.find<TrackingApprovalsController>()
                        .searchApprovalRequest(value);
                  } else if (isReqType) {
                    print('value $value');
                    Get.find<RequestTypeController>().searchRequestType(value);
                  } else if (isLocation) {
                    Get.find<LocationController>().searchLocation(value);
                  }
                },
                contentPadding: context.isTablett
                    ? EdgeInsets.symmetric(
                        vertical: 2.h,
                      )
                    : null,
                textAlign: TextAlign.start,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r)),
                prefixIcon: SvgPicture.asset(
                  AppAssets.search,
                  width: context.isTablett ? 24.w : 16.0.w,
                  height: context.isTablett ? 24.h : 16.0.h,
                ),
              ),
            ),
          ),
        ),
        if (!isReqType && !isLocation)
          Row(
            children: [
              horizontalSpace(8),
              ChipCard(
                image: AppAssets.sort,
                onTap: () {
                  HapticFeedbackHelper.triggerHapticFeedback(
                    vibration: VibrateType.mediumImpact,
                    hapticFeedback: HapticFeedback.mediumImpact,
                  );
                  GetDialogHelper.generalDialog(
                    child: isAttendnace
                        ? const AttendanceFilterDialog()
                        : const ReqFilterDialog(),
                    context: context,
                  );
                },
              ),
            ],
          ),
        horizontalSpace(8),
        ChipCard(
          image: AppAssets.export,
          onTap: () {
            HapticFeedbackHelper.triggerHapticFeedback(
              vibration: VibrateType.mediumImpact,
              hapticFeedback: HapticFeedback.mediumImpact,
            );
            exportTable();
          },
        ),
      ],
    );
  }
}
