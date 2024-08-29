package com.billcoding.flutter_sbox;

import androidx.annotation.NonNull;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public final class FlutterSboxPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {
    private MethodChannel methodChannel;
    private final String TAG = "Sbox/FlutterSboxPlugin";

    public void onAttachedToEngine(FlutterPlugin.FlutterPluginBinding flutterPluginBinding) {
        this.methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), TAG);
        this.methodChannel.setMethodCallHandler(this);
    }

    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
    }

    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        Log.d(TAG, "onMethodCall start");
        String method = call.method;
        Object arguments = call.arguments;
        String argumentsString = null;
        if (arguments instanceof String) {
            argumentsString = String.valueOf(arguments);
        }
        Log.d(TAG, "onMethodCall method: " + method + " arguments: " + arguments);
        switch (method) {
            default:
                result.notImplemented();
            case "startService":
                Sbox.start();
                result.success(true);
                break;
            case "stopService":
                Sbox.stop();
                result.success(true);
                break;
            case "serviceStarted":
                result.success(Sbox.serviceStarted());
                break;
            case "setOptionJson":
                Sbox.setOptionJson(argumentsString);
                result.success(true);
                break;
            case "setConfigJson":
                Sbox.setConfigJson(argumentsString);
                result.success(true);
                break;
        }
        Log.d(TAG, "onMethodCall end");
    }
}
