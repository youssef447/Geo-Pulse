import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../features/request_type/presentation/controller/request_types_controller.dart';

import '../../widgets/columns/tablet_request_type_column.dart';

/// Objectives: This file is responsible for providing the tablet request type page widget used to add or edit a request type.

class TabletRequestTypePage extends GetView<RequestTypeController> {
  const TabletRequestTypePage({
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
                child: TabletRequestTypeColumn(
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
