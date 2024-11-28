

<p align="center">
<img src="https://github.com/Tanvirul-swe/flutter_blue_serial/assets/75753499/1d5e7f02-28dc-4188-89e7-27d131752438" height="100" alt="Flutter Blue Serial Package" />
</p>

<p align="center">
<a href="https://pub.dev/packages/flutter_bloc"><img src="https://img.shields.io/pub/v/flutter_bloc.svg" alt="Pub"></a>
<a href="https://github.com/Tanvirul-swe/flutter_blue_serial/actions"><img src="https://github.com/felangel/bloc/workflows/build/badge.svg" alt="build"></a>
<a href="https://github.com/Tanvirul-swe/flutter_blue_serial"><img src="https://img.shields.io/github/stars/felangel/bloc.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://flutter.dev/docs/development/data-and-backend"><img src="https://img.shields.io/badge/flutter-website-deepskyblue.svg" alt="Flutter Website"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p> 

---

Flutter Blue Serial helps us to communicate with Bluetooth classic devices. Let's assume we have an IOT switch we want to send some commands `off` and `on` . The device gives us some response. 



## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :-----: |
|   ✔     |  ✘  |   ✘   |  ✘  |   ✘   |    ✘    |
---

## Usage

Let's take a look at how to use `Flutter Blue Serial` to provide an available device, and bonded devices and communicate with the `ESP32` microcontroller.

### Discover devices

Find the nearest available devices including bonded and unbonded.

```dart
  List<BluetoothDiscoveryResult> results =  List<BluetoothDiscoveryResult>.empty(growable: true);
  FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0) {
          results[existingIndex] = r;
        } else {
          results.add(r);
        }
    });
```

### Bond with a device.

Get the specific device then send the address in the `bondDeviceAtAddress` method as a parameter. `bondDeviceAtAddress` gives us a `bool` value. `true` means successfully bonded and `false` means fail to bond. Also, we can check device is bonded or not using `device.isBonded`. It gives us a bool value.

```dart
 BluetoothDevice device = result.device;
 bool isBonded = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(device.address);
```

### Unbond with a device.

Get the specific device then send the address in the `removeDeviceBondWithAddress` method as a parameter. `removeDeviceBondWithAddress` gives us a `bool` value. `true` means successfully Unbond and `false` means fail to Unbond.

```dart
 BluetoothDevice device = result.device;
 bool isUnBonded = await FlutterBluetoothSerial.instance.removeDeviceBondWithAddress(device.address);
```

### Real-time Communicate with a device.

Now, Time to communicate with a device. That means we are talking with a device. Live chatting Any type of IoT Device. Send data into the device and receive data from the device. Here we are getting data from the device and sending raw data in the `onDataReceived` method. Then finally process our raw data.

#### Connect with device

```dart
 BluetoothDevice device = result.device;
 bool isConnecting = true;
 bool get isConnected => (connection?.isConnected ?? false);
 bool isDisconnecting = false;
 String _messageBuffer = '';

 BluetoothConnection.toAddress(device.address).then((status) {
      debugPrint('Connected to the device');

      connection = status;
      isConnecting = false;
      isDisconnecting = false;

      connection!.input!.listen(onDataReceived).onDone(() {
        if (isDisconnecting) {
          debugPrint('Disconnecting locally!');
        } else {
          debugPrint('Disconnected remotely!');
        }
      
      });
    }).catchError((error) {
      debugPrint('Cannot connect, exception occured');
      debugPrint(error.toString());
    });
```

#### Send data

```dart
  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.isNotEmpty) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode("$text\r\n")));
        await connection!.output.allSent;
      } catch (e) {
        debugPrint("Error: ${e.toString()}");
        setState(() {});
      }
    }
  }

```

#### Receive data

```dart
  void onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    for (var byte in data) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    }
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create a message if there is the newline character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      String finalData = backspacesCounter > 0 ? _messageBuffer.substring( 0, _messageBuffer.length - backspacesCounter): _messageBuffer + dataString.substring(0, index);
      _messageBuffer = dataString.substring(index);

    } else {
      _messageBuffer = (backspacesCounter > 0? _messageBuffer.substring(0, _messageBuffer.length - backspacesCounter) : _messageBuffer + dataString);
    }
  }
```




## Gallery

<div style="text-align: center">
    <table>
<!--         <tr>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/#/fluttercountertutorial">
                    <img src="https://bloclibrary.dev/assets/gifs/flutter_counter.gif" width="200"/>
                </a>
            </td>            
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/#/flutterinfinitelisttutorial">
                    <img src="https://bloclibrary.dev/assets/gifs/flutter_infinite_list.gif" width="200"/>
                </a>
            </td>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/#/flutterfirebaselogintutorial">
                    <img src="https://bloclibrary.dev/assets/gifs/flutter_firebase_login.gif" width="200" />
                </a>
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/#/flutterangulargithubsearch">
                    <img src="https://bloclibrary.dev/assets/gifs/flutter_github_search.gif" width="200"/>
                </a>
            </td>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/#/flutterweathertutorial">
                    <img src="https://bloclibrary.dev/assets/gifs/flutter_weather.gif" width="200"/>
                </a>
            </td>
            <td style="text-align: center">
                <a href="https://bloclibrary.dev/#/fluttertodostutorial">
                    <img src="https://bloclibrary.dev/assets/gifs/flutter_todos.gif" width="200"/>
                </a>
            </td>
        </tr> -->
    </table>
</div>

## Examples

- [Chat With ESP32](https://bloclibrary.dev/#/fluttercountertutorial) - an example of how to create a Live chat with an `ESP32` Device to implement the classic Flutter app.


## Dart Versions

- Dart 2: >= 3.1.0

## Maintainers

- [Md. Tanvirul Islam](https://github.com/Tanvirul-swe)
