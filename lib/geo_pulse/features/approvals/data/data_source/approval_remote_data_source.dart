import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tracking_module/tracking_module/core/constants/collection_constants.dart';

import '../../../request/data/models/request_model.dart';

class ApprovalRemoteDataSource {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> updateApprovals(RequestModel newModel) async {
    await db
        .collection(CollectionConstants.requests)
        .doc(newModel.requestedUserId)
        .collection(CollectionConstants.requests)
        .doc(newModel.id)
        .set(newModel.toMap(), SetOptions(merge: true));
  }
}
