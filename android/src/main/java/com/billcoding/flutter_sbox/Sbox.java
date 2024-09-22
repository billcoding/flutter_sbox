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

    public static Application getApplication() {
        return application;
    }

    public static String getVpnSession() {
        return vpnSession;
    }

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
}
