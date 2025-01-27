import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_colors.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_text_styles.dart';
import 'package:geo_pulse/geo_pulse/features/notifications/data/models/notification_model.dart';

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
      height: 200.h,
      child: ListTile(
        title: Text(
          model.title,
          style: AppTextStyles.font16BlackMediumCairo,
        ),
        subtitle: Text(
          model.title,
          style: AppTextStyles.font14BlackCairoRegular,
        ),
        trailing: Text(
          model.type,
          style: AppTextStyles.font14BlackCairoRegular,
        ),
      ),
    );
  }
}
