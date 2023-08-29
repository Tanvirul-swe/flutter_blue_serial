// ignore_for_file: constant_identifier_names

part of flutter_blue_serial;

/// Enum-like class for all types of pairing variants.
class PairingType {
  final int underlyingValue;

  const PairingType._(this.underlyingValue);

  factory PairingType.fromUnderlyingValue(int? value) {
    switch (value) {
      case 0:
        return PairingType.Pin;
      case 1:
        return PairingType.Passkey;
      case 2:
        return PairingType.PasskeyConfirmation;
      case 3:
        return PairingType.Consent;
      case 4:
        return PairingType.DisplayPasskey;
      case 5:
        return PairingType.DisplayPin;
      case 6:
        return PairingType.OOB;
      case 7:
        return PairingType.Pin16Digits;
      default:
        return PairingType.Error;
    }
  }
  int toUnderlyingValue() => underlyingValue;

  @override
  String toString() {
    switch (underlyingValue) {
      case 0:
        return 'PairingType.Pin';
      case 1:
        return 'PairingType.Passkey';
      case 2:
        return 'PairingType.PasskeyConfirmation';
      case 3:
        return 'PairingType.Consent';
      case 4:
        return 'PairingType.DisplayPasskey';
      case 5:
        return 'PairingType.DisplayPin';
      case 6:
        return 'PairingType.OOB';
      case 7:
        return 'PairingType.Pin16Digits';
      default:
        return 'PairingType.Error';
    }
  }

  static const Error = PairingType._(-1);
  static const Pin = PairingType._(0);
  static const Passkey = PairingType._(1);
  static const PasskeyConfirmation = PairingType._(2);
  static const Consent = PairingType._(3);
  static const DisplayPasskey = PairingType._(4);
  static const DisplayPin = PairingType._(5);
  static const OOB = PairingType._(6);
  static const Pin16Digits = PairingType._(7);

  // operator ==(Object other) {
  //   return other is PairingType && other.underlyingValue == this.underlyingValue;
  // }

  // @override
  // int get hashCode => underlyingValue.hashCode;
}

/// Represents information about incoming pairing request
class BluetoothPairingRequest {
  /// MAC address of the device or identificator for platform system (if MAC addresses are prohibited).
  final String? address;

  /// Variant of the pairing methods.
  final PairingType? pairingType;

  /// Passkey for confirmation.
  final int? passkey;

  /// Construct `BluetoothPairingRequest` with given values.
  const BluetoothPairingRequest({
    this.address,
    this.pairingType,
    this.passkey,
  });

  /// Creates `BluetoothPairingRequest` from map.
  /// Internally used to receive the object from platform code.
  factory BluetoothPairingRequest.fromMap(Map map) {
    return BluetoothPairingRequest(
      address: map['address'],
      pairingType: PairingType.fromUnderlyingValue(map['variant']),
      passkey: map['passkey'],
    );
  }
}
