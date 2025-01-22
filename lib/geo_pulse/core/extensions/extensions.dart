// Objectives: This file is responsible for providing extensions to several classes in the project.

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

final navKey = GlobalKey<NavigatorState>();

extension ContextExtension on BuildContext {
  // ScreenInfo
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  bool get isTablett => MediaQuery.of(this).size.shortestSide >= 600;

  bool get isArabic => Get.locale.toString().toLowerCase().contains('ar');

  void navigateTo(String routeName, {Object? arguments}) {
    navKey.currentState!.pushNamed(routeName, arguments: arguments);
  }
}

extension GetColor on String {
  Color? get getColor {
    if (this == 'Pending'.tr) {
      return AppColors.warming;
    }
    if (this == 'Approved'.tr) {
      return AppColors.green;
    }
    if (this == 'Rejected'.tr) {
      return AppColors.red;
    }
    return null;
  }
}
