import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/widgets/fields/default_form_field.dart';
import '../../../../../../core/widgets/cards/chip_card.dart';
import '../../../controller/controller/location_controller.dart';
import '../../../controller/controller/location_details_controller.dart';
import '../../widgets/location details/appbar/mobile_loc_details_appbar.dart';
import '../../widgets/location details/tabbar/loc_details_tabbar.dart';
import '../../widgets/location details/tabs/mobile/mobile_individual_list.dart';
import '../../widgets/location details/tabs/mobile/mobile_loc_description.dart';
import '../../widgets/location details/tabs/mobile/mobile_loc_settings.dart';

///location details Page in Mobile View

class MobileLocationDetails extends GetView<LocationController> {
  final int index;
  final bool readOnly;
  const MobileLocationDetails(
      {super.key, required this.index, required this.readOnly});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      MobileLocDescription(index: index),
      MobileLocSettings(index: index),
      MobileIndividualList(index: index, readOnly: readOnly),
    ];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: GetBuilder<LocationDetailsController>(
            init: Get.put(LocationDetailsController()),
            id: AppConstanst.locationDetails,
            builder: (controller) {
              return CustomScrollView(slivers: [
                SliverToBoxAdapter(child: verticalSpace(24)),
                SliverToBoxAdapter(child: MobileLocDetailsAppbar(index: index)),
                SliverToBoxAdapter(child: verticalSpace(8)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 16.w),
                    child: const LocationDetailsTabBar(),
                  ),
                ),
                SliverToBoxAdapter(child: verticalSpace(16)),
                if (controller.tabController.index == 2)
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: AppTextFormField(
                                  height: 44.h,
                                  maxLines: 1,
                                  width: double.infinity,
                                  hintText: 'Search Here...'.tr,
                                  collapsed: true,
                                  backGroundColor: AppTheme.isDark ?? false
                                      ? AppColors.field
                                      : AppColors.white,
                                  hintStyle: context.isTablett
                                      ? AppTextStyles.font16BlackMediumCairo
                                      : AppTextStyles.font12BlackCairo,
                                  controller: controller.searchController,
                                  contentPadding: context.isTablett
                                      ? EdgeInsets.symmetric(
                                          vertical: 2.h,
                                        )
                                      : null,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r)),
                                  prefixIcon: SvgPicture.asset(
                                    AppAssets.search,
                                    width: context.isTablett ? 24.w : 16.0.w,
                                    height: context.isTablett ? 24.h : 16.0.h,
                                  ),
                                ),
                              ),
                            ),
                            horizontalSpace(8),
                            ChipCard(
                              image: AppAssets.export,
                              onTap: () {
                                HapticFeedbackHelper.triggerHapticFeedback(
                                  vibration: VibrateType.mediumImpact,
                                  hapticFeedback: HapticFeedback.mediumImpact,
                                );
                                controller.exportTable(index);
                              },
                            ),
                          ],
                        ),
                        verticalSpace(12),
                      ],
                    ),
                  ),
                tabs[controller.tabController.index],
              ]);
            },
          ),
        ),
      ),
    );
  }
}
