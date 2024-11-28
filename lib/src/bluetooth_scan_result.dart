part of flutter_blue_serial;

class BluetoothScanResult {
  final BluetoothDevice device;
  final int rssi;

  BluetoothScanResult({
    required this.device,
    this.rssi = 0,
  });

  factory BluetoothScanResult.fromMap(Map map) {
    return BluetoothScanResult(
      device: BluetoothDevice.fromMap(map),
      rssi: map['rssi'] ?? 0,
    );
  }
}
