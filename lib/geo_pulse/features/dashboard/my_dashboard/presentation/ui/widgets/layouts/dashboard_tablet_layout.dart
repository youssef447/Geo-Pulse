// Objectives: This file is responsible for providing the tablet layout of the dashboard screen.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../core/animations/up_down_animation.dart';
import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/constants/strings.dart';
import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/widgets/responsive/orientation_layout.dart';
import '../../../controller/tracking_dashboard_controller.dart';
import '../charts/dashboard_circular_chart.dart';
import '../charts/dashboard_column_bar_chart.dart';
import '../dashboard_list.dart';

class DashboardTabletLayout extends GetView<TrackingDashboardController> {
  const DashboardTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return UpDownAnimation(
      reverse: true,
      child: SingleChildScrollView(
        child: Column(
          children: [
            OrientationLayout(
              portrait: (context) => Column(
                children: [
                  if (controller.dashboardCardValues.isNotEmpty)
                    Padding(
                      padding: EdgeInsetsDirectional.only(bottom: 12.h),
                      child: SizedBox(
                        height: 200.h,
                        child: DashboardList(
                          axisCount: 1,
                          childSize: 150.w / 200.h,
                          isScrollHorizontal: true,
                          isScrollable: true,
                        ),
                      ),
                    ),
                  DashboardCircularChart(
                    title: 'Requests'.tr,
                    height: 260.h,
                    allRequestsCount: controller.requestsData.length,
                    data: controller.requestsChartData,
                  ),
                ],
              ),
              landscape: (context) => Row(
                children: [
                  if (controller.dashboardCardValues.isNotEmpty)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(end: 16.h),
                        child: DashboardList(
                          axisCount: 2,
                          childSize: 100.w / 85.h,
                          isScrollHorizontal: false,
                          isScrollable: false,
                        ),
                      ),
                    ),
                  Expanded(
                    child: DashboardCircularChart(
                      title: 'Requests'.tr,
                      height: 360.h,
                      allRequestsCount: controller.requestsData.length,
                      data: controller.requestsChartData,
                    ),
                  ),
                ],
              ),
            ),
            verticalSpace(12),
            GetBuilder<TrackingDashboardController>(
                id: AppConstanst.barChart,
                builder: (controller) {
                  return DashboardColumnBarChart(
                    title: 'Late History'.tr,
                    titleIconAsset: AppAssets.history,
                    data: controller.lateHistoryChartData,
                    showCountMinToggleSwitch: true,
                    intervalNum: controller.intervalBarChart.toDouble(),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
