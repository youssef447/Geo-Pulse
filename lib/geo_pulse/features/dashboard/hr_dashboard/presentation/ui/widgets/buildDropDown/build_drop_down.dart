import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../core/extensions/extensions.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../core/widgets/dropdown/app_dropdown.dart';

buildDropDown(
    {required BuildContext context,
    required double? width,
    required String textButton,
    required Function(dynamic) onPressed,
    required List<DropdownMenuItem> items,
    required dynamic value}) {
  final isTablet = context.isTablett;

  return isTablet
      ? AppDropdown(
          width: width,
          height: 40.h,
          onChanged: onPressed,
          items: items,
          textButton: textButton.tr,
          hintText: textButton.tr,
          value: value,
        )
      : Expanded(
          child: AppDropdown(
            width: width,
            height: 40.h,
            onChanged: onPressed,
            items: items,
            textButton: textButton.tr,
            hintText: textButton.tr,
            value: value,
          ),
        );
}

buildMenuItem(text) {
  return Text(
    text,
    style: AppTextStyles.font14SecondaryBlackCairo,
  );
}
