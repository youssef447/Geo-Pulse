import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:geo_pulse/geo_pulse/core/error_handling/faliure.dart';
import 'package:geo_pulse/geo_pulse/features/notifications/data/models/notification_model.dart';
import 'package:get/get.dart';

import '../../../users/logic/add_employee_controller.dart';
import '../domain/i_notification_repo.dart';

class NotificationsRepoImp implements INotificationsRepo {
  final _db = FirebaseFirestore.instance;
  @override
  Future<Either<Faliure, List<NotificationModel>>> fetchNotifications() async {
    try {
      List<NotificationModel> result = [];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(Get.find<UserController>().employee!.email)
          .collection('Notifications')
          .orderBy('Timestamp', descending: true)
          .get();

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
      QuerySnapshot querySnapshot = await _db
          .collection('Notifications')
          .doc(Get.find<UserController>().employee!.email)
          .collection('Notifications')
          .where('seen', isEqualTo: false)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({'seen': true});
      }
      return Right(null);
    } on FirebaseException catch (e) {
      return Left(ServiceFailure.fromFirebase(e));
    } catch (e) {
      return Left(Faliure(message: e.toString()));
    }
  }
}
