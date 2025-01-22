// Objectives: This file is responsible for providing a chart widget that displays the requests data in the dashboard.

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../../../../core/extensions/extensions.dart';
import '../../../../../../../core/constants/app_assets.dart';
import '../../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../home/presentation/controller/controller/tracking_home_controller.dart';
import '../../../../data/models/chart_data.dart';

class DashboardCircularChart extends GetView<TrackingHomeController> {
  final int allRequestsCount;
  final List<ChartData> data;
  final double? width;
  final double? height;
  final String title;

  const DashboardCircularChart({
    super.key,
    required this.allRequestsCount,
    required this.data,
    required this.title,
    this.width,
    this.height,
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
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 13.r,
                        child: SvgPicture.asset(
                          AppAssets.request,
                          color: AppColors.icon,
                        ),
                      ),
                      horizontalSpace(4),
                      Text(
                        title,
                        style: AppTextStyles.font16BlackRegularCairo,
                      ),
                    ],
                  ),
                  Divider(
                    color: AppColors.chatBackground,
                    thickness: 1.w,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: width,
                              height: height,
                              child: SfCircularChart(
                                margin: EdgeInsets.zero,
                                series: <CircularSeries<ChartData, String>>[
                                  DoughnutSeries<ChartData, String>(
                                    innerRadius: '70%',
                                    explodeAll: true,
                                    explode: true,
                                    explodeOffset: "3%",
                                    cornerStyle: CornerStyle.startCurve,
                                    dataSource: data,
                                    pointColorMapper: (ChartData data, _) =>
                                        data.yAxisLabel == 0
                                            ? Colors.transparent
                                            : data.chartItemColor,
                                    xValueMapper: (ChartData data, _) =>
                                        data.xAxisLabel,
                                    yValueMapper: (ChartData data, _) =>
                                        data.yAxisLabel,
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    DateTimeHelper.formatInt(allRequestsCount),
                                    style: isTablet
                                        ? AppTextStyles
                                            .font16SecondaryBlackCairo
                                        : AppTextStyles
                                            .font12SecondaryBlackCairoMedium,
                                  ),
                                  verticalSpace(10),
                                  Text(
                                    'Requests'.tr,
                                    style: isTablet
                                        ? AppTextStyles
                                            .font16SecondaryBlackCairo
                                        : AppTextStyles
                                            .font12SecondaryBlackCairoMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...data.map(
                              (e) => Padding(
                                padding: EdgeInsetsDirectional.only(
                                  bottom: 16.h,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 11.w,
                                      height: 11.h,
                                      decoration: BoxDecoration(
                                        color: e.chartItemColor,
                                        borderRadius:
                                            BorderRadius.circular(2.r),
                                      ),
                                    ),
                                    horizontalSpace(8),
                                    SizedBox(
                                      width: isTablet ? 180.w : 110.w,
                                      child: Text(
                                        Get.locale.toString().contains('ar')
                                            ? e.xAxisLabelArabic
                                            : e.xAxisLabel,
                                        style: isTablet
                                            ? AppTextStyles
                                                .font16SecondaryBlackCairo
                                            : AppTextStyles
                                                .font14SecondaryBlackCairo,
                                      ),
                                    ),
                                    Text(
                                      DateTimeHelper.formatInt(e.yAxisLabel),
                                      style: isTablet
                                          ? AppTextStyles
                                              .font16BlackSemiBoldCairo
                                          : AppTextStyles
                                              .font14BlackSemiBoldCairo,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
