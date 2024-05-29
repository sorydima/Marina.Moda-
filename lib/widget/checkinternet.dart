// ignore_for_file: empty_catches

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class CheckInternet {
  static final Connectivity _connectivity = Connectivity();

  static String _connectionStatus = 'Unknown';

  static Future<String> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;

    try {
      result = await _connectivity.checkConnectivity();
    // ignore: unused_catch_clause
    } on PlatformException catch (e) {
    
    }

    return updateConnectionStatus(result);
  }

  static Future<String> updateConnectionStatus(
      ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        _connectionStatus = result.toString();
        return _connectionStatus;
      
      default:
        _connectionStatus = 'Failed to get connectivity.';
        return _connectionStatus;
      
    }
  }
}
