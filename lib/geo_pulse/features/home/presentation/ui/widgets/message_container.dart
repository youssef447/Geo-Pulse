import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';

/// Representation: This is the message container widget Which is In user home card.
class MessageContainer extends StatelessWidget {
  const MessageContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // go to message
      },
      child: Container(
        height: 42.h,
        width: 42.w,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          AppAssets.message,
          width: 24.w,
          height: 24.h,
          color: AppColors.icon,
        ),
      ),
    );
  }
}
