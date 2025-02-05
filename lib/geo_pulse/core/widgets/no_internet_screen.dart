import 'package:flutter/material.dart';
import 'package:geo_pulse/geo_pulse/core/helpers/spacing_helper.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_colors.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_text_styles.dart';
import 'package:lottie/lottie.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LottieBuilder.asset('assets/lottie/offline.json'),
          verticalSpace(20),
          Text(
            'No internet connection',
            style: AppTextStyles.font18SecondaryBlackCairoMedium,
          ),
        ],
      ),
    );
  }
}
