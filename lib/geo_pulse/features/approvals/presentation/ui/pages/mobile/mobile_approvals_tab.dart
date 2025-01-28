import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../core/helpers/spacing_helper.dart';

import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/widgets/loading/circle_progress.dart';
import '../../../../../../core/widgets/no_data_gif.dart';
import '../../../controller/tracking_approvals_controller.dart';
import '../../widgets/cards/mobile_approvals_card.dart';

/// Represents the approvals tab for the mobile approvals screen.

class MobileApprovalsTab extends StatelessWidget {
  const MobileApprovalsTab({super.key, required this.readOnly});

  final bool readOnly;

  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackingApprovalsController>(
        id: AppConstanst.approvals,
        builder: (controller) {
          if (controller.isGettingRequests) {
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
          if (controller.approvalRequests.isEmpty) {
            return const SliverToBoxAdapter(child: NoDataGif());
          }
          return SliverList.separated(
            separatorBuilder: (_, __) => verticalSpace(12),
            itemBuilder: (context, index) {
              final lastIndex = index == controller.approvalRequests.length - 1;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: lastIndex ? 12.h : 0,
                ),
                child: MobileApprovalsCard(
                  readOnly: readOnly,
                  index: index,
                ),
              );
            },
            itemCount: controller.approvalRequests.length,
          );
        });
  }
}
