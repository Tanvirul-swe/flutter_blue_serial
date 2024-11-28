#include "include/flutter_blue_serial/flutter_blue_serial_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_blue_serial_plugin.h"

void FlutterBlueSerialPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_blue_serial::FlutterBlueSerialPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
