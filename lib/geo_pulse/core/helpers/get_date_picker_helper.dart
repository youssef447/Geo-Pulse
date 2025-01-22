// Objectives: This file is responsible for providing a date picker helper class tp return custom date pickers.

import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../extensions/extensions.dart';
import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'date_time_helper.dart';

abstract class GetDatePickerHelper {
  static Future<List<DateTime?>?> customDatePicker({
    required BuildContext context,
    CalendarDatePicker2Type? calenderType,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    final isTablet = context.isTablett;

    return showCalendarDatePicker2Dialog(
      context: context,
      dialogSize: isTablet ? Size(550.w, 390.h) : Size(365.w, 350.h),
      borderRadius: BorderRadius.circular(10.r),
      dialogBackgroundColor: AppColors.dialog,
      config: CalendarDatePicker2WithActionButtonsConfig(
        dayBuilder: ({
          required date,
          decoration,
          isDisabled,
          isSelected,
          isToday,
          textStyle,
        }) {
          return Center(
            child: Container(
              width: 30.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      isToday ?? false ? AppColors.primary : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(8.r),
                color: isSelected ?? false
                    ? AppColors.primary
                    : Colors.transparent,
              ),
              child: Text(
                DateTimeHelper.formatInt(date.day),
                style: isSelected ?? false
                    ? isTablet
                        ? AppTextStyles.font19WhiteRegularCairo
                            .copyWith(color: AppColors.textButton)
                        : AppTextStyles.font16WhiteRegularCairo
                            .copyWith(color: AppColors.textButton)
                    : isTablet
                        ? AppTextStyles.font19BlackRegularCairo
                        : AppTextStyles.font16BlackRegularCairo,
              ),
            ),
          );
        },
        centerAlignModePicker: true,
        closeDialogOnCancelTapped: true,
        closeDialogOnOkTapped: true,
        firstDate: firstDate ?? DateTime(2022),
        lastDate: lastDate ?? DateTime(2090),
        calendarType: calenderType ?? CalendarDatePicker2Type.single,
        calendarViewMode: CalendarDatePicker2Mode.day,
        dayBorderRadius: BorderRadius.circular(8.r),
        yearBorderRadius: BorderRadius.circular(8.r),
        monthBorderRadius: BorderRadius.circular(8.r),
        hideMonthPickerDividers: true,
        hideYearPickerDividers: true,
        buttonPadding: EdgeInsets.symmetric(
          horizontal: isTablet ? 60.w : 25.w,
        ),
        customModePickerIcon: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 5.w,
          ),
          child: SvgPicture.asset(
            AppAssets.arrowDown,
            fit: BoxFit.fitHeight,
            color: AppColors.secondaryPrimary,
            width: isTablet ? 20.w : 16.w,
            height: isTablet ? 20.h : 16.h,
          ),
        ),
        okButton: Container(
          alignment: Alignment.center,
          height: isTablet ? 40.h : 30.h,
          width: isTablet ? 150.w : 120.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.primary,
          ),
          child: Text(
            'Set Date'.tr,
            style: AppTextStyles.font16BlackMediumCairo.copyWith(
              color: AppColors.textButton,
              fontSize: isTablet ? 19.sp : 16.sp,
            ),
          ),
        ),
        cancelButton: Container(
          alignment: Alignment.center,
          height: isTablet ? 40.h : 30.h,
          width: isTablet ? 150.w : 120.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.darkWhiteShadow,
          ),
          child: Text(
            'Cancel'.tr,
            style: AppTextStyles.font16BlackMediumCairo.copyWith(
              color: AppColors.textButton,
              fontSize: isTablet ? 19.sp : 16.sp,
            ),
          ),
        ),
        lastMonthIcon: SvgPicture.asset(
          context.isArabic ? AppAssets.arrowForward : AppAssets.arrowBack,
          color: AppColors.primary,
          width: isTablet ? 24.w : 16.w,
          height: isTablet ? 24.h : 16.h,
        ),
        nextMonthIcon: SvgPicture.asset(
          context.isArabic ? AppAssets.arrowBack : AppAssets.arrowForward,
          width: isTablet ? 24.w : 16.w,
          height: isTablet ? 24.h : 16.h,
          color: AppColors.primary,
        ),
        daySplashColor: Colors.transparent,
        weekdayLabelTextStyle: isTablet
            ? AppTextStyles.font19SecondaryPrimarySemiBoldCairo
            : AppTextStyles.font16SecondaryPrimarySemiBoldCairo,
        controlsTextStyle: isTablet
            ? AppTextStyles.font19SecondaryPrimarySemiBoldCairo
            : AppTextStyles.font16SecondaryPrimarySemiBoldCairo,
        todayTextStyle: isTablet
            ? AppTextStyles.font19BlackRegularCairo
            : AppTextStyles.font16BlackRegularCairo,
        dayTextStyle: isTablet
            ? AppTextStyles.font19BlackRegularCairo
            : AppTextStyles.font16BlackRegularCairo,
        monthTextStyle: isTablet
            ? AppTextStyles.font19BlackRegularCairo
            : AppTextStyles.font16BlackRegularCairo,
        yearTextStyle: isTablet
            ? AppTextStyles.font19BlackRegularCairo
            : AppTextStyles.font16BlackRegularCairo,
        selectedDayHighlightColor: AppColors.primary,
        selectedRangeDayTextStyle:
            AppTextStyles.font16BlackRegularCairo.copyWith(
          color: AppColors.textButton,
          fontSize: isTablet ? 19.sp : 16.sp,
        ),
        selectedRangeHighlightColor: AppColors.primary,
        selectedDayTextStyle: isTablet
            ? AppTextStyles.font19WhiteRegularCairo
            : AppTextStyles.font16WhiteRegularCairo,
        selectedMonthTextStyle: isTablet
            ? AppTextStyles.font19WhiteRegularCairo
            : AppTextStyles.font16WhiteRegularCairo,
        selectedYearTextStyle: isTablet
            ? AppTextStyles.font19WhiteRegularCairo
            : AppTextStyles.font16WhiteRegularCairo,
        disabledDayTextStyle: isTablet
            ? AppTextStyles.font19LightGreyRegularCairo
            : AppTextStyles.font16LightGreyRegularCairo,
        disabledMonthTextStyle: isTablet
            ? AppTextStyles.font19LightGreyRegularCairo
            : AppTextStyles.font16LightGreyRegularCairo,
        disabledYearTextStyle: isTablet
            ? AppTextStyles.font19LightGreyRegularCairo
            : AppTextStyles.font16LightGreyRegularCairo,
      ),
    );
  }
}
