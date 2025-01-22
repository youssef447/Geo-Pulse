import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tracking_module/tracking_module/core/animations/scale_animation.dart';
import '../../../data/enums/dashboard_category.dart';

import '../../controller/tracking_dashboard_controller.dart';
import 'cards/dashboard_card.dart';

/// Objectives: This file is responsible for providing an attendance list in the dashboard screen.
class DashboardList extends GetView<TrackingDashboardController> {
  final bool isScrollHorizontal;
  final int axisCount;
  final double childSize;
  final bool isScrollable;

  const DashboardList({
    super.key,
    required this.isScrollHorizontal,
    required this.axisCount,
    required this.childSize,
    this.isScrollable = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: isScrollable ? null : const NeverScrollableScrollPhysics(),
      itemCount: controller.dashboardTitles.length,
      scrollDirection: isScrollHorizontal ? Axis.horizontal : Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: axisCount,
        crossAxisSpacing: 12.h,
        mainAxisSpacing: 12.w,
        childAspectRatio: childSize,
      ),
      itemBuilder: (context, index) {
        return ScaleAnimation(
          delay: 2 * index + 50,
          child: DashboardCard(
            color: controller.dashboardTitles.values.elementAt(index),
            title: controller.dashboardTitles.keys.elementAt(index).localized,
            subTitle: controller.dashboardCardSubtitles[index],
            value: controller.dashboardCardValues[index],
          ),
        );
      },
    );
  }
}
