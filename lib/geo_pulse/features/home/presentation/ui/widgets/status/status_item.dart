import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

/// Represents the status item widget.
class StatusItem extends StatelessWidget {
  final int statusItemCount;
  final String statusText;
  final Color statusTextColor;
  final bool isContainerPrimaryColor;
  final FontWeight fontWeight;

  const StatusItem({
    super.key,
    required this.statusItemCount,
    required this.fontWeight,
    required this.statusText,
    required this.statusTextColor,
    this.isContainerPrimaryColor = false,
  });

  @override
  Widget build(BuildContext context) {
    var isTablet = context.isTablett;

    return Row(
      children: [
        Container(
          height: isTablet ? 48.h : 32.h,
          width: isTablet ? 48.h : 32.h,
          decoration: BoxDecoration(
            color: isContainerPrimaryColor ? AppColors.primary : AppColors.card,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: Text(
              DateTimeHelper.formatInt(statusItemCount),
              style: isTablet
                  ? AppTextStyles.font20SecondaryBlackSemiBoldCairo.copyWith(
                      fontWeight: fontWeight,
                      color: isContainerPrimaryColor
                          ? AppColors.textButton
                          : AppColors.inverseBase)
                  : AppTextStyles.font14BlackCairo.copyWith(
                      color: isContainerPrimaryColor
                          ? AppColors.textButton
                          : AppColors.inverseBase,
                      fontWeight: fontWeight,
                    ),
            ),
          ),
        ),
        horizontalSpace(isTablet ? 16.w : 4.w),
        Text(
          statusText.tr,
          style: isTablet
              ? AppTextStyles.font20SecondaryBlackSemiBoldCairo.copyWith(
                  color: statusTextColor,
                  fontWeight: fontWeight,
                )
              : AppTextStyles.font14BlackCairo.copyWith(
                  color: statusTextColor,
                  fontWeight: fontWeight,
                ),
        ),
        horizontalSpace(isTablet ? 20.w : 8.w),
      ],
    );
  }
}
