import 'package:flutter/material.dart';
import 'package:geo_pulse/geo_pulse/features/notifications/presentation/controller/notification_controller.dart';
import 'package:get/get.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/widgets/appbar/custom_app_bar.dart';
import '../widgets/notification_card.dart';

class TabletNotificationPage extends GetView<AppNotificationController> {
  const TabletNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.error != null) {
      return Center(
        child: Text(
          controller.error!,
          style: AppTextStyles.font18SecondaryBlackCairoMedium,
        ),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: 'Notifications'.tr),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (context, index) => NotificationCard(
            model: controller.allNotifications[index],
          ),
        ),
      ),
    );
  }
}
