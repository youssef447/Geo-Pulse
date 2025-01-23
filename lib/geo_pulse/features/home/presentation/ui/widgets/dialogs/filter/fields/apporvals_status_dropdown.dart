import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../../../core/constants/enums.dart';

import '../../../../../../../../core/constants/strings.dart';
import '../../../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../../../core/widgets/dropdown/app_dropdown.dart';
import '../../../../../controller/controller/tracking_home_controller.dart';

/// Representation: This file is responsible for providing the request status dropdown in the filter dialog.
class ApporvalsStatusDropdown extends StatelessWidget {
  const ApporvalsStatusDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackingHomeController>(
      id: AppConstanst.filterDialog,
      builder: (controller) {
        return AppDropdown(
          height: 40.h,
          width: double.infinity,
          value: controller.apporvalsStatus,
          textColor: controller.apporvalsStatus?.getColor,
          textButton:
              controller.apporvalsStatus?.getName.tr ?? 'Request Status'.tr,
          items: RequestStatus.values.map((e) {
            return DropdownMenuItem(
              alignment: AlignmentDirectional.centerStart,
              value: e,
              child: Text(
                e.getName.tr,
                style: AppTextStyles.font14SecondaryBlackCairo
                    .copyWith(color: e.getColor),
              ),
            );
          }).toList(),
          onChanged: (value) {
            controller.selectApprovalsReqStatus(value);
          },
        );
      },
    );
  }
}
