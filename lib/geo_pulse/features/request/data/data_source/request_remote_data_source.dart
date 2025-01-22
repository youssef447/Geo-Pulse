import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tracking_module/tracking_module/core/constants/collection_constants.dart';
import 'package:tracking_module/tracking_module/core/constants/strings.dart';
import 'package:tracking_module/tracking_module/features/users/logic/add_employee_controller.dart';

import '../models/request_model.dart';

class RequestRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendReminder(
      RequestModel requestModel, String supervisor) async {
    await _firestore
        .collection(CollectionConstants.requests)
        .doc(supervisor)
        .collection(CollectionConstants.requests)
        .doc(requestModel.id)
        .set(requestModel.toMap(), SetOptions(merge: true));
  }

  Future<void> sendRequest(
      {required RequestModel requestModel,
      required String requestId,
      required String userId}) async {
    await _firestore
        .collection(CollectionConstants.requests)
        .doc(userId)
        .collection(CollectionConstants.requests)
        .doc(requestId)
        .set(requestModel.toMap());
  }

  Future<List<RequestModel>> getRequiredRequests() async {
    final List<RequestModel> res = [];
    final users = await _firestore.collection(CollectionConstants.users).get();
    for (var doc in users.docs) {
      final email = doc.data()['email'];
      final QuerySnapshot snapshot = await _firestore
          .collection(CollectionConstants.requests)
          .doc(email)
          .collection(CollectionConstants.requests)
          .where('HR_Approval', isEqualTo: 'required')
          .get();

      for (var doc2 in snapshot.docs) {
        res.add(RequestModel.fromMap(doc2.data() as Map<String, dynamic>));
      }
    }

    return res;
  }

  Future<List<RequestModel>> getAllRequests([String? dep]) async {
    final List<RequestModel> res = [];
    var respons =
        await _firestore.collection(CollectionConstants.requests).get();
    //for each mail
    for (var doc in respons.docs) {
      final response =
          await doc.reference.collection(AppConstanst.requests).get();
      for (var doc2 in response.docs) {
        if (Get.find<UserController>()
                .getLocaleEmployee(
                    doc2.data()[RequestModel.fieldRequestedUserId])
                .departmentid ==
            dep) {
          res.add(RequestModel.fromMap(doc2.data()));
        }
      }
    }

    return res;
  }

  Future<List<QueryDocumentSnapshot>> getRequests(String email) async {
    var respons = await _firestore
        .collection(CollectionConstants.requests)
        .doc(email)
        .collection(CollectionConstants.requests)
        .get();

    return respons.docs;
  }
}
