

part of flutter_blue_serial;

class BluetoothDeviceType {
  final int underlyingValue;
  final String stringValue;


  const BluetoothDeviceType.fromString(String string)
      : underlyingValue = (string == 'unknown'
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
        stringValue = ((string == 'unknown' ||
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

  const BluetoothDeviceType.fromUnderlyingValue(int value)
      : underlyingValue = ((value >= 0 && value <= 7936)
          ? value
          : 0 // Unknown, if not found valid
      ),
        stringValue = (value == 7936
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
  String toString() => 'BluetoothDeviceType.$stringValue';

  int toUnderlyingValue() => underlyingValue;

  static const unknown = BluetoothDeviceType.fromUnderlyingValue(7936);
  static const audioVideo = BluetoothDeviceType.fromUnderlyingValue(1024);
  static const computer = BluetoothDeviceType.fromUnderlyingValue(256);
  static const health = BluetoothDeviceType.fromUnderlyingValue(2304);
  static const imaging = BluetoothDeviceType.fromUnderlyingValue(1536);
  static const miscellaneous = BluetoothDeviceType.fromUnderlyingValue(0);
  static const networking = BluetoothDeviceType.fromUnderlyingValue(768);
  static const peripheral = BluetoothDeviceType.fromUnderlyingValue(1280);
  static const phone = BluetoothDeviceType.fromUnderlyingValue(512);
  static const toy = BluetoothDeviceType.fromUnderlyingValue(2048);
  static const wearable = BluetoothDeviceType.fromUnderlyingValue(1792);

  @override
  operator ==(Object other) {
    return other is BluetoothDeviceType && other.underlyingValue == underlyingValue;
  }

  @override
  int get hashCode => underlyingValue.hashCode;
}
