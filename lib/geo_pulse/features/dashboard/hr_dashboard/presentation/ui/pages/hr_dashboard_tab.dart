// Objectives: This file is responsible for providing the layout of hr dashboard screen.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/features/dashboard/my_dashboard/presentation/ui/page/dashboard_tab.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/widgets/no_data_gif.dart';

import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/widgets/responsive/adaptive_layout.dart';
import '../../../../../home/presentation/controller/controller/tracking_home_controller.dart';
import '../../../../my_dashboard/presentation/controller/tracking_dashboard_controller.dart';

import '../widgets/dashboard_toggle/hr_dashboard_toggle_switch.dart';
import '../widgets/layouts/hr_dashboard_mobile_layout.dart';
import '../widgets/layouts/hr_dashboard_tablet_layout.dart';

class HRDashboardTab extends StatelessWidget {
  const HRDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          verticalSpace(12),
          AdaptiveLayout(
            mobileLayout: (context) => const HRDashboardToggleSwitch(),
            tabletLayout: (context) => const Align(
              alignment: AlignmentDirectional.centerStart,
              child: HRDashboardToggleSwitch(),
            ),
          ),
          verticalSpace(12),
          GetBuilder<TrackingHomeController>(
            id: AppConstanst.hrDashboardLayout,
            builder: (controller) {
              bool showMyDashboard =
                  Get.find<TrackingDashboardController>().showData!;
              final currentLayout = controller.hrLayoutIndex == 0
                  ? showMyDashboard
                      ? DashboardTab()
                      : const NoDataGif()
                  : showMyDashboard
                      ? AdaptiveLayout(
                          mobileLayout: (context) =>
                              const HRDashboardMobileLayout(),
                          tabletLayout: (context) =>
                              const HRDashboardTabletLayout(),
                        )
                      : const NoDataGif();

              return currentLayout;
            },
          ),
        ],
      ),
    );
  }
}
