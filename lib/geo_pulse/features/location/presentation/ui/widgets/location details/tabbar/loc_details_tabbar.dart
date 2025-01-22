import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../core/extensions/extensions.dart';
import '../../../../../../../core/animations/horizontal_animation.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../controller/controller/location_details_controller.dart';
import '../../../constants/location_details_tabs.dart';

/// This file is responsible for providing a tab bar used in the location details feature.
class LocationDetailsTabBar extends GetView<LocationDetailsController> {
  const LocationDetailsTabBar({super.key});
  @override
  Widget build(BuildContext context) {
    return SlideAnimation(
      leftToRight: true,
      child: TabBar(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabAlignment: TabAlignment.start,
        labelPadding: EdgeInsetsDirectional.only(
          end: context.isTablett ? 23.w : 16.w,
        ),
        isScrollable: true,
        indicatorColor: AppColors.secondaryPrimary,
        indicatorPadding: EdgeInsets.zero,
        unselectedLabelStyle: AppTextStyles.font16BlackMediumCairo
            .copyWith(color: AppColors.inputColor),
        labelStyle: AppTextStyles.font16SecondaryYelloCairo,
        dividerColor: Colors.transparent,
        controller: controller.tabController,
        tabs: LocationDetailsTabs.locationDetailsTAb.map(
          (text) {
            return Tab(
              text: text.tr,
            );
          },
        ).toList(),
      ),
    );
  }
}
