// Objectives: This file is responsible for providing attendance card widget.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';

class DashboardCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subTitle;
  final int value;

  const DashboardCard({
    super.key,
    required this.color,
    required this.title,
    required this.subTitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    var isTablet = context.isTablett;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color,
          width: 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                title.tr,
                style: isTablet
                    ? AppTextStyles.font18BlackCairoMedium
                        .copyWith(color: color)
                    : AppTextStyles.font16BlackMediumCairo
                        .copyWith(color: color),
              ),
            ),
            verticalSpace(isTablet ? 16 : 0),
            Text(DateTimeHelper.formatInt(value),
                style: isTablet
                    ? AppTextStyles.font36MediumBlackCairo
                    : AppTextStyles.font24MediumBlackCairo),
            verticalSpace(isTablet ? 16 : 0),
            Text(
              subTitle.tr,
              style: isTablet
                  ? AppTextStyles.font18SecondaryBlackCairoMedium
                  : AppTextStyles.font16SecondaryBlackCairoMedium,
            ),
          ],
        ),
      ),
    );
  }
}
