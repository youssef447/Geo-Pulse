import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

///Representation of a chip card widget.
class ChipCard extends StatelessWidget {
  final String image;
  final Function()? onTap;
  const ChipCard({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: context.isPhone ? 39.w : 56.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppTheme.isDark ?? false ? AppColors.card : AppColors.white,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          image,
          color: AppColors.inverseBase,
        ),
      ),
    );
  }
}
