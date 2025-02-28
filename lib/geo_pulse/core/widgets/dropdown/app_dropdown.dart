import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geo_pulse/geo_pulse/core/extensions/extensions.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AppDropdown extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.onChanged,
    required this.items,
    required this.textButton,
    this.hintText,
    this.value,
    this.customSpacing,
    this.menuWidth,
    this.width,
    this.height,
    this.textColor,
    this.splashColorOn = true,
    this.showDropdownIcon = true,
  });

  final Function(dynamic) onChanged;
  final List<DropdownMenuItem> items;
  final String? textButton;
  final String? hintText;
  final dynamic value;
  final Widget? customSpacing;
  final bool splashColorOn;
  final bool showDropdownIcon;
  final Color? textColor;
  final double? height, width, menuWidth;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: splashColorOn ? AppColors.primary : Colors.transparent,
        hoverColor: Colors.transparent,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.field,
              border: Border.all(
                color: Colors.transparent,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 6.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildDropdownText()),
                  customSpacing ?? const SizedBox(),
                  if (showDropdownIcon)
                    SvgPicture.asset(
                      AppAssets.down,
                      color: AppColors.inverseBase,
                      width: context.isTablett ? 24.w : 12.w,
                      height: context.isTablett ? 24.h : 12.h,
                    )
                ],
              ),
            ),
          ),
          value: value,
          dropdownStyleData: DropdownStyleData(
            width: menuWidth,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColors.card,
            ),
          ),
          hint: Text(
            hintText ?? 'Choose here'.tr,
            style: AppTextStyles.font14BlackCairoMedium,
            overflow: TextOverflow.ellipsis,
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Text _buildDropdownText() {
    return Text(
      textButton ?? hintText ?? 'Choose here'.tr,
      style: Get.context!.isTablett
          ? value != null
              ? AppTextStyles.font14BlackCairoRegular.copyWith(color: textColor)
              : AppTextStyles.font14SecondaryBlackCairoRegular
          : value != null
              ? AppTextStyles.font12BlackCairoRegular.copyWith(color: textColor)
              : AppTextStyles.font12SecondaryBlackCairoRegular,
      overflow: TextOverflow.ellipsis,
    );
  }
}
