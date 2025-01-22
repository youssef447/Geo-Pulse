import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/constants/enums.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/dropdown/app_dropdown.dart';
import '../../../controller/tracking_approvals_controller.dart';

/// Represents the status dropdown widget for the tracking approvals screen.
class StatusDropDown extends GetView<TrackingApprovalsController> {
  const StatusDropDown({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    final isLandScape = context.isLandscape;

    return GetBuilder<TrackingApprovalsController>(
      id: AppConstanst.statusDropdown,
      builder: (controller) {
        return Row(
          children: [
            SvgPicture.asset(AppAssets.status),
            horizontalSpace(8),
            Text(
              'Status:'.tr,
              style: context.isTablett
                  ? AppTextStyles.font18SecondaryBlackCairoMedium
                  : AppTextStyles.font14SecondaryBlackCairo,
            ),
            horizontalSpace(8),
            if (context.isPhone)
              Expanded(
                  child: _BuildDropdown(
                      index: index,
                      isLandScape: isLandScape,
                      controller: controller)),
            if (context.isTablett)
              _BuildDropdown(
                  index: index,
                  isLandScape: isLandScape,
                  controller: controller)
          ],
        );
      },
    );
  }
}

class _BuildDropdown extends StatelessWidget {
  const _BuildDropdown({
    required this.index,
    required this.isLandScape,
    required this.controller,
  });

  final int index;
  final bool isLandScape;
  final TrackingApprovalsController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isLandScape
          ? 265
          : context.isTablett
              ? 230.w
              : 225.w,
      child: AppDropdown(
        height: 40.h,
        value: controller.selectedReqStatus,
        textButton: controller.selectedReqStatus.getName.tr,
        textColor: controller.selectedReqStatus.getColor,
        showDropdownIcon: false,
        items: [],
        onChanged: (value) {
          controller.selectReqStatus(
              value: value, context: context, index: index);
        },
      ),
    );
  }
}
