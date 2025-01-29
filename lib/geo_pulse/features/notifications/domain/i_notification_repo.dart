import 'package:dartz/dartz.dart';

import '../../../core/error_handling/faliure.dart';
import '../data/models/notification_model.dart';

abstract class INotificationsRepo {
  Future<Either<Faliure, List<NotificationModel>>> fetchNotifications();
  Future<Either<Faliure, void>> updateSeenNotifications();
}
