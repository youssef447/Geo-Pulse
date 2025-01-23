import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../controller/controller/location_controller.dart';
import '../../../controller/controller/location_details_controller.dart';
import '../../widgets/location details/appbar/tablet_loc_details_appbar.dart';
import '../../widgets/location details/tabbar/loc_details_tabbar.dart';
import '../../widgets/location details/tabs/tablet/tablet_individual_list.dart';
import '../../widgets/location details/tabs/tablet/tablet_loc_description.dart';
import '../../widgets/location details/tabs/tablet/tablet_loc_settings.dart';

///location details Page in Tablet View
class TabletLocationDetails extends GetView<LocationController> {
  final int index;
  final bool readOnly;

  const TabletLocationDetails({
    super.key,
    required this.index,
    required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      TabletLocDescription(index: index),
      TabletLocSettings(index: index),
      TabletIndividualList(index: index, readOnly: readOnly),
    ];
    final isLandScape = context.isLandscape;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: isLandScape ? 24.w : 16.w,
            right: isLandScape ? 45.w : 42.w,
          ),
          child: GetBuilder<LocationDetailsController>(
              init: Get.put(LocationDetailsController()),
              id: AppConstanst.locationDetails,
              builder: (controller) {
                return CustomScrollView(slivers: [
                  SliverToBoxAdapter(child: verticalSpace(24)),
                  SliverToBoxAdapter(
                      child: TabletLocDetailsAppbar(index: index)),
                  SliverToBoxAdapter(child: verticalSpace(32)),
                  const SliverToBoxAdapter(child: LocationDetailsTabBar()),
                  SliverToBoxAdapter(child: verticalSpace(32)),
                  SliverToBoxAdapter(
                    child: tabs[controller.tabController.index],
                  ),
                ]);
              }),
        ),
      ),
    );
  }
}
