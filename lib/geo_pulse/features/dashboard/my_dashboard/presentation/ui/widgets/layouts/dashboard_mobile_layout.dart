// Objectives: This file is responsible for providing the mobile layout of the dashboard screen.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../core/animations/up_down_animation.dart';
import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/constants/strings.dart';
import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../controller/tracking_dashboard_controller.dart';
import '../charts/dashboard_circular_chart.dart';
import '../charts/dashboard_column_bar_chart.dart';
import '../dashboard_list.dart';

class DashboardMobileLayout extends GetView<TrackingDashboardController> {
  const DashboardMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return UpDownAnimation(
      reverse: true,
      child: Column(
        children: [
          if (controller.dashboardCardValues.isNotEmpty)
            Padding(
              padding: EdgeInsetsDirectional.only(bottom: 12.h),
              child: DashboardList(
                axisCount: 2,
                childSize: 163.w / 140.h,
                isScrollHorizontal: false,
              ),
            ),
          DashboardCircularChart(
            title: 'Requests'.tr,
            height: 180.h,
            width: 180.w,
            allRequestsCount: controller.requestsData.length,
            data: controller.requestsChartData,
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
    );
  }
}
