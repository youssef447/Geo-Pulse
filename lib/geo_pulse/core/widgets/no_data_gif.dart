import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../extensions/extensions.dart';

import '../constants/app_assets.dart';
import '../helpers/spacing_helper.dart';
import '../theme/app_text_styles.dart';

/// Objectives: This file is responsible for providing the default no data gif.
class NoDataGif extends StatelessWidget {
  final double? height;
  final double? width;
  const NoDataGif({
    super.key,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LottieBuilder.asset(
          height: height ?? Get.height * 0.35,
          width: width,
          AppAssets.noData,
          frameRate: const FrameRate(120),
        ),
        Text(
          'No Data Found'.tr,
          style: context.isTablett
              ? AppTextStyles.font28BlackSemiBoldCairo
              : AppTextStyles.font18BlackSemiBoldCairo,
        ),
        verticalSpace(30),
      ],
    );
  }
}
