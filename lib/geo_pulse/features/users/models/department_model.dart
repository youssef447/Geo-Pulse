import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentModel {
  String? departmentID;
  String? departmentName;
  String? departmentNameInArabic;
  Timestamp? creationDate;
  String? addedBy;

  DepartmentModel({
    this.departmentID,
    this.departmentName,
    this.departmentNameInArabic,
    this.creationDate,
    this.addedBy,
  });

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      departmentID: map['Department_ID'] as String? ?? '',
      departmentName: map['Department_Name'] as String? ?? '',
      departmentNameInArabic: map['Department_Name_In_Arabic'] as String? ?? '',
      creationDate: map['Creation_Date'] as Timestamp? ?? Timestamp.now(),
      addedBy: map['Added_By'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Department_ID': departmentID,
      'Department_Name': departmentName,
      'Department_Name_In_Arabic': departmentNameInArabic,
      'Creation_Date': creationDate,
      'Added_By': addedBy,
    };
  }
}
