// location details controller for a specific location model

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/strings.dart';
import '../../../../../core/helpers/share_helper.dart';
import '../../ui/constants/location_details_tabs.dart';
import 'location_controller.dart';

class LocationDetailsController extends GetxController
    with GetTickerProviderStateMixin {
  late final TabController tabController;

  List<String> individualsTableColumns = [
    'Photo',
    'First Name',
    'Last Name',
    'Job Title',
    'Supervisor',
    '',
  ];

  @override
  void onInit() {
    print("************************************");
    super.onInit();
    tabController = TabController(
      length: LocationDetailsTabs.locationDetailsTAb.length,
      vsync: this,
    )..addListener(
        () {
          update([AppConstanst.locationDetails]);
        },
      );
  }

  final searchController = TextEditingController();

  Future<void> exportTable(int index) async {
    final headers =
        individualsTableColumns.where((element) => element != ''.tr).toList();

    final data = Get.find<LocationController>()
        .locationModels[index]
        .employees
        .map((model) {
      return [
        model.profileURL!,
        model.firstName,
        model.lastName,
        'Marketing Manager',
        model.supervisor,
      ];
    }).toList();
    List<Uint8List> images = [];

    final ByteData byteData = await rootBundle.load(AppAssets.userProfile);

    images = List.generate(
      Get.find<LocationController>().locationModels[index].employees.length,
      (index) {
        return byteData.buffer.asUint8List();
      },
    );
    await ShareHelper.printDoc(
      data,
      headers,
      images,
    );
  }
}
