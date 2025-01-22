import 'package:get/get.dart';

enum DashboardCategory {
  present,
  late,
  absent,
  vacationCredit,
}
extension DashboardCategoryExtension on DashboardCategory {
  String get localized {
    switch (this) {
      case DashboardCategory.present:
        return 'Present'.tr;
      case DashboardCategory.late:
        return 'Late'.tr;
      case DashboardCategory.absent:
        return 'Absent'.tr;
      case DashboardCategory.vacationCredit:
        return 'Vacations Credit'.tr;
    }
  }
}
