import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/widgets/loading/circle_progress.dart';
import '../../../../../../core/widgets/no_data_gif.dart';
import '../../../controller/requests_controller.dart';
import '../../widgets/mobile/request_card.dart';

/// This file is responsible for providing the requests tab in mobile view.

class MobiletRequestsTab extends StatelessWidget {
  const MobiletRequestsTab({super.key, required this.readOnly});

  final bool readOnly;

  @override
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackingRequestsController>(
        id: AppConstanst.request,
        builder: (controller) {
          if (controller.isGettingRequests) {
            return SliverToBoxAdapter(
                child: SizedBox(
              height: Get.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleProgress(),
                ],
              ),
            ));
          }
          if (controller.filteredRequests.isEmpty) {
            return const SliverToBoxAdapter(child: NoDataGif());
          }
          return SliverList.separated(
            separatorBuilder: (_, __) => verticalSpace(12),
            itemBuilder: (context, index) {
              final lastIndex = index == controller.filteredRequests.length - 1;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: lastIndex ? 12.h : 0,
                ),
                child: RequestCard(
                  readOnly: readOnly,
                  modelIndex: index,
                ),
              );
            },
            itemCount: controller.filteredRequests.length,
          );
        });
  }
}
