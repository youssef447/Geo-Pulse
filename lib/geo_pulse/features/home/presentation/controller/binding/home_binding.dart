// Objectives: This file is responsible for providing a binding class that is used to bind the home controller to the home view.

import 'package:get/get.dart';

import '../../../../users/logic/add_employee_controller.dart';

import '../controller/tracking_home_controller.dart';

class HomeBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(UserController());
    //Get.put(AddDepartmentController());
    Get.lazyPut(() => TrackingHomeController());
  }
}
