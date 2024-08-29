package com.billcoding.flutter_sbox;


import android.annotation.SuppressLint;
import android.os.Build;

import androidx.annotation.RequiresApi;

import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.InterfaceAddress;
import java.net.SocketException;
import java.util.Enumeration;
import java.util.Iterator;

import io.nekohasekai.libbox.InterfaceUpdateListener;
import io.nekohasekai.libbox.NetworkInterface;
import io.nekohasekai.libbox.NetworkInterfaceIterator;
import io.nekohasekai.libbox.PlatformInterface;
import io.nekohasekai.libbox.StringIterator;
import io.nekohasekai.libbox.TunOptions;
import io.nekohasekai.libbox.WIFIState;

public abstract class PlatformInterfaceWrapper implements PlatformInterface {

    public void writeLog(String message) {
    }

    public boolean usePlatformAutoDetectInterfaceControl() {
        return true;
    }

    public void autoDetectInterfaceControl(int fd) {
    }

    public int openTun(TunOptions options) {
        return 0;
    }


    public boolean useProcFS() {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.Q;
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    public int findConnectionOwner(int ipProtocol, String sourceAddress, int sourcePort, String destinationAddress, int destinationPort) {
        return 0;
    }


    public String packageNameByUid(int uid) {
        return "";
    }


    public int uidByPackageName(String packageName) {
        return 0;
    }


    public boolean usePlatformDefaultInterfaceMonitor() {
        return true;
    }


    public void startDefaultInterfaceMonitor(InterfaceUpdateListener listener) {
//        DefaultNetworkMonitor.setListener(listener);
    }


    public void closeDefaultInterfaceMonitor(InterfaceUpdateListener listener) {
//        DefaultNetworkMonitor.setListener(null);
    }

    @SuppressLint("AnnotateVersionCheck")
    public boolean usePlatformInterfaceGetter() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.R;
    }

    public NetworkInterfaceIterator getInterfaces() throws SocketException {
        return new InterfaceArray(java.net.NetworkInterface.getNetworkInterfaces());
    }

    public boolean underNetworkExtension() {
        return false;
    }


    public boolean includeAllNetworks() {
        return false;
    }


    public void clearDNSCache() {
    }


    public WIFIState readWIFIState() {
        return null;
    }

    private static class InterfaceArray implements NetworkInterfaceIterator {
        private final Enumeration<java.net.NetworkInterface> iterator;

        public InterfaceArray(Enumeration<java.net.NetworkInterface> iterator) {
            this.iterator = iterator;
        }

        public boolean hasNext() {
            return iterator.hasMoreElements();
        }

        public NetworkInterface next() {
            final NetworkInterface inter = new NetworkInterface();
            final java.net.NetworkInterface element = iterator.nextElement();

            inter.setName(element.getName());
            inter.setIndex(element.getIndex());
            try {
                inter.setMTU(element.getMTU());
            } catch (SocketException ignored) {

            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                inter.setAddresses(new StringArray(element.getInterfaceAddresses().stream().map(this::toPrefix).iterator()));
            }
            return inter;
        }

        private String toPrefix(InterfaceAddress address0) {
            final InetAddress address = address0.getAddress();
            if (address instanceof Inet6Address) {
                String hostAddress = "";
                try {
                    hostAddress = Inet6Address.getByAddress(address.getAddress()).getHostAddress();
                } catch (Exception ignored) {
                }
                return hostAddress + "/" + address0.getNetworkPrefixLength();
            } else {
                return address.getHostAddress() + "/" + address0.getNetworkPrefixLength();
            }
        }
    }

    private static final class StringArray implements StringIterator {
        private final Iterator<String> iterator;

        public StringArray(Iterator<String> iterator) {
            super();
            this.iterator = iterator;
        }

        public boolean hasNext() {
            return iterator.hasNext();
        }

        public String next() {
            return iterator.next();
        }
    }

}