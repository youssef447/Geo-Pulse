// Objectives: This file is responsible for providing the tablet layout of the dashboard screen.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/constants/strings.dart';
import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/widgets/loading/circle_progress.dart';
import '../../../../../../../core/widgets/responsive/orientation_layout.dart';
import '../../../../../my_dashboard/presentation/ui/widgets/charts/dashboard_circular_chart.dart';
import '../../../../../my_dashboard/presentation/ui/widgets/charts/dashboard_column_bar_chart.dart';
import '../../../controller/tracking_hr_controller.dart';
import '../filters/hr_dashboard_filters.dart';

class HRDashboardTabletLayout extends StatelessWidget {
  const HRDashboardTabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GetBuilder<TrackingHRController>(
          id: AppConstanst.dashboard,
          builder: (controller) {
            if (controller.loading) {
              return SizedBox(
                height: Get.height * 0.55,
                child: const CircleProgress(),
              );
            }

            return Column(
              children: [
                HRDashboardFilters(),
                verticalSpace(12),
                OrientationLayout(
                  portrait: (context) => Column(
                    children: [
                      DashboardCircularChart(
                        title: 'Request Types'.tr,
                        height: 260.h,
                        allRequestsCount: controller.totalRequestCount,
                        data: controller.requestTypesChartData,
                      ),
                      verticalSpace(12),
                      DashboardCircularChart(
                        title: 'Request Status'.tr,
                        height: 260.h,
                        allRequestsCount: controller.totalRequestCount,
                        data: controller.requestsCircularChartData,
                      ),
                    ],
                  ),
                  landscape: (context) => Row(
                    children: [
                      Expanded(
                        child: DashboardCircularChart(
                          title: 'Request Types'.tr,
                          height: 260.h,
                          width: 180.w,
                          allRequestsCount: controller.totalRequestCount,
                          data: controller.requestTypesChartData,
                        ),
                      ),
                      horizontalSpace(16),
                      Expanded(
                        child: DashboardCircularChart(
                          title: 'Request Status'.tr,
                          height: 260.h,
                          allRequestsCount: controller.totalRequestCount,
                          data: controller.requestsCircularChartData,
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpace(12),
                DashboardColumnBarChart(
                  title: 'Request Types'.tr,
                  titleIconAsset: AppAssets.report,
                  data: controller.requestTypesChartData,
                  intervalNum: 1,
                ),
                verticalSpace(12),
                DashboardColumnBarChart(
                  title: 'Requests History'.tr,
                  showFilterRequestDropDown: true,
                  titleIconAsset: AppAssets.history,
                  data: controller.requestsHistoryBarChartData,
                  intervalNum: 1,
                ),
                verticalSpace(12),
                DashboardColumnBarChart(
                  title: 'Absence History'.tr,
                  showFilterAbsenceDropDown: true,
                  titleIconAsset: AppAssets.history,
                  data: controller.absenceHistoryBarChartData,
                  intervalNum: 1,
                ),
                verticalSpace(12),
                DashboardColumnBarChart(
                  title: 'Late History Count'.tr,
                  showFilterLateCountDropDown: true,
                  titleIconAsset: AppAssets.history,
                  data: controller.lateHistoryCountBarChartDataHr,
                  intervalNum: 1,
                ),
                verticalSpace(12),
                DashboardColumnBarChart(
                  title: 'Late History Minutes'.tr,
                  showFilterLateMinutesDropDown: true,
                  titleIconAsset: AppAssets.history,
                  data: controller.lateHistoryMinutesBarChartDataHr,
                  intervalNum: 20,
                ),
                verticalSpace(120),
              ],
            );
          }),
    );
  }
}
