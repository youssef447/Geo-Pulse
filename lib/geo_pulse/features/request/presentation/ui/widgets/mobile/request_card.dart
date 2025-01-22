import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/core/extensions/extensions.dart';
import '../../../../../../core/constants/enums.dart';

import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/date_time_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../controller/requests_controller.dart';
import 'mobile_reminder_button.dart';

/// Request Card Widget in mobile view
class RequestCard extends GetView<TrackingRequestsController> {
  final int modelIndex;
  final bool readOnly;
  const RequestCard(
      {super.key, required this.modelIndex, required this.readOnly});

  @override
  Widget build(BuildContext context) {
    final month = DateTimeHelper.formatDate(
            controller.filteredRequests[modelIndex].requestDate)
        .split(' ')[0];
    final day = DateTimeHelper.formatDate(
            controller.filteredRequests[modelIndex].requestDate)
        .split(' ')[1]
        .split(',')[0];
    return GetBuilder<TrackingRequestsController>(
        id: AppConstanst.request,
        builder: (controller) {
          return Container(
            width: double.infinity,
            height: 82.h,
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              border: Border.all(
                color: controller
                    .filteredRequests[modelIndex].requestStatus.getColor,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40.h,
                      width: 40.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.filteredRequests[modelIndex]
                              .requestStatus.getColor,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$day\n',
                              style:
                                  AppTextStyles.font16BlackMediumCairo.copyWith(
                                color: controller.filteredRequests[modelIndex]
                                    .requestStatus.getColor,
                                fontWeight: FontWeight.w800,
                                height: 0.5,
                              ),
                            ),
                            Text(
                              month,
                              style: AppTextStyles.font14BlackRegularCairo
                                  .copyWith(
                                color: controller.filteredRequests[modelIndex]
                                    .requestStatus.getColor,
                                height: 0.5,
                              ),
                            )
                          ]),
                    ),
                    Text(
                      controller.filteredRequests[modelIndex].requestStatus
                          .getName.tr,
                      style: AppTextStyles.font14BlackRegularCairo.copyWith(
                        color: controller.filteredRequests[modelIndex]
                            .requestStatus.getColor,
                      ),
                    ),
                  ],
                ),
                _buildLabelColumn(
                    "Type".tr,
                    (context.isArabic
                        ? controller
                            .filteredRequests[modelIndex].requestType.arabicName
                        : controller.filteredRequests[modelIndex].requestType
                            .englishName)),
                _buildLabelColumn(
                    "Total Time".tr,
                    DateTimeHelper.formatDuration(
                        controller.filteredRequests[modelIndex].totalTime)),
                if (!readOnly)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Action".tr,
                          style: AppTextStyles.font12BlackCairoRegular.copyWith(
                              color: AppColors.inputColor, height: 1)),
                      verticalSpace(18),
                      MobileReminderButton(
                        modelIndex: modelIndex,
                      ),
                    ],
                  )
              ],
            ),
          );
        });
  }

  Widget _buildLabelColumn(String label, String value) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(label,
              style: AppTextStyles.font12BlackCairoRegular
                  .copyWith(color: AppColors.inputColor)),
          verticalSpace(18),
          Text(
            value,
            style: AppTextStyles.font14BlackRegularCairo,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
