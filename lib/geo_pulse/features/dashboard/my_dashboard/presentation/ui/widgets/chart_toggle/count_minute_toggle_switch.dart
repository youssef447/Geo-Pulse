import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/core/constants/strings.dart';
import '../../../../../../../core/extensions/extensions.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';

import '../../../controller/tracking_dashboard_controller.dart';

class CountMinuteToggleSwitch extends StatelessWidget {
  const CountMinuteToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    var isTablet = context.isTablett;

    return Container(
      width: isTablet ? 165.w : 120.w,
      height: isTablet ? 35.h : 30.h,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(4.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 4.h),
      child: GetBuilder<TrackingDashboardController>(
          id: AppConstanst.barChart,
          builder: (controller) {
            return Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.toggleLateHistoryChart(0);
                    },
                    child: Container(
                      // width: 51.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: controller.barChartIndex == 0
                            ? AppColors.secondaryPrimary
                            : AppColors.background,
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.r),
                        ),
                      ),
                      child: Text(
                        'Counts'.tr,
                        style: AppTextStyles.font10RegularMonserrat.copyWith(
                          color: Get.find<TrackingDashboardController>()
                                      .barChartIndex ==
                                  0
                              ? AppColors.textButton
                              : AppColors.secondaryBlack,
                          fontSize: isTablet ? 12.sp : 10.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.toggleLateHistoryChart(1);
                    },
                    child: Container(
                      // width: 51.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: controller.barChartIndex == 1
                            ? AppColors.secondaryPrimary
                            : AppColors.background,
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.r),
                        ),
                      ),
                      child: Text(
                        'Minutes'.tr,
                        style: AppTextStyles.font10RegularMonserrat.copyWith(
                          color: controller.barChartIndex == 1
                              ? AppColors.textButton
                              : AppColors.secondaryBlack,
                          fontSize: isTablet ? 12.sp : 10.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
