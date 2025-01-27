import 'package:geo_pulse/geo_pulse/features/notifications/data/domain/i_notification_repo.dart';

import 'package:get/get.dart';

import '../../data/models/notification_model.dart';

class AppNotificationController extends GetxController {
  final INotificationsRepo notificationRepo;
  AppNotificationController({required this.notificationRepo});

  List<NotificationModel> allNotifications = [];
  bool isLoading = false;
  int unseenCount = 0;
  String? error;

  /// Fetch all notifications for the currently logged in employee and store them

  Future<void> fetchNotifications() async {
    isLoading = true;
    final result = await notificationRepo.fetchNotifications();

    isLoading = false;
    result.fold((e) {
      error = e.message;
    }, (r) {
      allNotifications = r;
    });
  }

  void getUnseenNotificationsCount() {
    unseenCount = allNotifications.where((e) => e.seen == false).length;
  }

  /// Mark all unseen notifications for the currently logged in employee as seen
  /// This is typically called when the user opens the notifications screen.
  Future<void> updateSeenNotifications() async {
    final result = await notificationRepo.updateSeenNotifications();

    isLoading = false;
    result.fold((e) {
      error = e.message;
    }, (r) {});
  }
}
