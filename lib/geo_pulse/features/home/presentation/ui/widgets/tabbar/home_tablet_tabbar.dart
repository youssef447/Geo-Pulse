import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tracking_module/tracking_module/core/constants/enums.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/animations/horizontal_animation.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../controller/controller/tracking_home_controller.dart';

/// Objectives: This file is responsible for providing a tab bar used in the home feature.
class HomeTabletTabBar extends GetView<TrackingHomeController> {
  const HomeTabletTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
      leftToRight: true,
      child: TabBar(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabAlignment: TabAlignment.start,
        labelPadding: EdgeInsetsDirectional.only(
          end: context.isTablett ? 46.w : 20.5.w,
        ),
        isScrollable: true,
        splashFactory: NoSplash.splashFactory,
        indicatorColor: AppColors.secondaryPrimary,
        indicatorPadding: EdgeInsets.zero,
        unselectedLabelStyle: AppTextStyles.font18SecondaryBlackCairoMedium
            .copyWith(color: AppColors.inputColor),
        labelStyle: AppTextStyles.font18secondaryPrimaryMediumCairo,
        dividerColor: Colors.transparent,
        controller: controller.tabController,
        tabs: controller.homeTabs.map(
          (tab) {
            return Tab(
              text: tab.getName.tr,
            );
          },
        ).toList(),
      ),
    );
  }
}
