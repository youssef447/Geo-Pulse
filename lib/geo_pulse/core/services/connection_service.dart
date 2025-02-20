import 'package:flutter/material.dart';
import 'package:geo_pulse/geo_pulse/core/widgets/no_internet_screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class ConnectionService {
  static Stream<InternetConnectionStatus> initConnectivity() {
    final customChecker = InternetConnectionChecker.createInstance(
        addresses: [AddressCheckOption(uri: Uri.parse('https://google.com'))],
        slowConnectionConfig: const SlowConnectionConfig(
          enableToCheckForSlowConnection: true,
          slowConnectionThreshold: Duration(seconds: 15),
        ));
    return customChecker.onStatusChange;
  }

  static Widget handeConnection(
      {required Widget child, required InternetConnectionStatus? status}) {
    if (status == InternetConnectionStatus.disconnected ||
        status == InternetConnectionStatus.slow) {
      return const NoInternetScreen();
    }
    return child;
  }
}
