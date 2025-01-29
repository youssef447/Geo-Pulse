import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import 'package:geo_pulse/geo_pulse/core/error_handling/faliure.dart';
import 'package:geo_pulse/geo_pulse/features/notifications/data/models/notification_model.dart';

import '../data_source/notifications_data_source.dart';
import '../../domain/i_notification_repo.dart';

class NotificationsRepoImp implements INotificationsRepo {
  final NotificationsDataSource dataSource;
  NotificationsRepoImp({
    required this.dataSource,
  });
  @override
  Future<Either<Faliure, List<NotificationModel>>> fetchNotifications() async {
    try {
      List<NotificationModel> result = [];

      QuerySnapshot querySnapshot = await dataSource.fetchNotifications();

      result = querySnapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return Right(result);
    } on FirebaseException catch (e) {
      return Left(ServiceFailure.fromFirebase(e));
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }

  @override
  Future<Either<Faliure, void>> updateSeenNotifications() async {
    try {
      await dataSource.updateSeenNotifications();
      return Right(null);
    } on FirebaseException catch (e) {
      return Left(ServiceFailure.fromFirebase(e));
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }
}
