part of flutter_blue_serial;

class BluetoothType {
  final int underlyingValue;
  final String stringValue;

  const BluetoothType.fromString(String string)
      : underlyingValue = (string == 'unknown'
                ? 0
                : string == 'classic'
                    ? 1
                    : string == 'le'
                        ? 2
                        : string == 'dual'
                            ? 3
                            : -2 // Unknown, if not found valid
            ),
        stringValue = ((string == 'unknown' ||
                    string == 'classic' ||
                    string == 'le' ||
                    string == 'dual' //
                )
                ? string
                : 'unknown' // Unknown, if not found valid
            );

  const BluetoothType.fromUnderlyingValue(int value)
      : underlyingValue = ((value >= 0 && value <= 3)
                ? value
                : 0 // Unknown, if not found valid
            ),
        stringValue = (value == 0
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
  String toString() => 'BluetoothType.$stringValue';

  int toUnderlyingValue() => underlyingValue;

  static const unknown = BluetoothType.fromUnderlyingValue(0);
  static const classic = BluetoothType.fromUnderlyingValue(1);
  static const le = BluetoothType.fromUnderlyingValue(2);
  static const dual = BluetoothType.fromUnderlyingValue(3);

  @override
  operator ==(Object other) {
    return other is BluetoothType &&
        other.underlyingValue == underlyingValue;
  }

  @override
  int get hashCode => underlyingValue.hashCode;
}


