import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../core/extensions/extensions.dart';

import '../../../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../../../core/routes/app_routes.dart';
import '../../../../../../../../core/routes/route_arguments.dart';
import '../../../../../../../../core/widgets/no_data_gif.dart';
import '../../../../../../../home/presentation/controller/controller/tracking_home_controller.dart';
import '../../../../../controller/controller/location_controller.dart';
import '../../../../../controller/controller/location_details_controller.dart';
import '../../cards/individual_card.dart';

/// Date: 20/10/2024
/// By: Youssef Ashraf
///tabbar body of Individual List in mobile
class MobileIndividualList extends StatelessWidget {
  const MobileIndividualList({
    super.key,
    required this.index,
    required this.readOnly,
  });
  final int index;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationDetailsController>(
      id: 'individuals',
      builder: (controller) {
        if (Get.find<LocationController>()
            .locationModels[index]
            .employees
            .isEmpty) {
          return const SliverToBoxAdapter(child: NoDataGif());
        }

        return SliverList.separated(

            /* padding: EdgeInsets.symmetric(
                  vertical: 12.h,
                ), */
            separatorBuilder: (_, __) => verticalSpace(8),
            itemCount: Get.find<LocationController>()
                .locationModels[index]
                .employees
                .length,
            itemBuilder: (context, empIndex) => GestureDetector(
                  onTap: () {
                    final model = Get.find<LocationController>()
                        .locationModels[index]
                        .employees[empIndex];
                    final name = context.isArabic
                        ? Get.find<LocationController>()
                            .locationModels[index]
                            .locationNameArabic
                        : Get.find<LocationController>()
                            .locationModels[index]
                            .locationNameEnglish;

                    if (!readOnly) {
                      context.navigateTo(
                        Routes.trackingHome,
                        arguments: {
                          RouteArguments.user: model,
                          RouteArguments.locationName: name,
                        },
                      );
                      Get.find<TrackingHomeController>().setTabViews(model);
                    }
                  },
                  child: IndividualCard(
                    model: Get.find<LocationController>()
                        .locationModels[index]
                        .employees[empIndex],
                  ),
                ));
      },
    );
  }
}
