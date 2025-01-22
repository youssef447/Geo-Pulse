// Objectives: This file is responsible for providing the default date picker field widget for the application.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../helpers/date_time_helper.dart';
import '../../helpers/get_date_picker_helper.dart';
import '../../helpers/validation_helper.dart';
import '../../theme/app_text_styles.dart';
import 'default_form_field.dart';

class DatePickerField extends StatelessWidget {
  final TextEditingController textEditingController;

  final String? hintText;
  final String? icon;
  final double? width;
  final bool showIcon;

  final Function(DateTime)? onDateChanged;

  const DatePickerField({
    super.key,
    required this.textEditingController,
    this.onDateChanged,
    this.hintText,
    this.width,
    this.icon,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GetDatePickerHelper.customDatePicker(context: context).then(
          (value) {
            if (value != null) {
              textEditingController.text = DateTimeHelper.formatDate(value[0]!);

              if (onDateChanged != null) {
                onDateChanged!(value[0]!);
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
                AppAssets.calender,
              )
            : const SizedBox(),
        hintStyle: AppTextStyles.font12SecondaryBlackCairoRegular,
        style: AppTextStyles.font14BlackCairoRegular,
        height: 40.h,
        width: width ?? 186.w,
        contentPadding: EdgeInsetsDirectional.only(
          start: 8.w,
        ),
        collapsed: true,
        validator: (value) {
          return ValidationHelper.isEmpty(value, 'Date'.tr);
        },
      ),
    );
  }
}
