import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../extensions/extensions.dart';

import '../../theme/app_colors.dart';

/// Objectives: This file is responsible for providing a default filter card widget that is used in the app.
class DefaultChipCard extends StatelessWidget {
  final Widget icon;
  final Color? color;
  final Color? borderColor;
  const DefaultChipCard({
    super.key,
    required this.icon,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: context.isTablett ? 56.h : 40.h,
      width: context.isTablett ? 56.w : 40.w,
      padding: EdgeInsets.only(
        left: context.isTablett ? 11.2.h : 8.w,
        top: context.isTablett ? 11.2.h : 8.h,
        right: context.isTablett ? 11.2.h : 8.w,
        bottom: context.isTablett ? 11.2.h : 8.h,
      ),
      decoration: BoxDecoration(
        color: color ?? AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: borderColor ?? AppColors.primary,
          width: 1.5.w,
        ),
      ),
      child: icon,
    );
  }
}
