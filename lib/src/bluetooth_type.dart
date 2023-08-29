part of flutter_blue_serial;

class BluetoothType {
// HERE Value hold the underlying value.
  final int value;
  final String name;

  const BluetoothType.fromString(String string)
      : value = (string == 'unknown'
                ? 0
                : string == 'classic'
                    ? 1
                    : string == 'le'
                        ? 2
                        : string == 'dual'
                            ? 3
                            : -2 // Unknown, if not found valid
            ),
        name = ((string == 'unknown' ||
                    string == 'classic' ||
                    string == 'le' ||
                    string == 'dual' //
                )
                ? string
                : 'unknown' // Unknown, if not found valid
            );

  const BluetoothType.fromvalue(int value)
      : value = ((value >= 0 && value <= 3)
                ? value
                : 0 // Unknown, if not found valid
            ),
        name = (value == 0
                ? 'unknown'
                : value == 1
                    ? 'classic'
                    : value == 2
                        ? 'le'
                        : value == 3
                            ? 'dual'
                            : 'unknown' // Unknown, if not found valid
            );

  @override
  String toString() => 'BluetoothType.$name';

  int toValue() => value;

  static const unknown = BluetoothType.fromvalue(0);
  static const classic = BluetoothType.fromvalue(1);
  static const le = BluetoothType.fromvalue(2);
  static const dual = BluetoothType.fromvalue(3);

  @override
  operator ==(Object other) {
    return other is BluetoothType &&
        other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}


