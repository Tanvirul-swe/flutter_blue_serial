import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_blue_serial_method_channel.dart';

abstract class FlutterBlueSerialPlatform extends PlatformInterface {
  /// Constructs a FlutterBlueSerialPlatform.
  FlutterBlueSerialPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBlueSerialPlatform _instance = MethodChannelFlutterBlueSerial();

  /// The default instance of [FlutterBlueSerialPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterBlueSerial].
  static FlutterBlueSerialPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterBlueSerialPlatform] when
  /// they register themselves.
  static set instance(FlutterBlueSerialPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
