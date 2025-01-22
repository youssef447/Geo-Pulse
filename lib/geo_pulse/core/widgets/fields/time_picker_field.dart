// Objectives: This file is responsible for providing the default time picker field widget for the application.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../constants/strings.dart';
import '../../helpers/date_time_helper.dart';
import '../../helpers/validation_helper.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import 'default_form_field.dart';

class TimePickerField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? hintText;
  final String? icon;
  final bool showIcon;

  final Function(TimeOfDay)? onDateChanged;

  const TimePickerField({
    super.key,
    required this.textEditingController,
    this.onDateChanged,
    this.hintText,
    this.icon,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return Localizations.override(
              context: context,
              locale: Get.locale,
              child: Theme(
                data: Theme.of(context).copyWith(
                  timePickerTheme: TimePickerThemeData(
                    backgroundColor: AppColors.background,
                    dayPeriodTextColor: AppColors.text,
                    hourMinuteTextColor: AppTheme.contrastColor(),
                    dayPeriodBorderSide: BorderSide(
                      color: AppColors.secondaryPrimary,
                    ),
                    dayPeriodColor: AppColors.secondaryPrimary,
                  ),
                  colorScheme: ColorScheme(
                    primary: AppColors.secondaryPrimary,
                    secondary: AppColors.secondaryPrimary,
                    surface: AppColors.primary,
                    onSurface: AppTheme.contrastColor(),
                    onError: AppColors.darkRed,
                    onPrimary: AppColors.white,
                    onSecondary: Colors.black,
                    brightness: AppTheme.isDark ?? false
                        ? Brightness.dark
                        : Brightness.light,
                    error: AppColors.darkRed,
                  ),
                ),
                child: child!,
              ),
            );
          },
        ).then(
          (value) {
            if (value != null) {
              textEditingController.text = DateTimeHelper.formatTime(
                  DateTimeHelper.formatTimeOfDayToDateTime(value, null));

              if (onDateChanged != null) {
                onDateChanged!(value).call();
              }
            }
          },
        );
      },
      child: AppTextFormField(
        readOnly: true,
        enabled: false,
        controller: textEditingController,
        hintText: hintText,
        suffixIcon: showIcon
            ? SvgPicture.asset(
                AppAssets.time,
                width: 24.w,
                height: 24.h,
                color: AppColors.secondaryBlack,
              )
            : const SizedBox(),
        hintStyle: AppTextStyles.font12SecondaryBlackCairoRegular,
        style: AppTextStyles.font14BlackCairoRegular,
        height: 40.h,
        width: 186.w,
        contentPadding: EdgeInsetsDirectional.only(
          start: 8.w,
        ),
        collapsed: true,
        validator: (value) {
          return ValidationHelper.isEmpty(value, AppConstanst.time.tr);
        },
      ),
    );
  }
}
