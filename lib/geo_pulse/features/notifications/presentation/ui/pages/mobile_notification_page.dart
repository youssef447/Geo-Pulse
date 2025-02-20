import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geo_pulse/geo_pulse/core/helpers/spacing_helper.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_colors.dart';
import 'package:geo_pulse/geo_pulse/core/theme/app_text_styles.dart';
import 'package:geo_pulse/geo_pulse/core/widgets/no_data_gif.dart';
import 'package:geo_pulse/geo_pulse/features/notifications/presentation/ui/widgets/notification_card.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/appbar/mobile_custom_appbar.dart';
import '../../controller/notification_controller.dart';

class MobileNotificationPage extends StatelessWidget {
  const MobileNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppNotificationController>(
      id: 'notification_page',
      builder: (controller) {
        if (controller.error != null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text(
                controller.error!,
                style: AppTextStyles.font18SecondaryBlackCairoMedium,
              ),
            ),
          );
        }
        if (controller.allNotifications.isEmpty) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: NoDataGif(),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                children: [
                  CustomMobileAppbar(
                    title: 'Notifications'.tr,
                  ),
                  verticalSpace(20),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (_, __) => verticalSpace(12),
                      itemCount: controller.allNotifications.length,
                      itemBuilder: (context, index) => NotificationCard(
                        model: controller.allNotifications[index],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
