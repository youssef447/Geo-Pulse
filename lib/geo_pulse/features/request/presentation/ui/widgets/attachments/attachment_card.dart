import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/helpers/spacing_helper.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/doc_model.dart';
import '../../../controller/requests_controller.dart';

/// This file is responsible for providing the default attachment card widget .
class AttachmentCard extends GetView<TrackingRequestsController> {
  final DocModel docModel;
  final bool? showDelete;
  const AttachmentCard({
    super.key,
    required this.docModel,
    this.showDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      width: context.isPhone ? double.infinity : 193.w,
      padding: EdgeInsets.symmetric(
        horizontal: 6.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.whiteShadow),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            docModel.getExstensionImage(),
            width: 50.w,
            height: 50.h,
          ),
          horizontalSpace(5),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(docModel.fileName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font14BlackCairoMedium),
                Text('${docModel.totalSize!.toStringAsFixed(2)} ${'MB'.tr}',
                    style: AppTextStyles.font12SecondaryBlackMediumCairo),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showDelete ?? false)
                GestureDetector(
                  onTap: () {
                    controller.removeAttachment(docModel);
                  },
                  child: SvgPicture.asset(
                    AppAssets.delete,
                  ),
                ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  await launchUrl(Uri.parse(docModel.link!));
                },
                child: SvgPicture.asset(
                  AppAssets.download,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
