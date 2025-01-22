import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/features/home/presentation/controller/controller/tracking_home_controller.dart';
import '../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../core/constants/strings.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';

class HRDashboardToggleSwitch extends StatelessWidget {
  const HRDashboardToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    var isTablet = context.isTablett;

    return GetBuilder<TrackingHomeController>(
      id: AppConstanst.hrDashboardSwitch,
      builder: (controller) {
        return Container(
          width: isTablet ? 400.w : double.infinity,
          height: isTablet ? 45.h : 40.h,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(4.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 6.h),
          margin: EdgeInsets.zero,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.toggleHRDashboardLayout(0);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: controller.hrLayoutIndex == 0
                          ? AppColors.secondaryPrimary
                          : AppColors.card,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.r),
                      ),
                    ),
                    child: Text(
                      'My Dashboard'.tr,
                      style: AppTextStyles.font16MediumMonserrat.copyWith(
                        color: controller.hrLayoutIndex == 0
                            ? AppColors.textButton
                            : AppColors.secondaryBlack,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.toggleHRDashboardLayout(1);
                  },
                  child: Container(
                    // width: 51.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: controller.hrLayoutIndex == 1
                          ? AppColors.secondaryPrimary
                          : AppColors.card,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.r),
                      ),
                    ),
                    child: Text(
                      'Human Resources'.tr,
                      style: AppTextStyles.font16MediumMonserrat.copyWith(
                        color: controller.hrLayoutIndex == 1
                            ? AppColors.textButton
                            : AppColors.secondaryBlack,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
