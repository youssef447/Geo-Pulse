import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geo_pulse/geo_pulse/core/extensions/extensions.dart';
import 'package:geo_pulse/geo_pulse/core/helpers/date_time_helper.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_colors.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_text_styles.dart';
import 'package:geo_pulse/geo_pulse/features/notifications/data/models/notification_model.dart';
import 'package:get/get.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel model;
  const NotificationCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        16.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              context.isArabic ? model.titleArabic : model.title,
              style: AppTextStyles.font16BlackMediumCairo,
            ),
            subtitle: Text(
              DateTimeHelper.formatDate(model.timestamp.toDate()),
              style: AppTextStyles.font14BlackCairoRegular,
            ),
            trailing: Text(
              model.type.tr,
              style: AppTextStyles.font14BlackCairoRegular,
            ),
          ),
        ],
      ),
    );
  }
}
