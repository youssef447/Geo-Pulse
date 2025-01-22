import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/core/constants/enums.dart';
import 'package:geo_pulse/geo_pulse/core/widgets/loading/circle_progress.dart';
import '../../../../../core/extensions/extensions.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/strings.dart';

import '../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../core/helpers/responsive_helper.dart';
import '../../../../../core/helpers/spacing_helper.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/buttons/app_default_button.dart';
import '../../../../../core/widgets/buttons/default_switch_button.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/responsive/orientation_layout.dart';
import 'package:geo_pulse/geo_pulse/features/users/models/user_model.dart';
import '../../controller/controller/check_in_controller.dart';
import '../../controller/controller/tracking_home_controller.dart';
import '../widgets/cards/mobile_user_home_card.dart';
import '../widgets/cards/tablet_user_home_card.dart';
import '../widgets/check_in_header/mobile_check_in_header.dart';
import '../widgets/check_in_header/tablet_check_in_header.dart';
import '../widgets/filter/mobile/calender_filter.dart';
import '../widgets/filter/mobile/mobile_filter.dart';
import '../widgets/filter/tablet/tablet_filter.dart';
import '../widgets/status/status_row.dart';
import '../widgets/tabbar/home_mobile_tabbar.dart';
import '../widgets/tabbar/home_tablet_tabbar.dart';
part '../widgets/appbar/home_appbar.dart';
part '../widgets/row_children.dart';

/// Representation: This is the home page of the tracking module.
class TrackingHomePage extends GetView<TrackingHomeController> {
  // attr used when the home page is reused for location individual list
  final UserModel? user;
  final String? locationName;

  const TrackingHomePage({
    super.key,
    this.user,
    this.locationName,
  });

  @override
  Widget build(BuildContext context) {
    var isTablet = context.isTablett;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          controller.setTabViews();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
            ),
            child: GetBuilder<TrackingHomeController>(
                id: AppConstanst.home,
                builder: (controller) {
                  if (controller.loading) {
                    return CircleProgress();
                  }
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: HomeAppbar(hideLeading: user == null),
                      ),
                      SliverToBoxAdapter(
                        child: UserRowChildren(
                            user: user, locationName: locationName),
                      ),
                      SliverToBoxAdapter(
                        child: OrientationLayout(
                          portrait: (BuildContext context) => isTablet
                              ? GetBuilder<CheckInController>(
                                  builder: (controller) {
                                  return controller.showHeader
                                      ? const SizedBox()
                                      : AppDefaultButton(
                                          style: AppTextStyles
                                              .font14BlackCairoMedium
                                              .copyWith(
                                            color: AppColors.textButton,
                                          ),
                                          text: 'Check In'.tr,
                                          width: 250,
                                          onPressed: () {
                                            controller.toggleShowHeader();
                                          });
                                })
                              : const SizedBox(),
                          landscape: (BuildContext context) => const SizedBox(),
                        ),
                      ),
                      SliverToBoxAdapter(child: verticalSpace(12)),
                      SliverToBoxAdapter(
                        child: user != null
                            ? isTablet
                                ? TabletUserHomeCard(
                                    user: user!,
                                  )
                                : MobileUserHomeCard(
                                    user: user!,
                                  )
                            : isTablet
                                ? GetBuilder<CheckInController>(
                                    builder: (controller) {
                                      return controller.showHeader
                                          ? const TabletCheckInHeader()
                                          : const SizedBox();
                                    },
                                  )
                                : GetBuilder<CheckInController>(
                                    builder: (controller) {
                                      return controller.showHeader
                                          ? const MobileCheckInHeader()
                                          : const SizedBox();
                                    },
                                  ),
                      ),
                      SliverToBoxAdapter(
                          child: ResponsiveHelper(
                        mobileWidget: const HomeMobileTabBar(),
                        tabletWidget: const HomeTabletTabBar(),
                      )),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.getCurrentTab() !=
                                HomeTabs.dashboard)
                              ResponsiveHelper(
                                mobileWidget: MobileFilter(
                                  onButtonTap: () {
                                    HapticFeedbackHelper.triggerHapticFeedback(
                                      vibration: VibrateType.mediumImpact,
                                      hapticFeedback:
                                          HapticFeedback.mediumImpact,
                                    );
                                    controller.onButtonTap(context);
                                  },
                                  currentTab: controller.getCurrentTab(),
                                  readOnly: user != null,
                                ),
                                tabletWidget: TabletFilter(
                                  onButtonTap: () {
                                    HapticFeedbackHelper.triggerHapticFeedback(
                                      vibration: VibrateType.mediumImpact,
                                      hapticFeedback:
                                          HapticFeedback.mediumImpact,
                                    );
                                    controller.onButtonTap(context);
                                  },
                                  currentTab: controller.getCurrentTab(),
                                  readOnly: user != null,
                                ),
                              ),
                            if (controller.getCurrentTab() ==
                                HomeTabs.attendance)
                              StatusRow(
                                statusItems: controller.attendanceStatusItems,
                                attendance: true,
                              ),
                            if (controller.getCurrentTab() == HomeTabs.requests)
                              StatusRow(
                                statusItems: controller.requestStatusItems,
                              ),
                            if ((controller.getCurrentTab() ==
                                        HomeTabs.attendance ||
                                    controller.getCurrentTab() ==
                                        HomeTabs.requests ||
                                    controller.getCurrentTab() ==
                                        HomeTabs.approvals) &&
                                context.isPhone)
                              CalenderFilter(
                                currentTab: controller.getCurrentTab(),
                              ),
                          ],
                        ),
                      ),
                      controller.tabs[controller.tabController.index],
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
