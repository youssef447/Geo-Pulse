import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:geo_pulse/geo_pulse/core/constants/collection_constants.dart';

import '../../../../core/constants/strings.dart';
import '../models/attendance_data_model.dart';

class AttendenceRemoteDataSource {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> uploadrequestDoc(String fileName, File file) async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child("${AppConstanst.attendanceDocs}/$fileName");
    final metadata = SettableMetadata(contentType: AppConstanst.applicationPdf);

    final uploadTask = await storageRef.putFile(file, metadata);

    final url = await uploadTask.ref.getDownloadURL();
    return url;
  }

  Future<void> addAttendance(
      AttendanceDataModel model, String employeeEmail) async {
    final String formattedDate = DateFormat('MMM dd, yyyy').format(model.date);
    await db
        .collection(CollectionConstants.attendances)
        .doc(employeeEmail)
        .collection(AppConstanst.employeeAttendances)
        .doc(formattedDate)
        .set(model.toMap());
  }

  Future<List<AttendanceDataModel>> getAttendanceData(
      String employeeEmail) async {
    final QuerySnapshot snapshot = await db
        .collection(CollectionConstants.attendances)
        .doc(employeeEmail)
        .collection(AppConstanst.employeeAttendances)
        .orderBy(AttendanceDataModel.fieldDate, descending: false)
        .get();

    return snapshot.docs.map((doc) {
      return AttendanceDataModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getAllAttendanceData() async {
    List<Map<String, dynamic>> result = [];
    final users = await db.collection(CollectionConstants.users).get();

    for (var doc in users.docs) {
      final email = doc.data()['email'];
      final DocumentSnapshot snapshot =
          await db.collection(CollectionConstants.attendances).doc(email).get();

      final docsRef = await snapshot.reference
          .collection(AppConstanst.employeeAttendances)
          .get();
      for (var dateDoc in docsRef.docs) {
        result.add(dateDoc.data());
      }
    }

    return result;
  }

  Future<List<DateTime>> getOfficialHolidays() async {
    DocumentSnapshot officialHolidaysSnapshot = await db
        .collection(CollectionConstants.officialHolidays)
        .doc('Holidays')
        .get();
    if (!officialHolidaysSnapshot.exists) {
      return [];
    }
    List<dynamic> holidays = officialHolidaysSnapshot['Days'];

    return holidays
        .map((timestamp) => (timestamp as Timestamp).toDate())
        .toList();
  }
}
