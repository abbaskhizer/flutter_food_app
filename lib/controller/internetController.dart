import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InternetController extends GetxController {
 
  @override
  void onInit() {
    super.onInit();
  StreamSubscription<List<ConnectivityResult>> subscription=Connectivity().onConnectivityChanged.listen(netsStatus);
  }
  

  netsStatus(List<ConnectivityResult> result) {
    if (result == ConnectivityResult.none) {
      Get.rawSnackbar(
          title: 'No Internet',
          message: 'Connect to internet to proceed',
          icon:const Icon(
            Icons.wifi_off,
            color: Colors.white,
          ),
          isDismissible: true,
          duration:const Duration(days: 1),
          shouldIconPulse: true);
    } else if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }
  }
}
