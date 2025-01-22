import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/widgets/loading/circle_progress.dart';
import '../../../../../../core/widgets/no_data_gif.dart';
import '../../../controller/controller/attendance_controller.dart';

import '../../widget/cards/attendance_mobile_card.dart';

/// A mobile page that displays attendance data, including loading, no data, and list views.

class AttendanceMobilePage extends StatelessWidget {
  const AttendanceMobilePage({super.key, required this.readOnly});

  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackingAttendanceController>(
        id: AppConstanst.attendanceList,
        builder: (controller) {
          if (controller.isGettingAttendances) {
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
          if (controller.attendanceDataModel.isEmpty) {
            return const SliverToBoxAdapter(child: NoDataGif());
          }

          return SliverList.separated(
            separatorBuilder: (_, __) => verticalSpace(12),
            itemBuilder: (context, index) {
              final lastIndex =
                  index == controller.attendanceDataModel.length - 1;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: lastIndex ? 12.h : 0,
                ),
                child: AttendanceMobileCard(
                  modelIndex: index,
                ),
              );
            },
            itemCount: controller.attendanceDataModel.length,
          );
        });
  }
}
