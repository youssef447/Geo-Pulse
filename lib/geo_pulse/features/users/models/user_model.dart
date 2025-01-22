import 'package:geo_pulse/geo_pulse/core/constants/enums.dart';

class UserModel {
  String? id;
  String firstName;
  String middleName;
  String lastName;
  String firstNameInArabic;
  String middleNameInArabic;
  String lastNameInArabic;
  String? profileURL;
  String email;

  String supervisor;
  UserPosition position;
  String departmentid;
  String gender;
  String jobTitle;
  String jobTitleInArabic;
  String phoneNumber;

  // should be set to default value here, or get the value from the server backend
  DateTime expectedCheckInTime = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    9, // 9:00 AM
    0,
  );

  UserModel({
    this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.firstNameInArabic,
    required this.middleNameInArabic,
    required this.lastNameInArabic,
    required this.gender,
    this.profileURL,
    required this.email,
    required this.departmentid,
    this.supervisor = 'Mohammed Ahmed',
    required this.position,
    required this.jobTitle,
    required this.jobTitleInArabic,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'profileURL': profileURL,
      'email': email,
      'supervisor': supervisor,
      'position': position.name,
      'jobTitle': jobTitle,
      'phoneNumber': phoneNumber,
      'jobTitleInArabic': jobTitleInArabic,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      firstName: map['firstName'] as String,
      middleName: map['middleName'] as String,
      lastName: map['lastName'] as String,
      firstNameInArabic: map['firstNameInArabic'] as String,
      middleNameInArabic: map['middleNameInArabic'] as String,
      lastNameInArabic: map['lastNameInArabic'] as String,
      departmentid: map['departmentid'] as String,
      profileURL: map['profileURL'] as String?,
      email: map['email'] as String,
      gender: map['gender'] as String,
      supervisor: map['supervisor'] as String,
      position: UserPosition.positionFromMap(map['position']),
      jobTitle: map['jobTitle'] as String,
      jobTitleInArabic: map['jobTitleInArabic'] as String,
      phoneNumber: map['phoneNumber'] as String,
    );
  }
}
