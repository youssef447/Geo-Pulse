import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/constants/enums.dart';
import '../../../../../../../core/constants/strings.dart';

import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/theme/app_theme.dart';
import '../../../../../../../core/widgets/dropdown/default_dropdown.dart';
import '../../../../../../approvals/presentation/controller/tracking_approvals_controller.dart';
import '../../../../../../attendance/presentation/controller/controller/attendance_controller.dart';
import '../../../../../../request/presentation/controller/requests_controller.dart';
import '../../../../controller/controller/tracking_home_controller.dart';
import '../../../../../../../core/widgets/cards/chip_card.dart';

/// Objectives: This file is responsible for providing the calender filter widget which has search field and sort button.

class CalenderFilter extends GetView<TrackingHomeController> {
  final HomeTabs currentTab;

  const CalenderFilter({
    super.key,
    required this.currentTab,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                GetBuilder<TrackingHomeController>(
                    id: AppConstanst.home,
                    builder: (controller) {
                      return TableCalendar(
                        onPageChanged: (focusedDay) {
                          controller.filterMonth(focusedDay);
                        },
                        firstDay: DateTime(2010, 10, 16),
                        lastDay: DateTime(2030, 3, 14),
                        focusedDay: currentTab == HomeTabs.attendance
                            ? controller.selectedAttendanceDate ??
                                DateTime.now()
                            : currentTab == HomeTabs.requests
                                ? controller.selectedReqDate ?? DateTime.now()
                                : controller.selectedApprovalsDate ??
                                    DateTime.now(),
                        daysOfWeekHeight: 0,
                        rowHeight: 0,
                        locale: Get.locale!.languageCode,
                        headerStyle: HeaderStyle(
                          leftChevronIcon: SvgPicture.asset(
                            context.isArabic
                                ? AppAssets.arrowForward
                                : AppAssets.arrowBack,
                            color: AppColors.text,
                            width: 16.w,
                            height: 16.h,
                          ),
                          rightChevronIcon: SvgPicture.asset(
                            context.isArabic
                                ? AppAssets.arrowBack
                                : AppAssets.arrowForward,
                            width: 16.w,
                            height: 16.h,
                            color: AppColors.text,
                          ),
                          headerPadding: EdgeInsets.zero,
                          // headerMargin: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                              color: AppTheme.isDark ?? false
                                  ? AppColors.card
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(8.r)),
                          formatButtonTextStyle:
                              AppTextStyles.font14BlackCairoRegular,
                          titleCentered: true,
                        ),
                        availableCalendarFormats: {
                          CalendarFormat.month: 'Month'.tr
                        },
                      );
                    }),
                PositionedDirectional(
                  start: 50.w,
                  child: SvgPicture.asset(
                    AppAssets.calender,
                  ),
                )
              ],
            ),
          ),
          horizontalSpace(12),
          DefaultDropdown(
            // add logic here of sort in the following functions
            onCanceled: () {},
            onOpened: () {},
            onSelected: (value) {
              // get which page by the index that is passed in this widget as a parameter

              // index == 1  ? --> attendance tab
              // index == 2  ? --> requests tab
              // index == 3  ? --> approvals tab
              if (currentTab == HomeTabs.attendance) {
                Get.find<TrackingAttendanceController>().sortAttendance(value);
              } else if (currentTab == HomeTabs.requests) {
                Get.find<TrackingRequestsController>().sortRequest(value);
              } else if (currentTab == HomeTabs.approvals) {
                Get.find<TrackingApprovalsController>()
                    .sortApprovalRequest(value);
              }
            },
            // ---------------------
            haveConstraintsForMenu: false,
            noPadding: true,
            enabled: true,
            height: 40.h,
            width: context.isPhone ? 39.w : 56.w,
            popupMenuItems: sortFilterListStrings,
            child: const ChipCard(
              image: AppAssets.sort2,
              onTap: null,
            ),
          ),
        ],
      ),
    );
  }
}
