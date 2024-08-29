package com.billcoding.flutter_sbox;

import android.app.Application;
import android.content.ComponentName;
import android.content.Intent;
import android.util.Log;

import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.fragment.app.FragmentActivity;

import io.nekohasekai.mobile.Mobile;

public class Sbox {
    private static final String TAG = "Sbox/Sbox";
    private static FragmentActivity activity;
    private static Application application;
    private static ActivityResultLauncher<Intent> vpnServiceLauncher;
    private static String vpnSession = "Sbox";
    private static String optionJson = Conf.INSTANCE.getDefaultOptionJson();
    private static String configJson = null;
    private static String allJson = null;

    public synchronized static void init(Application application, FragmentActivity activity, String vpnSession) {
        Log.d(TAG, "init start");
        Sbox.application = application;
        Sbox.activity = activity;
        if (vpnSession != null && !vpnSession.isEmpty()) {
            Sbox.vpnSession = vpnSession;
        }
        vpnServiceLauncher = activity.registerForActivityResult(new ActivityResultContracts.StartActivityForResult(), result -> {
            Log.d(TAG, "registerForActivityResult start");
            if (result.getResultCode() == -1) {
                startService();
            }
            Log.d(TAG, "registerForActivityResult end");
        });
        Log.d(TAG, "init end");
    }

    public synchronized static void start() {
        Log.d(TAG, "start start");
        setAllJson(getOptionJson(), getConfigJson());
        Intent intent = VpnService.prepare(activity);
        if (intent != null) {
            vpnServiceLauncher.launch(intent);
        } else {
            startService();
        }
        Log.d(TAG, "start end");
    }

    private synchronized static void startService() {
        Log.d(TAG, "startService start");
        ComponentName componentName = activity.startService(new Intent(activity.getApplicationContext(), VpnService.class));
        Log.d(TAG, "startService componentName: " + componentName);
        Log.d(TAG, "startService end ");
    }

    public synchronized static void stop() {
        Log.d(TAG, "stop start");
        stopService();
        Log.d(TAG, "stop end");
    }

    public synchronized static void stopService() {
        Log.d(TAG, "stopService start");
        VpnService.stop();
        Log.d(TAG, "stopService end");
    }

    public synchronized static boolean serviceStarted() {
        Log.d(TAG, "serviceStarted start");
        final boolean serviceStarted = VpnService.serviceStarted();
        Log.d(TAG, "serviceStarted end");
        return serviceStarted;
    }

    public static Application getApplication() {
        return application;
    }

    public static String getVpnSession() {
        return vpnSession;
    }

    public static void setOptionJson(String currentOptionJson) {
        Log.d(TAG, "setOptionJson start");
        if (currentOptionJson != null && !currentOptionJson.isEmpty()) {
            optionJson = currentOptionJson;
            Log.d(TAG, "setOptionJson current: " + optionJson);
        }
        Log.d(TAG, "setOptionJson end");
    }

    private static String getOptionJson() {
        return optionJson;
    }

    public static void setConfigJson(String currentConfigJson) {
        Log.d(TAG, "setConfigJson start");
        if (currentConfigJson != null && !currentConfigJson.isEmpty()) {
            configJson = currentConfigJson;
            Log.d(TAG, "setConfigJson current: " + configJson);
        }
        Log.d(TAG, "setConfigJson end");
    }

    private static String getConfigJson() {
        return configJson;
    }

    public static void setAllJson(String optionJson, String configJson) {
        Log.d(TAG, "setAllJson start");
        try {
            allJson = Mobile.buildConfig(optionJson, configJson);
            Log.d(TAG, "setAllJson current: " + allJson);
        } catch (Exception ex) {
            Log.d(TAG, "setAllJson " + ex.getMessage());
        }
        Log.d(TAG, "setAllJson end");
    }

    public static String getAllJson() {
        return allJson;
    }
}
