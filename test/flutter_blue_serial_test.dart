import 'package:flutter_blue_serial/src/flutter_blue_serial_method_channel.dart';
import 'package:flutter_blue_serial/src/flutter_blue_serial_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterBlueSerialPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBlueSerialPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterBlueSerialPlatform initialPlatform = FlutterBlueSerialPlatform.instance;

  test('$MethodChannelFlutterBlueSerial is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBlueSerial>());
  });

  test('getPlatformVersion', () async {
    // FlutterBluetoothSerial flutterBlueSerialPlugin = FlutterBluetoothSerial();
    // MockFlutterBlueSerialPlatform fakePlatform = MockFlutterBlueSerialPlatform();
    // FlutterBlueSerialPlatform.instance = fakePlatform;

    // expect(await flutterBlueSerialPlugin.getPlatformVersion(), '42');
  });
}
