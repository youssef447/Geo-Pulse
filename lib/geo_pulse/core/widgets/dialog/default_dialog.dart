import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:lottie/lottie.dart';
import '../../extensions/extensions.dart';

import '../../helpers/spacing_helper.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_font_weights.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/app_default_button.dart';

///Default Result Dialog after specific Action has been performed
class DefaultDialog extends StatelessWidget {
  final dynamic Function()? onConfirm;
  final String lottieAsset;
  final String title;
  final String subTitle;
  final bool showButtons;
  final bool autoClose;
  final String? okButtonText;
  final String? cancelButtonText;
  final double? width;

  const DefaultDialog({
    super.key,
    this.onConfirm,
    required this.lottieAsset,
    required this.title,
    required this.subTitle,
    this.showButtons = false,
    this.okButtonText,
    this.cancelButtonText,
    this.autoClose = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (autoClose) {
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.dialog,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 8.w,
      ),
      width: width ?? Get.width * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            height: 104.h,
            margin: EdgeInsets.only(
              left: 8.w,
              right: 8.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: LottieBuilder.asset(
              lottieAsset,
              frameRate: const FrameRate(120),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14BlackCairoMedium.copyWith(
                  fontSize: 20.sp,
                ),
              ),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.font14SecondaryBlackCairoRegular.copyWith(
                  fontWeight: AppFontWeights.medium,
                ),
              ),
              if (showButtons)
                Column(
                  children: [
                    verticalSpace(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppDefaultButton(
                          width: context.isTablett ? 100.w : 148.w,
                          color: AppColors.button,
                          height: 36.h,
                          radius: 6.r,
                          text: cancelButtonText ?? 'No'.tr,
                          style: AppTextStyles.font16ButtonMediumCairo
                              .copyWith(color: AppColors.black),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        horizontalSpace(context.isTablett ? 32 : 16),
                        AppDefaultButton(
                          width: context.isTablett ? 100.w : 148.w,
                          height: 36.h,
                          radius: 6.r,
                          text: okButtonText ?? 'Yes'.tr,
                          color: AppColors.primary,
                          style: AppTextStyles.font16ButtonMediumCairo,
                          onPressed: onConfirm,
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
