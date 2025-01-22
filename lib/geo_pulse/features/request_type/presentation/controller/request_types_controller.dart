import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/helpers/get_dialog_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dialog/default_dialog.dart';
import '../../../users/logic/add_employee_controller.dart';
import '../../../location/presentation/controller/controller/location_controller.dart';
import '../../constants/table_columns.dart';
import '../../data/models/request_type_model.dart';
import '../../domain/request_type_repo.dart';

/// Date: 2/10/2024
/// By: Nada Mohammed , Youssef Ashraf
///This file is responsible for handling the requests logic
class RequestTypeController extends GetxController {
  final RequestTypeRepo requestTypeRepo;

  RequestTypeController({required this.requestTypeRepo});
  TextEditingController requestTypeEnglishNameController =
      TextEditingController();
  TextEditingController requestTypeArabicNameController =
      TextEditingController();
  TextEditingController requestTypeEnglishDescriptionController =
      TextEditingController();
  TextEditingController requestTypeArabicDescriptionController =
      TextEditingController();

  String? requestTypeEnglishName;
  RequiredOptionalStatus? hrApprovalStatus;
  RequiredOptionalStatus? addingDescriptionStatus;
  RequiredOptionalStatus? addingAttachmentStatus;

  Map<String, bool> availabilityLocations = {AppConstanst.all: false};

  /// This method is used to set the availability locations map from the location controller.
  ///
  /// It loops through the location models in the location controller and sets the
  /// availability locations map to false.
  void setLocationAvalibalityFromLocationController() {
    // Reset the availability locations map to false
    availabilityLocations = {AppConstanst.all: false};
    // Loop through the location models in the location controller
    Get.find<LocationController>().locationModels.forEach((element) {
      // Set the availability locations map to false
      availabilityLocations[element.id] = false;
    });
  }

  /// This method takes a location id and returns the location name based on the current locale.
  ///
  /// If the id is 'all', it returns 'All' in the current locale.
  /// If the id is 'Location' or ' ', it returns 'Location' in the current locale.
  /// If the id is not 'all' and not 'Location' or ' ', it loops through the location models in the location controller
  /// and returns the location name in the current locale if the id matches the id of one of the location models.
  /// If the id does not match any of the location models, it returns null.
  String? getLocationName(String id) {
    String? locationName;
    if (id == AppConstanst.all) {
      locationName = AppConstanst.all.capitalize!.tr;
    } else if (id == 'Location' || id == 'الموقع') {
      locationName = "Location".tr;
    } else if (Get.find<LocationController>().locationModels.isNotEmpty) {
      locationName = Get.locale.toString().contains('en')
          ? Get.find<LocationController>()
              .locationModels
              .firstWhere((element) => element.id == id)
              .locationNameEnglish
              .capitalize!
          : Get.find<LocationController>()
              .locationModels
              .firstWhere((element) => element.id == id)
              .locationNameArabic;
    } else {
      locationName = null;
    }
    return locationName;
  }

  RequestTypeModel? selectedRequestType;

  GlobalKey<FormState> newReqTypeFormKey = GlobalKey<FormState>();

  RxBool isValid = false.obs;

  List<RequestTypeModel> requestTypeModels = [];
  List<RequestTypeModel> requestTypeModelsWithoutFilter = [];
  List<String> tableColumns = RequestTypeColumnsConstants.requestTypeHeaders;
  //Firesbase instance
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override

  /// Called when the widget is initialized.
  ///
  /// It calls the `getRequestTypes` method to get the request types
  /// and the `setLocationAvalibalityFromLocationController` method
  /// to set the availability locations map from the location controller.
  @override
  void onInit() {
    super.onInit();
    // Get the request types
    getRequestTypes();
    // Set the availability locations map from the location controller
    setLocationAvalibalityFromLocationController();
  }

  /// Loads the selected request type data into the respective controllers and variables.
  ///
  /// This method populates the text controllers with the selected request type's
  /// English and Arabic names and descriptions. It also sets the HR approval status,
  /// description addition status, and attachment addition status. Furthermore, it updates
  /// the availability locations map based on the selected request type's availability.
  void loadSelectedData() {
    // Set the text controllers with the selected request type's name and description
    requestTypeEnglishNameController.text = selectedRequestType!.englishName;
    requestTypeArabicNameController.text = selectedRequestType!.arabicName;
    requestTypeEnglishDescriptionController.text =
        selectedRequestType!.englishDescription;
    requestTypeArabicDescriptionController.text =
        selectedRequestType!.arabicDescription;

    // Set the approval and attachment statuses
    hrApprovalStatus = selectedRequestType!.hrApproval;
    addingDescriptionStatus = selectedRequestType!.addingDescription;
    addingAttachmentStatus = selectedRequestType!.addingAttachments;

    // Update availability locations based on the selected request type's availability
    selectedRequestType!.availability.forEach((element) {
      availabilityLocations[element] = true;
    });
  }

  //search request type
  /// Searches the request types based on the given query.
  ///
  /// This method filters the `requestTypeModelsWithoutFilter` list based on the
  /// given query. It uses the English and Arabic names of the request types to
  /// filter. The filtered list is then stored in the `requestTypeModels` variable.
  /// Finally, the UI components associated with the request types list are updated
  /// to reflect the filtered records.
  void searchRequestType(String query) {
    /// Filter the request types based on the given query
    requestTypeModels = requestTypeModelsWithoutFilter
        .where((element) =>
            element.englishName.toLowerCase().contains(query.toLowerCase()) ||
            element.arabicName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    /// Update the UI
    update([AppConstanst.requestTypeUpdate]);
    update();
  }

  /// Sets the selected request type to the given request type model.
  ///
  /// This method updates the text controllers and approval and attachment statuses
  /// based on the selected request type's data. It also updates the UI components
  /// associated with the request type.
  /// Sets the selected request type to the given request type model.
  ///
  /// This method loads the selected request type's data into the text controllers
  /// and updates the approval and attachment statuses. It also updates the UI
  /// components associated with the request type.
  ///
  /// [requestType] is the selected request type model.
  void setSelectedRequestType(RequestTypeModel requestType) {
    selectedRequestType = requestType;
    loadSelectedData();
    update([AppConstanst.requestTypeColumn]);
  }

  /// Sets the HR approval status to the given status.
  ///
  /// This method updates the HR approval status and checks the form's validity.
  /// It also updates the UI components associated with the request type column.
  ///
  /// [status] is the new HR approval status to be set.
  void setHrApprovalStatus(RequiredOptionalStatus status) {
    // Update the HR approval status
    hrApprovalStatus = status;

    // Check if the form is valid
    setIsValid();

    // Update the UI
    update([AppConstanst.requestTypeColumn]);
  }

  /// Sets the adding description status to the given status.
  ///
  /// This method updates the adding description status and checks the form's validity.
  /// It also updates the UI components associated with the request type column.
  ///
  /// [status] is the new adding description status to be set.
  void setAddingDescriptionStatus(RequiredOptionalStatus status) {
    // Update the adding description status
    addingDescriptionStatus = status;

    // Check if the form is valid
    setIsValid();

    // Update the UI
    update([AppConstanst.requestTypeColumn]);
  }

  /// Sets the adding attachment status to the given status.
  ///
  /// This method updates the adding attachment status and checks the form's validity.
  /// It also updates the UI components associated with the request type column.
  ///
  /// [status] is the new adding attachment status to be set.
  void setAddingAttachmentStatus(RequiredOptionalStatus status) {
    // Update the adding attachment status
    addingAttachmentStatus = status;

    // Check if the form is valid
    setIsValid();

    // Update the UI
    update([AppConstanst.requestTypeColumn]);
  }

  /// Toggles the availability of a location.
  ///
  /// If the location is "all", then all other locations are toggled as well.
  /// If the location is not "all", then the "all" location is toggled based on the
  /// the state of all other locations.
  ///
  /// [locationId] is the id of the location to toggle.
  void toggleAvailability(String locationId) {
    availabilityLocations[locationId] = !availabilityLocations[locationId]!;
    if (locationId == AppConstanst.all) {
      for (var key in availabilityLocations.keys) {
        if (key != AppConstanst.all) {
          availabilityLocations[key] = availabilityLocations[locationId]!;
        }
      }
    } else {
      // uncheck all if there is one is unchecked
      if (!availabilityLocations[locationId]!) {
        availabilityLocations[AppConstanst.all] = false;
      }
      // check all if all are checked
      bool allTrue = true;
      for (var key in availabilityLocations.keys) {
        if (key != AppConstanst.all) {
          if (availabilityLocations[key] == true) {
            allTrue = true;
          } else {
            allTrue = false;
            break;
          }
        }
      }
      availabilityLocations[AppConstanst.all] = allTrue;
    }

    setIsValid();
    update([AppConstanst.checkbox]);
  }

  /// Removes a location from the availability map by setting its value to false.
  ///
  /// This method updates the UI components associated with the request type column.
  ///
  /// [location] is the id of the location to remove.
  void removeLocation(String location) {
    // Set the location's availability to false
    availabilityLocations[location] = false;

    // Update the UI
    update([AppConstanst.requestTypeColumn]);
  }

  /// Returns a list of strings that contains the english names of all the request types.
  ///
  /// This method is used to fill the dropdown list of request types in the request details page.
  List<String> getRequestTypesAsStrings() {
    return requestTypeModels.map((e) => e.englishName).toList();
  }

  /// Deletes a request type from the database and the list of request types.
  ///
  /// [index] is the index of the request type to delete in the list of request types.
  ///
  /// This method updates the UI components associated with the request type column.
  void deleteReqType(int index) async {
    // Get the request type model to delete
    RequestTypeModel requestTypeModel = requestTypeModels[index];

    // Set the request type status to 'deleted'
    requestTypeModel.requestTypeStatus = AppConstanst.deleted;

    // Update the request type in the database
    requestTypeRepo.deleteReqType(requestTypeModel).then((value) {
      // Remove the request type from the list of request types
      requestTypeModels.removeAt(index);

      // Update the UI
      update([AppConstanst.requestTypeUpdate]);

      // Close the dialog
      Get.back();
    });
  }

  /// Resets all the data used in the add or edit request type dialog to their initial state.
  ///
  /// This method is called when the add or edit request type dialog is closed or when the user clicks on the cancel button.
  /// It resets all the text editing controllers, the list of documents, and the availability map to their initial state.

  void resetAllData() {
    requestTypeEnglishNameController.clear();
    requestTypeArabicNameController.clear();
    requestTypeEnglishDescriptionController.clear();
    requestTypeArabicDescriptionController.clear();
    requestTypeEnglishName = null;
    hrApprovalStatus = null;
    addingDescriptionStatus = null;
    addingAttachmentStatus = null;
    availabilityLocations = {
      AppConstanst.all: false,
    };
    setLocationAvalibalityFromLocationController();
    isValid.value = false;
    update([AppConstanst.requestTypeColumn]);
  }

  checkAllChosen() {
    return hrApprovalStatus != null &&
        addingDescriptionStatus != null &&
        addingAttachmentStatus != null;
  }

  /// Saves the current request type to the database.
  ///
  /// If the selected request type is null, this method adds a new request type to the database.
  /// Otherwise, it updates the selected request type in the database.
  void saveRequestType() {
    if (selectedRequestType == null) {
      addNewRequestType(); // Add a new request type
    } else {
      updateRequestType(); // Update the selected request type
    }
  }

  /// Resets the selected request type to null and updates the UI.
  ///
  /// This method is called when the user clicks on the cancel button in the add or edit request type dialog.
  /// It resets the selected request type to null and updates the UI components associated with the request type.
  void resetselectedRequestType() {
    selectedRequestType = null;
    update();
  }

  /// Sets the value of the `isValid` observable to whether the form is valid and all required fields are chosen.
  ///
  /// This method is called whenever the user interacts with the form, such as when they type in a text field or check a checkbox.
  /// It updates the `isValid` observable to reflect the current state of the form.
  void setIsValid() {
    // Validate the form and check if all required fields are chosen
    isValid.value =
        newReqTypeFormKey.currentState!.validate() && checkAllChosen();
  }

  /// Updates the selected request type in the database.
  ///
  /// This method is called when the user clicks on the save button in the add or edit request type dialog.
  /// It updates the selected request type in the database by creating a new document if the request type does not exist,
  /// or by updating the existing document if it does.
  /// It also updates the UI components associated with the request type.
  Future<void> updateRequestType() async {
    List<String> selectedAvailability = availabilityLocations.keys
        .where((element) => availabilityLocations[element] == true)
        .toList();

    if (newReqTypeFormKey.currentState!.validate() && checkAllChosen()) {
      final updatedRequestType = RequestTypeModel(
        id: selectedRequestType!.id,
        englishName: requestTypeEnglishNameController.text,
        arabicName: requestTypeArabicNameController.text,
        englishDescription: requestTypeEnglishDescriptionController.text,
        arabicDescription: requestTypeArabicDescriptionController.text,
        hrApproval: hrApprovalStatus!,
        addingDescription: addingDescriptionStatus!,
        addingAttachments: addingAttachmentStatus!,
        availability: selectedAvailability.contains(AppConstanst.all)
            ? [AppConstanst.all]
            : selectedAvailability,
        requestStatus: RequestStatus.pending,
        requestTypeCreater: selectedRequestType!.requestTypeCreater,
        requestTypeStatus: selectedRequestType!.requestTypeStatus!,
      );

      final index = requestTypeModels
          .indexWhere((element) => element.id == selectedRequestType!.id);

      requestTypeModels[index] = updatedRequestType;
      requestTypeRepo.updateRequestType(updatedRequestType).then((value) {
        // update table
        update([AppConstanst.requestTypeUpdate]);

        resetAllData();
        Get.back();
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Please fill all fields and choose the required options.'.tr,
        backgroundColor: AppColors.primary,
        textColor: AppColors.textButton,
      );
    }
  }

  /// Adds a new request type to the database.
  ///
  /// This method is called when the user clicks on the save button in the add request type dialog.
  /// It adds a new request type to the database by creating a new document.
  /// It also updates the UI components associated with the request type.
  Future<void> addNewRequestType() async {
    List<String> selectedAvailability = availabilityLocations.keys
        .where((element) => availabilityLocations[element] == true)
        .toList();

    if (newReqTypeFormKey.currentState!.validate() && checkAllChosen()) {
      final newRequestType = RequestTypeModel(
        id: DateTime.now().toString(),
        requestTypeCreater: Get.find<UserController>().employee?.email ?? '',
        englishName: requestTypeEnglishNameController.text,
        arabicName: requestTypeArabicNameController.text,
        englishDescription: requestTypeEnglishDescriptionController.text,
        arabicDescription: requestTypeArabicDescriptionController.text,
        hrApproval: hrApprovalStatus!,
        addingDescription: addingDescriptionStatus!,
        addingAttachments: addingAttachmentStatus!,
        availability: selectedAvailability.contains(AppConstanst.all)
            ? [AppConstanst.all]
            : selectedAvailability,
        requestStatus: RequestStatus.pending,
        requestTypeStatus: AppConstanst.active,
      );
      // add to firebase
      requestTypeRepo.addNewRequestType(newRequestType).then(
        (value) {
          requestTypeModels.add(newRequestType);

          // update table
          update([AppConstanst.requestTypeUpdate]);

          resetAllData();

          Get.back();

          // show success dialog
          GetDialogHelper.generalDialog(
            barrierDismissible: false,
            context: Get.context!,
            child: DefaultDialog(
              width: 343.w,
              lottieAsset: AppAssets.successful,
              title: 'Successful'.tr,
              subTitle: 'You Successfully Added a Request Type!'.tr,
            ),
          );
        },
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Please fill all fields and choose the required options.'.tr,
        backgroundColor: AppColors.primary,
        textColor: AppColors.textButton,
      );
    }
  }

  bool isGettingRequestTypes = false;
  // GET DATA FROM FIREBASE

  /// Gets all active request types from the database.
  ///
  /// This function is used to populate the `requestTypeModels` list with the
  /// active request types in the database. The list is then used to populate
  /// the request type table.
  ///
  /// The `requestTypeModelsWithoutFilter` list is also populated with the same
  /// data. This list is used to store the request types without any filter.
  ///
  /// After getting the data, the table is updated using the `update` function.
  Future<void> getRequestTypes() async {
    isGettingRequestTypes = true;
    // Get all active request types from the database

    final response = await requestTypeRepo.getRequestTypes();
    response.fold((failure) {
      isGettingRequestTypes = false;
    }, (requests) {
      isGettingRequestTypes = false;

      requestTypeModels = [];
      requestTypeModelsWithoutFilter = [];

      // Populate the lists with the data
      requestTypeModels = requests;

      requestTypeModelsWithoutFilter = requestTypeModels;
    });

    // Update the table
    update([AppConstanst.requestTypeUpdate]);
  }

  RequestTypeModel getRequestTypeId(String id) {
    return requestTypeModels.firstWhere((element) => element.id == id);
  }
}
