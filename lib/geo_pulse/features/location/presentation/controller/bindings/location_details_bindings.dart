import 'package:get/get.dart';

import '../controller/location_details_controller.dart';

class LocationDetailsBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LocationDetailsController(), fenix: true);
  }
}
