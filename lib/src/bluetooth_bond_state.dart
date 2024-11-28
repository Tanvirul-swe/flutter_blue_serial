part of flutter_blue_serial;

class BluetoothBondState {
   // Here Value hold the underlying value.
  final int value;
  final String name;

  const BluetoothBondState.fromString(String string)
      : value = (string == 'none'
                ? 10
                : string == 'bonding'
                    ? 11
                    : string == 'bonded'
                        ? 12
                        : -2 // Unknown, if not found valid
            ),
        name =
            ((string == 'none' || string == 'bonding' || string == 'bonded' //
                )
                ? string
                : 'unknown' // Unknown, if not found valid
            );

  const BluetoothBondState.fromValue(int value)
      : value = ((value >= 10 && value <= 12)
                ? value
                : 0 // Unknown, if not found valid
            ),
        name = (value == 10
                ? 'none'
                : value == 11
                    ? 'bonding'
                    : value == 12
                        ? 'bonded'
                        : 'unknown' // Unknown, if not found valid
            );

  @override
  String toString() => 'BluetoothBondState.$name';

  int toValue() => value;

  static const unknown = BluetoothBondState.fromValue(0);
  static const none = BluetoothBondState.fromValue(10);
  static const bonding = BluetoothBondState.fromValue(11);
  static const bonded = BluetoothBondState.fromValue(12);

  @override
  operator ==(Object other) {
    return other is BluetoothBondState &&
        other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  bool get isBonded => this == bonded;
}
