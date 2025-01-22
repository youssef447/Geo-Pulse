import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';

import '../../../../../../core/helpers/haptic_feedback_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/widgets/loading/circle_progress.dart';
import '../../../../../../core/widgets/no_data_gif.dart';
import '../../../controller/request_types_controller.dart';
import '../cards/request_type_card.dart';

/// This file is responsible for providing the default mobile requests tab widget .

class MobileRequestsTypeTab extends StatefulWidget {
  const MobileRequestsTypeTab({super.key, required this.readOnly});

  final bool readOnly;

  @override
  State<MobileRequestsTypeTab> createState() => _MobileRequestsTypeTabState();
}

class _MobileRequestsTypeTabState extends State<MobileRequestsTypeTab> {
  @override
  void initState() {
    Get.find<RequestTypeController>().getRequestTypes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestTypeController>(
        id: 'requestType',
        builder: (controller) {
          if (controller.isGettingRequestTypes) {
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
          if (controller.requestTypeModels.isEmpty) {
            return const SliverToBoxAdapter(child: NoDataGif());
          }

          return SliverList.separated(
              separatorBuilder: (_, __) => verticalSpace(12),
              itemCount: controller.requestTypeModels.length,
              itemBuilder: (context, index) {
                final isLastIndex =
                    index == controller.requestTypeModels.length - 1;
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
                      controller.setSelectedRequestType(
                        controller.requestTypeModels[index],
                      );
                      context.navigateTo(
                        Routes.requestTypeDetails,
                      );
                    },
                    child: RequestTypeCard(
                      readOnly: widget.readOnly,
                      modelIndex: index,
                    ),
                  ),
                );
              });
        });
  }
}
