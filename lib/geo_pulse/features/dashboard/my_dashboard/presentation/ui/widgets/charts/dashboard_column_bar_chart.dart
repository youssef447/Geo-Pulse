// Objectives: This file is responsible for providing a widget that displays bar chart data in the dashboard.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../core/constants/enums.dart';
import '../../../../../../../core/constants/strings.dart';
import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../hr_dashboard/presentation/controller/tracking_hr_controller.dart';
import '../../../../../hr_dashboard/presentation/ui/widgets/buildDropDown/build_drop_down.dart';
import '../../../../data/models/chart_data.dart';
import '../chart_toggle/count_minute_toggle_switch.dart';

class DashboardColumnBarChart extends StatelessWidget {
  final String title;
  final String titleIconAsset;
  final List<ChartData> data;
  final double intervalNum;
  final bool showCountMinToggleSwitch;
  final bool showFilterAbsenceDropDown;
  final bool showFilterRequestDropDown;
  final bool showFilterLateCountDropDown;
  final bool showFilterLateMinutesDropDown;

  const DashboardColumnBarChart({
    super.key,
    required this.title,
    required this.titleIconAsset,
    required this.data,
    required this.intervalNum,
    this.showCountMinToggleSwitch = false,
    this.showFilterAbsenceDropDown = false,
    this.showFilterRequestDropDown = false,
    this.showFilterLateCountDropDown = false,
    this.showFilterLateMinutesDropDown = false,
  });

  @override
  Widget build(BuildContext context) {
    var isTablet = context.isTablett;

    return data.isEmpty
        ? const SizedBox()
        : Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          radius: 13.r,
                          child: SvgPicture.asset(
                            titleIconAsset,
                            color: AppColors.icon,
                          ),
                        ),
                        horizontalSpace(4),
                        Text(
                          title,
                          style: AppTextStyles.font16BlackRegularCairo,
                        ),
                        const Spacer(),
                        if (showCountMinToggleSwitch)
                          const CountMinuteToggleSwitch()
                        else if (showFilterAbsenceDropDown)
                          GetBuilder<TrackingHRController>(
                              id: AppConstanst.hrDashboardFilters,
                              builder: (controller) {
                                return buildDropDown(
                                  context: context,
                                  width: isTablet ? 150.w : null,
                                  value: controller.selectedTimeAbsenceFilter,
                                  textButton: controller.absenceFilterName,
                                  onPressed: (value) {
                                    controller.setTimeAbsenceFilter(value);
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.week,
                                      child: buildMenuItem('Week'.tr),
                                    ),
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.month,
                                      child: buildMenuItem('Month'.tr),
                                    ),
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.year,
                                      child: buildMenuItem('Year'.tr),
                                    ),
                                  ],
                                );
                              })
                        else if (showFilterLateCountDropDown)
                          GetBuilder<TrackingHRController>(
                              id: AppConstanst.hrDashboardFilters,
                              builder: (controller) {
                                return buildDropDown(
                                  context: context,
                                  width: isTablet ? 150.w : null,
                                  value: controller.selectedTimeLateCountFilter,
                                  textButton: controller.lateCountFilterName,
                                  onPressed: (value) {
                                    controller.setTimeLateCountFilter(value);
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.week,
                                      child: buildMenuItem('Week'.tr),
                                    ),
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.month,
                                      child: buildMenuItem('Month'.tr),
                                    ),
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.year,
                                      child: buildMenuItem('Year'.tr),
                                    ),
                                  ],
                                );
                              })
                        else if (showFilterLateMinutesDropDown)
                          GetBuilder<TrackingHRController>(
                              id: AppConstanst.hrDashboardFilters,
                              builder: (controller) {
                                return buildDropDown(
                                  context: context,
                                  width: isTablet ? 150.w : null,
                                  value:
                                      controller.selectedTimeLateMinutesFilter,
                                  textButton: controller.lateMinutesFilterName,
                                  onPressed: (value) {
                                    controller.setTimeLateMinutesFilter(value);
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.week,
                                      child: buildMenuItem('Week'.tr),
                                    ),
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.month,
                                      child: buildMenuItem('Month'.tr),
                                    ),
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.year,
                                      child: buildMenuItem('Year'.tr),
                                    ),
                                  ],
                                );
                              })
                        else if (showFilterRequestDropDown)
                          GetBuilder<TrackingHRController>(
                              id: AppConstanst.hrDashboardFilters,
                              builder: (controller) {
                                return buildDropDown(
                                  context: context,
                                  width: isTablet ? 150.w : null,
                                  value: controller.selectedTimeRequestFilter,
                                  textButton: controller.requestFilterName,
                                  onPressed: (value) {
                                    controller.setTimeRequestFilter(value);
                                  },
                                  items: [
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.week,
                                      child: buildMenuItem('Week'.tr),
                                    ),
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.month,
                                      child: buildMenuItem('Month'.tr),
                                    ),
                                    DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: TimeFilter.year,
                                      child: buildMenuItem('Year'.tr),
                                    ),
                                  ],
                                );
                              }),
                      ],
                    ),
                    verticalSpace(25),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: data.length <= 4 && context.isTablett
                            ? Get.width
                            : data.length * Get.width / 5,
                        child: SfCartesianChart(
                          plotAreaBorderWidth: 0,
                          // isTransposed: true,
                          //margin: EdgeInsets.zero,
                          backgroundColor: AppColors.card,
                          primaryXAxis: CategoryAxis(
                            labelStyle: AppTextStyles.font10BlackRegularInter,
                            majorTickLines: const MajorTickLines(size: 0),
                            axisLine: AxisLine(
                              color: AppColors.secondaryBlack,
                            ),
                            initialZoomPosition: 1,
                            majorGridLines: const MajorGridLines(width: 0),
                          ),
                          primaryYAxis: NumericAxis(
                            numberFormat: NumberFormat.compact(
                              locale: Get.locale.toString(),
                            ),
                            labelIntersectAction: AxisLabelIntersectAction.wrap,
                            majorTickLines: const MajorTickLines(
                              size: 0,
                            ),
                            axisLine: const AxisLine(color: Colors.transparent),
                            interval: intervalNum,
                            majorGridLines: MajorGridLines(
                              //   width: 0.7.w,
                              color: AppColors.secondaryBlack,
                              dashArray: const <double>[5, 5],
                            ),
                          ),
                          series: <CartesianSeries<ChartData, String>>[
                            ColumnSeries<ChartData, String>(
                              width: 1,
                              spacing: context.isTablett ? 0.8 : 0.4,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15.r),
                              ),

                              animationDuration: 1000,
                              dataSource: data,
                              //use dataa to test long list
                              xValueMapper: (ChartData data, _) =>
                                  Get.locale.toString().contains('ar')
                                      ? data.xAxisLabelArabic
                                      : data.xAxisLabel,
                              yValueMapper: (ChartData data, _) =>
                                  data.yAxisLabel,
                              pointColorMapper: (ChartData data, _) =>
                                  AppColors.primary,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          );
  }
}
