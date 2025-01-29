import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../users/logic/add_employee_controller.dart';

class NotificationsDataSource {
  final _db = FirebaseFirestore.instance;

  Future<QuerySnapshot> fetchNotifications() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Notifications')
        .doc(Get.find<UserController>().employee!.email)
        .collection('Notifications')
        .orderBy('Timestamp', descending: true)
        .get();

    return querySnapshot;
  }

  Future<void> updateSeenNotifications() async {
    final querySnapshot = await _db
        .collection('Notifications')
        .doc(Get.find<UserController>().employee!.email)
        .collection('Notifications')
        .where('seen', isEqualTo: false)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'seen': true});
    }
  }
}
