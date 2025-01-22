import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../features/request_type/presentation/controller/request_types_controller.dart';

import '../../widgets/columns/mobile_request_type_column.dart';

/// Objectives: This file is responsible for providing the mobile request type page widget used to add or edit a request type.

class MobileRequestTypePage extends GetView<RequestTypeController> {
  const MobileRequestTypePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          controller.resetAllData();
        }
      },
      child: GetBuilder<RequestTypeController>(
        id: 'addRequestType',
        builder: (controller) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Padding(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: controller.newReqTypeFormKey,
                child: MobileRequestTypeColumn(
                  editEnabled: true,
                  title: title,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
