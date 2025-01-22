import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../extensions/extensions.dart';

import '../constants/app_assets.dart';
import '../helpers/haptic_feedback_helper.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Objectives: This file is responsible for building a common custom app bar between several pages.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? actionWidget;
  final TextStyle? textStyle;
  final Widget? leadingIcon;
  final bool? centerTitle;
  final bool? paddedLeading;
  final Widget? mainLeadingIcon;
  final bool? hideLeading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.textStyle,
    this.actionWidget,
    this.leadingIcon,
    this.mainLeadingIcon,
    this.centerTitle,
    this.paddedLeading,
    this.hideLeading,
  });

  @override
  Size get preferredSize => Size.fromHeight(60.h);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: 8.h,
      ),
      child: AppBar(
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: actionWidget ?? const SizedBox(),
          ),
        ],
        leading: hideLeading ?? false
            ? null
            : IconButton(
                padding: EdgeInsets.zero,
                iconSize: 12.sp,
                onPressed: () {
                  HapticFeedbackHelper.triggerHapticFeedback(
                    vibration: VibrateType.mediumImpact,
                    hapticFeedback: HapticFeedback.mediumImpact,
                  );
                  Navigator.of(context).pop();
                },
                icon: !context.isArabic
                    ? SvgPicture.asset(
                        AppAssets.arrowBack,
                        color: AppColors.text,
                        width: 24.w,
                        height: 24.h,
                      )
                    : SvgPicture.asset(
                        AppAssets.arrowForward,
                        color: AppColors.text,
                        width: 24.w,
                        height: 24.h,
                      ),
              ),
        centerTitle: centerTitle ?? true,
        title: Column(
          children: [
            Text(
              title,
              style: textStyle ??
                  (context.isTablett
                      ? AppTextStyles.font28BlackSemiBoldCairo
                      : AppTextStyles.font26BlackSemiBoldCairo),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                style: AppTextStyles.font14BlackCairoRegular,
              ),
          ],
        ),
      ),
    );
  }
}
