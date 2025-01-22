import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/routes/route_arguments.dart';
import '../../../../../../core/widgets/loading/circle_progress.dart';
import '../../../../../../core/widgets/no_data_gif.dart';

import '../../../controller/controller/location_controller.dart';
import '../../widgets/location/location_card.dart';

/// A tab displaying a list of locations, allowing navigation to location details when tapped.

class MobileLocationTab extends StatefulWidget {
  const MobileLocationTab({super.key, required this.readOnly});

  final bool readOnly;

  @override
  State<MobileLocationTab> createState() => _MobileLocationTabState();
}

class _MobileLocationTabState extends State<MobileLocationTab> {
  // init state to get locations

  @override
  void initState() {
    Get.find<LocationController>().getAllLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      id: AppConstanst.location,
      builder: (controller) {
        if (controller.isGettingLocations) {
          return SliverToBoxAdapter(
              child: SizedBox(
            height: Get.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleProgress(),
              ],
            ),
          ));
        }

        if (controller.locationModels.isEmpty) {
          return const SliverToBoxAdapter(child: NoDataGif());
        }

        return SliverList.separated(
          separatorBuilder: (_, __) => verticalSpace(12),
          itemCount: controller.locationModels.length,
          itemBuilder: (context, index) {
            final isLastIndex = index == controller.locationModels.length - 1;
            return Padding(
              padding: EdgeInsets.only(
                bottom: isLastIndex ? 12.h : 0,
              ),
              child: GestureDetector(
                onTap: () {
                  HapticFeedbackHelper.triggerHapticFeedback(
                    vibration: VibrateType.mediumImpact,
                    hapticFeedback: HapticFeedback.mediumImpact,
                  );
                  context.navigateTo(
                    Routes.locationDetails,
                    arguments: {
                      RouteArguments.locationModelIndex: index,
                      RouteArguments.readOnly: widget.readOnly,
                    },
                  );
                },
                child: LocationCard(
                  modelIndex: index,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
