package com.billcoding.flutter_sbox;

import android.content.Intent;
import android.os.Build;
import android.os.ParcelFileDescriptor;
import android.util.Log;

import java.io.File;
import java.util.Objects;

import io.nekohasekai.libbox.BoxService;
import io.nekohasekai.libbox.Libbox;
import io.nekohasekai.libbox.PlatformInterface;
import io.nekohasekai.libbox.TunOptions;
import io.nekohasekai.mobile.Mobile;

public class VpnService extends android.net.VpnService {

    private static final String TAG = "Sbox/VpnService";
    private ParcelFileDescriptor pfd;
    private static VpnService instance;
    private BoxService boxService;
    private static boolean initialized = false;

    public synchronized static void stop() {
        Log.d(TAG, "stop start");
        if (instance != null) {
            instance.onDestroy();
            System.gc();
        }
        Log.d(TAG, "stop end");
    }

    @Override
    public void onCreate() {
        super.onCreate();
        instance = this;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        if (pfd != null) {
            try {
                pfd.close();
            } catch (Exception ex) {
                Log.d(TAG, Objects.requireNonNull(ex.getMessage()));
            }
            pfd = null;
        }
        if (boxService != null) {
            try {
                boxService.close();
            } catch (Exception ex) {
                Log.d(TAG, Objects.requireNonNull(ex.getMessage()));
            }
            boxService = null;
        }
        Mobile.stop();
        Log.d(TAG, "onDestroy ...");
    }

    private synchronized static void startInit() {
        Log.d(TAG, "startInit start");
        if (initialized) {
            Log.d(TAG, "startInit was called, skipped.");
            return;
        }
        try {
            final File baseDir = Sbox.getApplication().getFilesDir();
            if (baseDir != null) {
                baseDir.mkdirs();
            }
            final File workingDir = Sbox.getApplication().getExternalFilesDir(null);
            if (workingDir != null) {
                workingDir.mkdirs();
            }
            final File tempDir = Sbox.getApplication().getCacheDir();
            if (tempDir != null) {
                tempDir.mkdirs();
            }
            if (baseDir != null && workingDir != null && tempDir != null) {
                Libbox.setup(baseDir.getPath(), workingDir.getPath(), tempDir.getPath(), false);
                Libbox.redirectStderr(new File(workingDir, "error.log").getPath());
                Log.d(TAG, "startInit baseDir: " + baseDir.getPath());
                Log.d(TAG, "startInit workingDir: " + workingDir.getPath());
                Log.d(TAG, "startInit tempDir: " + tempDir.getPath());
            }
        } catch (Exception ex) {
            Log.d(TAG, "startInit: " + Objects.requireNonNull(ex.getMessage()));
        }
        initialized = true;
    }

    @Override
    public synchronized int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "onStartCommand start");
        Log.d(TAG, "onStartCommand intent: " + intent + " flags: " + flags + " startId: " + startId);
        if (Mobile.serviceStarted()) {
            Log.d(TAG, "onStartCommand service was started, skipped.");
            return START_NOT_STICKY;
        }
        try {
            startInit();
            Libbox.setMemoryLimit(true);
            String allJson = Mobile.getAllJson();
            boxService = Libbox.newService(allJson, platformInterface);
            boxService.start();
            Mobile.start(boxService, true);
        } catch (Exception ex) {
            Log.d(TAG, "onStartCommand: " + Objects.requireNonNull(ex.getMessage()));
        }
        Log.d(TAG, "onStartCommand end");
        return START_STICKY;
    }

    private final PlatformInterface platformInterface = new PlatformInterfaceWrapper() {
        private final static String TAG = "Sbox/PlatformInterface";

        public void autoDetectInterfaceControl(int fd) {
            Log.d(TAG, "autoDetectInterfaceControl start");
            Log.d(TAG, "autoDetectInterfaceControl fd: " + fd);
            protect(fd);
            Log.d(TAG, "autoDetectInterfaceControl end");
        }

        public int openTun(TunOptions options) {
            //TODO: override builder from options
            //TODO: override builder from options
            //TODO: override builder from options
            //TODO: override builder from options
            //TODO: override builder from options
            Log.d(TAG, "openTun start");
            final Builder builder = new Builder().setSession(Sbox.getVpnSession()).addAddress("172.19.0.1", 28).addRoute("0.0.0.0", 0).setMtu(9000);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                builder.setMetered(false);
            }

//            final RoutePrefixIterator inet4Address = options.getInet4Address();
//            while (inet4Address.hasNext()) {
//                final RoutePrefix address = inet4Address.next();
//                builder.addAddress(address.address(), address.prefix());
//            }
//
//            final RoutePrefixIterator inet6Address = options.getInet6Address();
//            while (inet6Address.hasNext()) {
//                final RoutePrefix address = inet6Address.next();
//                builder.addAddress(address.address(), address.prefix());
//            }
//
//            if (options.getAutoRoute()) {
//                try {
//                    builder.addDnsServer(options.getDNSServerAddress());
//                } catch (Exception ex) {
//                    throw new RuntimeException(ex);
//                }
//
//                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
//                    final RoutePrefixIterator inet4RouteAddress = options.getInet4RouteAddress();
//                    if (inet4RouteAddress.hasNext()) {
//                        while (inet4RouteAddress.hasNext()) {
//                            final RoutePrefix nxt = inet4RouteAddress.next();
//                            try {
//                                builder.addRoute(new IpPrefix(InetAddress.getByName(nxt.address()), nxt.prefix()));
//                            } catch (Exception ex) {
//                                Log.d(TAG, ex.getMessage());
//                            }
//                        }
//                    } else {
//            builder.addRoute("0.0.0.0", 0);
//                    }
//
//                    final RoutePrefixIterator inet6RouteAddress = options.getInet6RouteAddress();
//                    if (inet6RouteAddress.hasNext()) {
//                        while (inet6RouteAddress.hasNext()) {
//                            final RoutePrefix nxt = inet6RouteAddress.next();
//                            try {
//                                builder.addRoute(new IpPrefix(InetAddress.getByName(nxt.address()), nxt.prefix()));
//                            } catch (Exception ex) {
//                                Log.d(TAG, ex.getMessage());
//                            }
//                        }
//                    } else {
//                        builder.addRoute("::", 0);
//                    }
//
//                    final RoutePrefixIterator inet4RouteExcludeAddress = options.getInet4RouteExcludeAddress();
//                    while (inet4RouteExcludeAddress.hasNext()) {
//                        final RoutePrefix nxt = inet4RouteExcludeAddress.next();
//                        try {
//                            builder.excludeRoute(new IpPrefix(InetAddress.getByName(nxt.address()), nxt.prefix()));
//                        } catch (Exception ex) {
//                            Log.d(TAG, ex.getMessage());
//                        }
//                    }
//
//                    final RoutePrefixIterator inet6RouteExcludeAddress = options.getInet6RouteExcludeAddress();
//                    while (inet6RouteExcludeAddress.hasNext()) {
//                        final RoutePrefix nxt = inet6RouteExcludeAddress.next();
//                        try {
//                            builder.excludeRoute(new IpPrefix(InetAddress.getByName(nxt.address()), nxt.prefix()));
//                        } catch (Exception ex) {
//                            Log.d(TAG, ex.getMessage());
//                        }
//                    }
//                } else {
//                    final RoutePrefixIterator inet4RouteAddress = options.getInet4RouteRange();
//                    while (inet4RouteAddress.hasNext()) {
//                        final RoutePrefix nxt = inet4RouteAddress.next();
//                        builder.addRoute(nxt.address(), nxt.prefix());
//                    }
//
//                    final RoutePrefixIterator inet6RouteAddress = options.getInet6RouteRange();
//                    while (inet6RouteAddress.hasNext()) {
//                        final RoutePrefix nxt = inet6RouteAddress.next();
//                        builder.addRoute(nxt.address(), nxt.prefix());
//                    }
//                }
//
//                final StringIterator includePackage = options.getIncludePackage();
//                while (includePackage.hasNext()) {
//                    try {
//                        builder.addAllowedApplication(includePackage.next());
//                    } catch (Exception ex) {
//                        Log.d(TAG, ex.getMessage());
//                    }
//                }
//
//                final StringIterator excludePackage = options.getExcludePackage();
//                while (excludePackage.hasNext()) {
//                    try {
//                        builder.addDisallowedApplication(excludePackage.next());
//                    } catch (Exception ex) {
//                        Log.d(TAG, ex.getMessage());
//                    }
//                }
//            }

            int fd = 0;
            if ((pfd = builder.establish()) != null) {
                fd = pfd.getFd();
            }
            Log.d(TAG, "openTun fd: " + fd);
            Log.d(TAG, "openTun end");
            return fd;
        }
    };
}
