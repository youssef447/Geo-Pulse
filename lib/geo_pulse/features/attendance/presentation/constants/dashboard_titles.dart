import 'dart:ui';

import 'package:tracking_module/tracking_module/core/theme/app_colors.dart';
import 'package:tracking_module/tracking_module/features/dashboard/my_dashboard/data/enums/dashboard_category.dart';

/// A map defining dashboard categories with their respective colors.
final Map<DashboardCategory, Color> dashboardTitles = {
  DashboardCategory.present: AppColors.lightGreen,
  DashboardCategory.late: AppColors.orange,
  DashboardCategory.absent: AppColors.darkRed,
  DashboardCategory.vacationCredit: AppColors.yellow,
};
