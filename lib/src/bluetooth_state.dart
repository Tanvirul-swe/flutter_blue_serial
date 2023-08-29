// ignore_for_file: constant_identifier_names

part of flutter_blue_serial;

class BluetoothState {
  final int value;
  final String name;

  const BluetoothState.fromString(String string)
      : value = (string == 'STATE_OFF'
                ? 10
                : string == 'STATE_TURNING_ON'
                    ? 11
                    : string == 'STATE_ON'
                        ? 12
                        : string == 'STATE_TURNING_OFF'
                            ? 13
                            :

                            //ring == 'STATE_BLE_OFF'         ? 10 :
                            string == 'STATE_BLE_TURNING_ON'
                                ? 14
                                : string == 'STATE_BLE_ON'
                                    ? 15
                                    : string == 'STATE_BLE_TURNING_OFF'
                                        ? 16
                                        : string == 'ERROR'
                                            ? -1
                                            : -2 // Unknown, if not found valid
            ),
        name = ((string == 'STATE_OFF' ||
                    string == 'STATE_TURNING_ON' ||
                    string == 'STATE_ON' ||
                    string == 'STATE_TURNING_OFF' ||

                    //ring == 'STATE_BLE_OFF'         ||
                    string == 'STATE_BLE_TURNING_ON' ||
                    string == 'STATE_BLE_ON' ||
                    string == 'STATE_BLE_TURNING_OFF' ||
                    string == 'ERROR')
                ? string
                : 'UNKNOWN' // Unknown, if not found valid
            );

  const BluetoothState.fromValue(int value)
      : value = (((value >= 10 && value <= 16) || value == -1)
                ? value
                : -2 // Unknown, if not found valid
            ),
        name = (value == 10
                ? 'STATE_OFF'
                : value == 11
                    ? 'STATE_TURNING_ON'
                    : value == 12
                        ? 'STATE_ON'
                        : value == 13
                            ? 'STATE_TURNING_OFF'
                            :

                            //lue == 10 ? 'STATE_BLE_OFF'         : // Just for symetry in code :F
                            value == 14
                                ? 'STATE_BLE_TURNING_ON'
                                : value == 15
                                    ? 'STATE_BLE_ON'
                                    : value == 16
                                        ? 'STATE_BLE_TURNING_OFF'
                                        : value == -1
                                            ? 'ERROR'
                                            : 'UNKNOWN' // Unknown, if not found valid
            );

  @override
  String toString() => 'BluetoothState.$name';

  int tovalue() => value;

  static const STATE_OFF = BluetoothState.fromValue(10);
  static const STATE_TURNING_ON = BluetoothState.fromValue(11);
  static const STATE_ON = BluetoothState.fromValue(12);
  static const STATE_TURNING_OFF = BluetoothState.fromValue(13);

  //atic const STATE_BLE_OFF = BluetoothState.STATE_OFF; // Just for symetry in code :F
  static const STATE_BLE_TURNING_ON = BluetoothState.fromValue(14);
  static const STATE_BLE_ON = BluetoothState.fromValue(15);
  static const STATE_BLE_TURNING_OFF = BluetoothState.fromValue(16);

  static const ERROR = BluetoothState.fromValue(-1);
  static const UNKNOWN = BluetoothState.fromValue(-2);

  @override
  operator ==(Object other) {
    return other is BluetoothState &&
        other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  bool get isEnabled => this == STATE_ON;
}
