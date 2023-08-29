part of flutter_blue_serial;
enum BluetoothTypeEnum {
  /// Unknown device type.
  unknown,

  /// Classic - BR/EDR devices.
  classic,

  /// Low Energy - LE-only.
  lowEnergy,

  /// Dual Mode - BR/EDR/LE.
  dual
}
class BluetoothDeviceType {
  // Here Value hold the underlying value.
  final int value;
  final String name;

  const BluetoothDeviceType.fromString(String string)
      : value = (string == 'unknown'
                ? 7936
                : string == 'audioVideo'
                    ? 1024
                    : string == 'computer'
                        ? 256
                        : string == 'health'
                            ? 2304
                            : string == 'imaging'
                                ? 1536
                                : string == 'miscellaneous'
                                    ? 0
                                    : string == 'networking'
                                        ? 768
                                        : string == 'peripheral'
                                            ? 1280
                                            : string == 'phone'
                                                ? 512
                                                : string == 'toy'
                                                    ? 2048
                                                    : string == 'wearable'
                                                        ? 1792
                                                        : 7936 // Unknown, if not found valid
            ),
        name = ((string == 'unknown' ||
                    string == 'audioVideo' ||
                    string == 'computer' ||
                    string == 'health' ||
                    string == 'imaging' ||
                    string == 'miscellaneous' ||
                    string == 'networking' ||
                    string == 'peripheral' ||
                    string == 'phone' ||
                    string == 'toy' ||
                    string == 'wearable' //
                )
                ? string
                : 'unknown' // Unknown, if not found valid
            );

  const BluetoothDeviceType.fromValue(int value)
      : value = ((value >= 0 && value <= 7936)
                ? value
                : 0 // Unknown, if not found valid
            ),
        name = (value == 7936
                ? 'unknown'
                : value == 1024
                    ? 'audioVideo'
                    : value == 256
                        ? 'computer'
                        : value == 2304
                            ? 'health'
                            : value == 1536
                                ? 'imaging'
                                : value == 0
                                    ? 'miscellaneous'
                                    : value == 768
                                        ? 'networking'
                                        : value == 1280
                                            ? 'peripheral'
                                            : value == 512
                                                ? 'phone'
                                                : value == 2048
                                                    ? 'toy'
                                                    : value == 1792
                                                        ? 'wearable'
                                                        : 'unknown' // Unknown, if not found valid
            );

  @override
  String toString() => 'BluetoothDeviceType.$name';

  int toValue() => value;

  static const unknown = BluetoothDeviceType.fromValue(7936);
  static const audioVideo = BluetoothDeviceType.fromValue(1024);
  static const computer = BluetoothDeviceType.fromValue(256);
  static const health = BluetoothDeviceType.fromValue(2304);
  static const imaging = BluetoothDeviceType.fromValue(1536);
  static const miscellaneous = BluetoothDeviceType.fromValue(0);
  static const networking = BluetoothDeviceType.fromValue(768);
  static const peripheral = BluetoothDeviceType.fromValue(1280);
  static const phone = BluetoothDeviceType.fromValue(512);
  static const toy = BluetoothDeviceType.fromValue(2048);
  static const wearable = BluetoothDeviceType.fromValue(1792);

  @override
  operator ==(Object other) {
    return other is BluetoothDeviceType && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
