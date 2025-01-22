import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../features/request_type/presentation/controller/request_types_controller.dart';
import '../../widgets/columns/mobile_request_type_column.dart';

/// Objectives: This file is responsible for providing the mobile request type details page widget used to view the details of a request type.

class MobileRequestTypeDetailsPage extends GetView<RequestTypeController> {
  const MobileRequestTypeDetailsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          controller.resetAllData();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: MobileRequestTypeColumn(
            editEnabled: false,
            title: 'Request Type'.tr,
          ),
        ),
      ),
    );
  }
}
