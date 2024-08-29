#ifndef FLUTTER_PLUGIN_FLUTTER_SBOX_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_SBOX_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_sbox {

class FlutterSboxPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterSboxPlugin();

  virtual ~FlutterSboxPlugin();

  // Disallow copy and assign.
  FlutterSboxPlugin(const FlutterSboxPlugin&) = delete;
  FlutterSboxPlugin& operator=(const FlutterSboxPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_sbox

#endif  // FLUTTER_PLUGIN_FLUTTER_SBOX_PLUGIN_H_
