import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_serial/flutter_bluetooth_serial.dart';

class ScanPage extends StatefulWidget {
  /// If true, Scan Start automatically.Otherwise, Scan Start by tapping on the action.
  final bool start;

  const ScanPage({super.key, this.start = true});

  @override
  State<ScanPage> createState() => _ScanPage();
}

class _ScanPage extends State<ScanPage> {
  StreamSubscription<BluetoothScanResult>? _streamSubscription;
  List<BluetoothScanResult> results = [];
  bool isDiscovering = false;

  @override
  void initState() {
    super.initState();

    isDiscovering = widget.start;
    if (isDiscovering) {
      _startScan();
    }
  }

  void _restartScan() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startScan();
  }

  void _startScan() {
    _streamSubscription = FlutterBlueSerial.instance.startScaning().listen((r) {
      setState(() {
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0) {
          results[existingIndex] = r;
        } else {
          results.add(r);
        }
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isDiscovering
            ? const Text('Scaning devices')
            : const Text('Scaned devices'),
        actions: [
          isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: _restartScan,
                )
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8.0),
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.grey[200],
            ),
            child: ListTile(
              title: Text(results[index].device.name ?? "Unknown"),
              subtitle: Text(
                  "Device Type : ${results[index].device.deviceType.name}\nBond State : ${results[index].device.bondState.name}\nBluetooth Type : ${results[index].device.type.name}"),
              leading: getDeviceIcon(results[index].device.deviceType.value),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  results[index].rssi != 0
                      ? Container(
                          margin: const EdgeInsets.all(8.0),
                          child: DefaultTextStyle(
                            style: Theme.of(context).textTheme.bodySmall!,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(results[index].rssi.toString()),
                                const Text('dBm'),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(width: 0, height: 0),
                  results[index].device.isConnected
                      ? const Icon(Icons.import_export)
                      : const SizedBox.shrink(),
                  results[index].device.isBonded
                      ? const Icon(Icons.link)
                      : const SizedBox.shrink(),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop(results[index].device);
              },
              onLongPress: () async {
                bool bonded = false;
                if (results[index].device.isBonded) {
                  debugPrint(
                      'Unbonding from ${results[index].device.address}...');
                  await FlutterBlueSerial.instance.removeDeviceBondWithAddress(
                      results[index].device.address);
                  debugPrint(
                      'Unbonding from ${results[index].device.address} has succed');
                } else {
                  debugPrint(
                      'Bonding with ${results[index].device.address}...');
                  bonded = (await FlutterBlueSerial.instance
                      .bondDeviceAtAddress(results[index].device.address))!;
                  debugPrint(
                      'Bonding with ${results[index].device.address} has ${bonded ? 'succed' : 'failed'}.');
                }
                setState(() {
                  results[results.indexOf(results[index])] =
                      BluetoothScanResult(
                          device: BluetoothDevice(
                            name: results[index].device.name ?? '',
                            address: results[index].device.address,
                            type: results[index].device.type,
                            bondState: bonded
                                ? BluetoothBondState.bonded
                                : BluetoothBondState.none,
                          ),
                          rssi: results[index].rssi);
                });
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
          height: 8,
        ),
      ),
    );
  }

// Get Device Icon based on device type
  Icon getDeviceIcon(int underlyingValue) {
    switch (underlyingValue) {
      case 7936:
        return const Icon(Icons.devices_other);
      case 1024:
        return const Icon(Icons.audio_file);
      case 256:
        return const Icon(Icons.computer);
      case 2304:
        return const Icon(Icons.health_and_safety);
      case 1536:
        return const Icon(Icons.image);
      case 0:
        return const Icon(Icons.devices_other);
      case 768:
        return const Icon(Icons.network_cell);
      case 1280:
        return const Icon(Icons.devices_other);
      case 512:
        return const Icon(Icons.phone);
      case 2048:
        return const Icon(Icons.toys);
      case 1792:
        return const Icon(Icons.devices_other);
      default:
        return const Icon(Icons.devices_other);
    }
  }
}
