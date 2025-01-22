// Objectives: This file is responsible for providing the model of status item used in the status row in the home screen.

import 'package:flutter/material.dart';

class StatusItemModel {
  String statusText;
  int statusItemCount;
  Color statusTextColor;
  bool isContainerPrimaryColor;

  StatusItemModel({
    required this.statusText,
    required this.statusTextColor,
    required this.statusItemCount,
    this.isContainerPrimaryColor = false,
  });
}
