import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/strings.dart';
import '../models/request_type_model.dart';

class RequestTypeRemoteDataSource {
  /// Deletes a request type from the database and the list of request types.

  Future<void> deleteReqType(RequestTypeModel requestTypeModel) async {
    /// Set the request type status to 'deleted'.

    /// Update the request type in the database.
    await FirebaseFirestore.instance
        .collection(AppConstanst.requestType)
        .doc(requestTypeModel.id)
        .set(requestTypeModel.toJson(), SetOptions(merge: true));
  }

  Future<void> updateRequestType(RequestTypeModel requestTypeModel) async {
    await FirebaseFirestore.instance
        .collection(AppConstanst.requestType)
        .doc(requestTypeModel.id)
        .set(requestTypeModel.toJson(), SetOptions(merge: true));
  }

  /// Adds a new request type to the database.

  Future<void> addNewRequestType(
      RequestTypeModel requestTypeModel, String date) async {
    // Add the request type to the Firestore collection with the given date as the document ID
    await FirebaseFirestore.instance
        .collection(AppConstanst.requestType)
        .doc(date)
        .set(requestTypeModel.toJson());
  }

  /// Retrieves a list of active request types from the Firestore database.

  Future<List<QueryDocumentSnapshot>> getRequestTypes() async {
    // Query Firestore for documents in the 'Request_Type' collection
    // where 'Request_Type_Status' is 'active'
    var respons = await FirebaseFirestore.instance
        .collection(AppConstanst.requestType)
        .where(RequestTypeModel.fieldRequestTypeStatus,
            isEqualTo: AppConstanst.active)
        .get();
    return respons.docs;
  }
}
