import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/strings.dart';
import '../models/location_model.dart';

class LocationRemoteDataSource {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addLocation(LocationModel newLocationModel) async {
    await db
        .collection(AppConstanst.companyLocations)
        .doc(newLocationModel.id)
        .set(
          newLocationModel.toMap(),
        );
  }

  Future<void> editLocation(LocationModel locationModel) async {
    await db
        .collection(AppConstanst.companyLocations)
        .doc(locationModel.id)
        .set(
          locationModel.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<List<LocationModel>> getAllLocations() async {
    List<LocationModel> dataList = [];
    await db
        .collection(AppConstanst.companyLocations)
        .where(LocationModel.fieldStatus, isEqualTo: AppConstanst.active)
        .get()
        .then((value) {
      dataList = value.docs.map((doc) {
        return LocationModel.fromMap(doc.data());
      }).toList();
    });
    print('dataList.length ${dataList.length}');
    return dataList;
  }
}
