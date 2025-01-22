import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/helpers/spacing_helper.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../request/presentation/ui/widgets/attachments/attachment_card.dart';
import '../../controller/tracking_approvals_controller.dart';

/// Represents the attachment section widget for the tracking approvals screen.
class AttachmentSection extends GetView<TrackingApprovalsController> {
  const AttachmentSection({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          //spacing: 8.w,
          children: [
            SvgPicture.asset(AppAssets.attachment),
            horizontalSpace(8),
            Text(
              'Attachments:'.tr,
              style: context.isTablett
                  ? AppTextStyles.font18SecondaryBlackCairoMedium
                  : AppTextStyles.font14SecondaryBlackCairo,
            ),
          ],
        ),
        verticalSpace(6),
        if (controller.approvalRequests[index].attachments != null)
          Wrap(
              runSpacing: 8.w,
              spacing: 8.w,
              children: List.generate(
                controller.approvalRequests[index].attachments!.length,
                (attachmentIndex) {
                  return AttachmentCard(
                    docModel: controller
                        .approvalRequests[index].attachments![attachmentIndex],
                  );
                },
              )),
      ],
    );
  }
}
