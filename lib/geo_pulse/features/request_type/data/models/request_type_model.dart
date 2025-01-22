import '../../../../core/constants/enums.dart';
import '../../../../core/constants/strings.dart';

class RequestTypeModel {
  String id;
  String englishName;
  String arabicName;
  String englishDescription;
  String arabicDescription;
  RequiredOptionalStatus hrApproval;
  RequiredOptionalStatus addingDescription;
  RequiredOptionalStatus addingAttachments;
  List<String> availability;
  RequestStatus requestStatus;

  String? requestTypeCreater;
  String? requestTypeStatus;

  RequestTypeModel({
    required this.id,
    required this.englishName,
    required this.arabicName,
    required this.englishDescription,
    required this.arabicDescription,
    required this.hrApproval,
    required this.addingDescription,
    required this.addingAttachments,
    required this.availability,
    required this.requestStatus,
    this.requestTypeCreater,
    this.requestTypeStatus,
  });

  // Static constants for field keys
  static const String collectionName = 'Request_Types';
  static const String fieldId = 'Id';
  static const String fieldEnglishName = 'English_Name';
  static const String fieldArabicName = 'Arabic_Name';
  static const String fieldEnglishDescription = 'English_Description';
  static const String fieldArabicDescription = 'Arabic_Description';
  static const String fieldHrApproval = 'HR_Approval';
  static const String fieldAddingDescription = 'Adding_Description';
  static const String fieldAddingAttachments = 'Adding_Attachments';
  static const String fieldAvailability = 'Availability';
  static const String fieldRequestTypeCreater = 'Request_Type_Creater';
  static const String fieldRequestTypeStatus = 'Request_Type_Status';

  // To JSON
  Map<String, dynamic> toJson() => {
        fieldId: id,
        fieldEnglishName: englishName.toLowerCase(),
        fieldArabicName: arabicName.toLowerCase(),
        fieldEnglishDescription: englishDescription.toLowerCase(),
        fieldArabicDescription: arabicDescription.toLowerCase(),
        fieldHrApproval: hrApproval.getName,
        fieldAddingDescription: addingDescription.getName.toLowerCase(),
        fieldAddingAttachments: addingAttachments.getName.toLowerCase(),
        fieldAvailability: availability,
        fieldRequestTypeCreater: requestTypeCreater,
        fieldRequestTypeStatus: requestTypeStatus,
      };

  // From JSON
  factory RequestTypeModel.fromJson(Map<String, dynamic> json) {
    return RequestTypeModel(
      id: json[fieldId],
      englishName: json[fieldEnglishName],
      arabicName: json[fieldArabicName],
      englishDescription: json[fieldEnglishDescription],
      arabicDescription: json[fieldArabicDescription],
      hrApproval: json[fieldHrApproval] == AppConstanst.required
          ? RequiredOptionalStatus.required
          : RequiredOptionalStatus.optional,
      addingDescription: json[fieldAddingDescription] == AppConstanst.required
          ? RequiredOptionalStatus.required
          : RequiredOptionalStatus.optional,
      addingAttachments: json[fieldAddingAttachments] == AppConstanst.required
          ? RequiredOptionalStatus.required
          : RequiredOptionalStatus.optional,
      availability: List<String>.from(json[fieldAvailability]),
      requestTypeCreater: json[fieldRequestTypeCreater],
      requestStatus: RequestStatus.pending,
      requestTypeStatus: json[fieldRequestTypeStatus],
    );
  }
  factory RequestTypeModel.transaction() {
    return RequestTypeModel(
      id: DateTime.now().toString(),
      englishName: 'Transaction',
      arabicName: 'معاملة',
      englishDescription: '',
      arabicDescription: '',
      hrApproval: RequiredOptionalStatus.required,
      addingDescription: RequiredOptionalStatus.optional,
      addingAttachments: RequiredOptionalStatus.optional,
      availability: [],
      requestTypeCreater: '',
      requestStatus: RequestStatus.pending,
    );
  }
}
