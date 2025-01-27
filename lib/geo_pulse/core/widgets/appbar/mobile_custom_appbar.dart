import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../extensions/extensions.dart';

import '../../constants/app_assets.dart';
import '../../helpers/haptic_feedback_helper.dart';
import '../../helpers/spacing_helper.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CustomMobileAppbar extends StatelessWidget {
  final String title;
  const CustomMobileAppbar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedbackHelper.triggerHapticFeedback(
              vibration: VibrateType.mediumImpact,
              hapticFeedback: HapticFeedback.mediumImpact,
            );
            Navigator.of(context).pop();
          },
          child: SvgPicture.asset(
            context.isArabic ? AppAssets.arrowForward : AppAssets.arrowBack,
            color: AppColors.text,
            width: 16.w,
            height: 16.h,
          ),
        ),
        horizontalSpace(8),
        Text(
          title,
          style: AppTextStyles.font18BlackMediumCairo,
        ),
      ],
    );
  }
}
