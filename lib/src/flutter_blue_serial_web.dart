// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show window;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'flutter_blue_serial_platform_interface.dart';

/// A web implementation of the FlutterBlueSerialPlatform of the FlutterBlueSerial plugin.
class FlutterBlueSerialWeb extends FlutterBlueSerialPlatform {
  /// Constructs a FlutterBlueSerialWeb
  FlutterBlueSerialWeb();

  static void registerWith(Registrar registrar) {
    FlutterBlueSerialPlatform.instance = FlutterBlueSerialWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    final version = html.window.navigator.userAgent;
    return version;
  }
}
