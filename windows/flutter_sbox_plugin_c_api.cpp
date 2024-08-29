#include "include/flutter_sbox/flutter_sbox_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_sbox_plugin.h"

void FlutterSboxPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_sbox::FlutterSboxPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
