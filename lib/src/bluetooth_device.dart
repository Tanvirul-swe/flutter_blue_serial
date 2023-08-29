part of flutter_blue_serial;

/// Represents information about the device. Could be out-of-date. // @TODO . add updating the info via some fn
class BluetoothDevice {
  /// Broadcasted friendly name of the device.
  final String? name;

  /// MAC address of the device or identificator for platform system (if MAC addresses are prohibited).
  final String address;

  /// Type of the device (Bluetooth standard type).
  final BluetoothType type;

  /// Class of the device.
  //final BluetoothClass bluetoothClass // @TODO . !BluetoothClass!

  /// Describes is device connected.
  final bool isConnected;

  /// Bonding state of the device.
  final BluetoothBondState bondState;

  /// Tells whether the device is bonded (ready to secure connect).
  @Deprecated('Use `isBonded` instead')
  bool get bonded => bondState.isBonded;

  /// Tells whether the device is bonded (ready to secure connect).
  bool get isBonded => bondState.isBonded;

  // Bluetooth Device Type Constants (from Android API)
  final BluetoothDeviceType deviceType;

  /// Construct `BluetoothDevice` with given values.
  const BluetoothDevice({
    this.name,
    required this.address,
    this.type = BluetoothType.unknown,
    this.isConnected = false,
    this.bondState = BluetoothBondState.unknown,
    this.deviceType = BluetoothDeviceType.unknown,
  });

  /// Creates `BluetoothDevice` from map.
  ///
  /// Internally used to receive the object from platform code.
  factory BluetoothDevice.fromMap(Map map) {
    return BluetoothDevice(
      name: map["name"],
      address: map["address"]!,
      type: map["type"] != null
          ? BluetoothType.fromvalue(map["type"])
          : BluetoothType.unknown,
      deviceType: map["deviceType"] != null
          ? BluetoothDeviceType.fromValue(map["deviceType"])
          : BluetoothDeviceType.unknown,
      isConnected: map["isConnected"] ?? false,
      bondState: map["bondState"] != null
          ? BluetoothBondState.fromValue(map["bondState"])
          : BluetoothBondState.unknown,
    );
  }

  /// Creates map from `BluetoothDevice`.
  Map<String, dynamic> toMap() => {
        "name": name,
        "address": address,
        "type": type.toValue(),
        "isConnected": isConnected,
        "bondState": bondState.toValue(),
        "deviceType": deviceType.toValue(),
      };

  /// Compares for equality of this and other `BluetoothDevice`.
  ///
  /// In fact, only `address` is compared, since this is most important
  /// and unchangable information that identifies each device.
  @override
  operator ==(Object other) {
    return other is BluetoothDevice && other.address == address;
  }

  @override
  int get hashCode => address.hashCode;
}
