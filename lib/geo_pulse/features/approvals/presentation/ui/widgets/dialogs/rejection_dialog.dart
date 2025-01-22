import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/fields/default_form_field.dart';
import '../../../controller/tracking_approvals_controller.dart';

/// Reasons of Rejection Dialog in mobile - tablet views
class RejectionDialog extends GetView<TrackingApprovalsController> {
  final int modelIndex;
  const RejectionDialog({super.key, required this.modelIndex});

  @override
  Widget build(BuildContext context) {
    final isLandScape = context.isLandscape;
    final isTablet = context.isTablett;
    return Container(
      width: isLandScape
          ? 768.w
          : isTablet
              ? 568.w
              : 343.w,
      decoration: BoxDecoration(
        color: AppColors.dialog,
        borderRadius: BorderRadiusDirectional.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reasons of Rejection'.tr,
            style: AppTextStyles.font16BlackMediumCairo,
          ),
          verticalSpace(8),
          AppTextFormField(
            hintText: 'Reasons of Rejection'.tr,
            maxLength: 200,
            maxLines: 4,
            hintStyle: AppTextStyles.font12SecondaryBlackCairoRegular,
            style: AppTextStyles.font12SecondaryBlackCairoRegular,
            height: 96.h,
            showBorder: true,
            width: double.infinity,
            controller: controller.rejectionController,
            onChanged: (_) {
              controller.update(['rejectionSubmit']);
            },
          ),
          verticalSpace(44),
          Align(
            alignment:
                isLandScape ? AlignmentDirectional.centerEnd : Alignment.center,
            child: GetBuilder<TrackingApprovalsController>(
                id: 'rejectionSubmit',
                builder: (controller) {
                  return GestureDetector(
                    onTap: () {
                      if (controller.rejectionController.text.isNotEmpty) {
                        controller.rejectRequest(modelIndex);
                      }
                    },
                    child: Container(
                      height: 42.h,
                      width: isLandScape ? 191.w : double.infinity,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        color: controller.rejectionController.text.isEmpty
                            ? AppColors.whiteShadow
                            : AppColors.primary,
                      ),
                      child: Text(
                        'Submit'.tr,
                        style: AppTextStyles.font14BlackCairoMedium.copyWith(
                          color: controller.rejectionController.text.isEmpty
                              ? AppColors.black
                              : AppColors.textButton,
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
