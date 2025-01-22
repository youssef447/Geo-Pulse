// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import '../../../core/constants/enums.dart';

import '../models/department_model.dart';

// name:AddDepartmentController
// date:Jan/10/2024
// by:MohamedFouad
// lastUpdate:nov/11/2024

class AddDepartmentController extends GetxController with StateMixin {
  // FirebaseFirestore instance for interacting with Firestore.
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<DepartmentModel> departmentModels = [];

  Future<List<DepartmentModel>> getAllDepartments() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Departments').get();

      List<DepartmentModel> departments = querySnapshot.docs.map((doc) {
        return DepartmentModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      departmentModels = departments;

      print('departments.length ${departments.length}');
      return departments;
    } catch (e) {
      return Future.error([]);
    }
  }

  /// Returns the department name based on the given departmentId and the current locale.
  /// If the current locale is 'en', it returns the departmentName, otherwise it returns the departmentNameInArabic.
  String getDepartmentName(String departmentId, bool? isEnglish) {
    List<DepartmentModel> departmentModel = departmentModels
        .where((element) => element.departmentID == departmentId)
        .toList();

    if (departmentModel.isEmpty) {
      return "none";
    } else {
      return isEnglish == null
          ? Get.locale.toString().contains('en')
              ? containAbbreviation(departmentModel.first.departmentName!)
              : departmentModel.first.departmentNameInArabic!
          : isEnglish
              ? containAbbreviation(departmentModel.first.departmentName!)
              : departmentModel.first.departmentNameInArabic!;
    }
  }

  String getDepartmentId(String departmentName) {
    List<DepartmentModel> departmentModel = departmentModels
        .where((element) =>
            element.departmentName == departmentName ||
            element.departmentNameInArabic == departmentName)
        .toList();

    if (departmentModel.isEmpty) {
      return "none";
    } else {
      return departmentModel.first.departmentID!;
    }
  }

  List<String> abbreviation = [
    "it",
    "hr",
    'ui ux',
    'log',
    'qa',
    'pr',
    'dev',
    'ceo'
  ];
  String containAbbreviation(String abbreviation) {
    if (this.abbreviation.contains(abbreviation)) {
      return abbreviation.toUpperCase();
    }
    return capitalize(abbreviation);
  }
}
