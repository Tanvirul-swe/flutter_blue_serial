import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_blue_serial_platform_interface.dart';

/// An implementation of [FlutterBlueSerialPlatform] that uses method channels.
class MethodChannelFlutterBlueSerial extends FlutterBlueSerialPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_blue_serial');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
