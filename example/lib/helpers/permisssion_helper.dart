import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper{
  static Future<bool> requestPermission() async {
    late final Map<Permission, PermissionStatus> statuses;
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      statuses = await [
        Permission.location,
        Permission.camera,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();
    } else {
      statuses = await [
        Permission.location,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ].request();
    }

    bool isPass = true;
    statuses.forEach((key, value) {
      if (value.isDenied) {
        isPass = false;
      } else if (value.isPermanentlyDenied) {
        debugPrint("Current status: $key is permanently denied");
        isPass = false;
        openAppSettings();
      }
    });
    return isPass;
  }
}