import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/constants/strings.dart';
import '../../../../../../core/helpers/get_dialog_helper.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../controller/tracking_approvals_controller.dart';
import '../dialogs/rejection_dialog.dart';

/// Approve Buttons in Mobile - Tablet Views
class ApproveButtons extends StatelessWidget {
  final int modelIndex;
  const ApproveButtons({required this.modelIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TrackingApprovalsController>(
      id: AppConstanst.reminder,
      builder: (controller) {
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                controller.approveRequest(modelIndex);
              },
              child: Container(
                  height: 24.h,
                  width: 24.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: AppColors.lightGreen,
                  ),
                  child: SvgPicture.asset(
                    AppAssets.check,
                  )),
            ),
            horizontalSpace(8),
            GestureDetector(
              onTap: () {
                GetDialogHelper.generalDialog(
                  child: RejectionDialog(
                    modelIndex: modelIndex,
                  ),
                  context: context,
                );
              },
              child: Container(
                height: 24.h,
                width: 24.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: AppColors.red,
                ),
                child: SvgPicture.asset(
                  AppAssets.cancel,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
