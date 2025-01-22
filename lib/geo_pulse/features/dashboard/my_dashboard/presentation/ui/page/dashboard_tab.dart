import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/widgets/loading/circle_progress.dart';
import '../../../../../../core/widgets/no_data_gif.dart';
import '../../../../../../core/widgets/responsive/adaptive_layout.dart';
import '../../controller/tracking_dashboard_controller.dart';
import '../widgets/layouts/dashboard_mobile_layout.dart';
import '../widgets/layouts/dashboard_tablet_layout.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackingDashboardController>(
        id: AppConstanst.dashboard,
        builder: (controller) {
          if (controller.loading) {
            return SizedBox(
              height: Get.height * 0.55,
              child: const CircleProgress(),
            );
          }
          return !controller.showData!
              ? const NoDataGif()
              : Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: AdaptiveLayout(
                    mobileLayout: (context) => const DashboardMobileLayout(),
                    tabletLayout: (context) => const DashboardTabletLayout(),
                  ),
                );
        });
  }
}
