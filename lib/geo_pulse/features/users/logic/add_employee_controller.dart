// ignore_for_file: avoid_print, sdk_version_since

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:geo_pulse/geo_pulse/features/users/models/user_model.dart';

class UserController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<UserModel>? allnNewEmployees;

  List<UserModel>? employeesNewWithoutFilter;
  UserModel? employee;

  Future<List<UserModel>?> getAllEmployees() async {
    final CollectionReference employeeCollection = db.collection('/users');

    try {
      QuerySnapshot querySnapshot = await employeeCollection.get();

      allnNewEmployees = querySnapshot.docs
          .map((DocumentSnapshot document) =>
              UserModel.fromMap(document.data() as Map<String, dynamic>))
          .toList();
      employeesNewWithoutFilter = querySnapshot.docs
          .map((DocumentSnapshot document) =>
              UserModel.fromMap(document.data() as Map<String, dynamic>))
          .toList();
      return employeesNewWithoutFilter;
    } catch (e) {
      // Handle errors here.
      print("Error getting employees: $e");
      return Future.error([]);
    }
  }

  String getEmployeeNameFirstOrLast(String email, bool isFirst) {
    UserModel employee = employeesNewWithoutFilter!
        .firstWhere((element) => email == element.email);
    return Get.locale.toString().contains('en')
        ? isFirst
            ? employee.firstName
            : employee.lastName
        : isFirst
            ? employee.firstNameInArabic
            : employee.lastNameInArabic;
  }

  String getEmployeeName([String? email]) {
    if (email == null) {
      return Get.locale.toString().contains('en')
          ? "${this.employee!.firstName} ${this.employee!.lastName}"
          : "${this.employee!.firstNameInArabic} ${this.employee!.lastNameInArabic}";
    }
    UserModel employee = employeesNewWithoutFilter!
        .firstWhere((element) => email == element.email);
    return Get.locale.toString().contains('en')
        ? "${employee.firstName} ${employee.lastName}"
        : "${employee.firstNameInArabic} ${employee.lastNameInArabic}";
  }

  String getEmployeeNameEnglishArabic(bool isEnglish) {
    UserModel employee = employeesNewWithoutFilter!
        .firstWhere((element) => this.employee!.email == element.email);
    return isEnglish
        ? "${employee.firstName} ${employee.lastName}"
        : "${employee.firstNameInArabic} ${employee.lastNameInArabic}";
  }

  /* // get All super Admin from employees list
  List<UserModel> getSuperAdmin() {
    return employeesNewWithoutFilter!
        .where((element) => element.role!.role!.last! == 'super admin')
        .toList();
  } */

  String getEmployeeJobTitle([String? email]) {
    if (email == null) {
      return Get.locale.toString().contains('en')
          ? this.employee!.jobTitle
          : this.employee!.jobTitleInArabic;
    }
    UserModel employee = employeesNewWithoutFilter!
        .firstWhere((element) => email == element.email);
    return Get.locale.toString().contains('en')
        ? employee.jobTitle
        : employee.jobTitleInArabic;
  }

  String getEmployeePhoto([String? email]) {
    if (email == null) {
      return this.employee!.profileURL == null
          ? this.employee!.gender == 'female'
              ? "assets/images/female_avatar.png"
              : "assets/images/male_avatar.png"
          : this.employee!.profileURL!;
    }
    UserModel employee = employeesNewWithoutFilter!
        .firstWhere((element) => email == element.email);
    return employee.profileURL == null
        ? employee.gender == 'female'
            ? "assets/images/female_avatar.png"
            : "assets/images/male_avatar.png"
        : employee.profileURL!;
  }

  UserModel getLocaleEmployee(
    String email,
  ) {
    UserModel employee = employeesNewWithoutFilter!
        .firstWhere((element) => email == element.email);
    return employee;
  }

  Future<UserModel?> getNewEmployee(String id) async {
    try {
      final CollectionReference employeeCollection = db.collection('/users');

      DocumentSnapshot employeeSnapshot =
          await employeeCollection.doc(id).get();

      if (employeeSnapshot.exists) {
        // If the document exists, convert it to a UserModel
        employee =
            UserModel.fromMap(employeeSnapshot.data() as Map<String, dynamic>);

        update();
        return employee!;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching Employee: $e");
      return null;
    }
  }
}
