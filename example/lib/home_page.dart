import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_blue_serial_example/helpers/permisssion_helper.dart';
import 'package:scoped_model/scoped_model.dart';

import 'background_collected_page.dart';
import 'background_collection_task.dart';
import 'chat_page.dart';
import 'scan_page.dart';
import 'select_bonded_device_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask? _collectingTask;

  bool _autoAcceptPairingRequests = false;

  @override
  void initState() {
    super.initState();
    PermissionHelper.requestPermission().then((value) {
      if (value) {
        // Get current state
        FlutterBlueSerial.instance.state.then((state) {
          debugPrint("State: $state");
          setState(() {
            _bluetoothState = state;
          });
        });

        Future.doWhile(() async {
          // Wait if adapter not enabled
          if ((await FlutterBlueSerial.instance.isEnabled) ?? false) {
            return false;
          }
          await Future.delayed(const Duration(milliseconds: 0xDD));
          return true;
        }).then((_) {
          // Update the address field
          FlutterBlueSerial.instance.address.then((address) {
            setState(() {
              _address = address!;
            });
          });
        });

        FlutterBlueSerial.instance.name.then((name) {
          setState(() {
            _name = name!;
          });
        });

        // Listen for further state changes
        FlutterBlueSerial.instance
            .onStateChanged()
            .listen((BluetoothState state) {
          setState(() {
            _bluetoothState = state;

            // Discoverable mode is disabled when Bluetooth gets disabled
            _discoverableTimeoutTimer = null;
            _discoverableTimeoutSecondsLeft = 0;
          });
        });
      } else {
        debugPrint("Permission denied");
      }
    });
  }

  @override
  void dispose() {
    FlutterBlueSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Blue Serial'),
      ),
      body: ListView(
        children: <Widget>[
          const Divider(),
          const ListTile(title: Text('General')),
          SwitchListTile(
            title: const Text('Enable Bluetooth'),
            value: _bluetoothState.isEnabled,
            onChanged: (bool value) {
              // Do the request and update with the true value then
              debugPrint("Switch Value: $value");

              future() async {
                // async lambda seems to not working

                if (value) {
                  await FlutterBlueSerial.instance.requestEnable();
                } else {
                  await FlutterBlueSerial.instance.requestDisable();
                }
              }

              future().then((_) {
                setState(() {});
              });
            },
          ),
          ListTile(
            title: const Text('Bluetooth status'),
            subtitle: Text(_bluetoothState.toString()),
            trailing: ElevatedButton(
              child: const Text('Settings'),
              onPressed: () {
                FlutterBlueSerial.instance.openSettings();
              },
            ),
          ),
          ListTile(
            title: const Text('Local adapter address'),
            subtitle: Text(_address),
          ),
          ListTile(
            title: const Text('Local adapter name'),
            subtitle: Text(_name),
            onLongPress: null,
          ),
          ListTile(
            title: _discoverableTimeoutSecondsLeft == 0
                ? const Text("Discoverable")
                : Text("Discoverable for ${_discoverableTimeoutSecondsLeft}s"),
            subtitle: const Text("PsychoX-Luna"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: _discoverableTimeoutSecondsLeft != 0,
                  onChanged: null,
                ),
                const IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: null,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () async {
                    debugPrint('Discoverable requested');
                    final int timeout = (await FlutterBlueSerial.instance
                        .requestDiscoverable(60))!;
                    if (timeout < 0) {
                      debugPrint('Discoverable mode denied');
                    } else {
                      debugPrint(
                          'Discoverable mode acquired for $timeout seconds');
                    }
                    setState(() {
                      _discoverableTimeoutTimer?.cancel();
                      _discoverableTimeoutSecondsLeft = timeout;
                      _discoverableTimeoutTimer = Timer.periodic(
                          const Duration(seconds: 1), (Timer timer) {
                        setState(() {
                          if (_discoverableTimeoutSecondsLeft < 0) {
                            FlutterBlueSerial.instance.isDiscoverable
                                .then((isDiscoverable) {
                              if (isDiscoverable ?? false) {
                                debugPrint(
                                    "Discoverable after timeout... might be infinity timeout :F");
                                _discoverableTimeoutSecondsLeft += 1;
                              }
                            });
                            timer.cancel();
                            _discoverableTimeoutSecondsLeft = 0;
                          } else {
                            _discoverableTimeoutSecondsLeft -= 1;
                          }
                        });
                      });
                    });
                  },
                )
              ],
            ),
          ),
          const Divider(),
          const ListTile(title: Text('Devices discovery and connection')),
          SwitchListTile(
            title: const Text('Auto-try specific pin when pairing'),
            subtitle: const Text('Pin 1234'),
            value: _autoAcceptPairingRequests,
            onChanged: (bool value) {
              setState(() {
                _autoAcceptPairingRequests = value;
              });
              if (value) {
                FlutterBlueSerial.instance.setPairingRequestHandler(
                    (BluetoothPairingRequest request) {
                  debugPrint("Trying to auto-pair with Pin 1234");
                  if (request.pairingType == PairingType.Pin) {
                    return Future.value("1234");
                  }
                  return Future.value(null);
                });
              } else {
                FlutterBlueSerial.instance.setPairingRequestHandler(null);
              }
            },
          ),
          ListTile(
            title: ElevatedButton(
                child: const Text('Explore discovered devices'),
                onPressed: () async {
                  final BluetoothDevice? selectedDevice =
                      await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const ScanPage();
                      },
                    ),
                  );

                  if (selectedDevice != null) {
                    debugPrint(
                        'Discovery -> selected ${selectedDevice.address}');
                  } else {
                    debugPrint('Discovery -> no device selected');
                  }
                }),
          ),
          ListTile(
            title: ElevatedButton(
              child: const Text('Connect to paired device to chat'),
              onPressed: () async {
                final BluetoothDevice? selectedDevice =
                    await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const SelectBondedDevicePage(
                          checkAvailability: false);
                    },
                  ),
                );

                if (selectedDevice != null && context.mounted) {
                  debugPrint('Connect -> selected ${selectedDevice.address}');
                  _startChat(context, selectedDevice);
                } else {
                  debugPrint('Connect -> no device selected');
                }
              },
            ),
          ),
          const Divider(),
          const ListTile(title: Text('Multiple connections example')),
          ListTile(
            title: ElevatedButton(
              child: ((_collectingTask?.inProgress ?? false)
                  ? const Text('Disconnect and stop background collecting')
                  : const Text('Connect to start background collecting')),
              onPressed: () async {
                if (_collectingTask?.inProgress ?? false) {
                  await _collectingTask!.cancel();
                  setState(() {
                    /* Update for `_collectingTask.inProgress` */
                  });
                } else {
                  final BluetoothDevice? selectedDevice =
                      await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const SelectBondedDevicePage(
                            checkAvailability: false);
                      },
                    ),
                  );

                  if (selectedDevice != null && context.mounted) {
                    await _startBackgroundTask(context, selectedDevice);
                    setState(() {
                      /* Update for `_collectingTask.inProgress` */
                    });
                  }
                }
              },
            ),
          ),
          ListTile(
            title: ElevatedButton(
              onPressed: (_collectingTask != null)
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ScopedModel<BackgroundCollectingTask>(
                              model: _collectingTask!,
                              child: const BackgroundCollectedPage(),
                            );
                          },
                        ),
                      );
                    }
                  : null,
              child: const Text('View background collected data'),
            ),
          ),
        ],
      ),
    );
  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }

  Future<void> _startBackgroundTask(
    BuildContext context,
    BluetoothDevice server,
  ) async {
    try {
      _collectingTask = await BackgroundCollectingTask.connect(server);
      await _collectingTask!.start();
    } catch (ex) {
      _collectingTask?.cancel();
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error occured while connecting'),
              content: Text(ex.toString()),
              actions: [
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}
