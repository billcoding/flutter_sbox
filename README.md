# flutter_sbox

The flutter_sbox plugin for Flutter

## Environment Dependencies
- Go SDK 1.22.5+
- make
- protoc
- gomobile & gobind
- NDK

## Supported Operating Systems
- [x] Linux `amd64`
- [x] Darwin `amd64, arm64`
- [ ] Windows

## Supported Platforms
- [x] Android
- [ ] iOS
- [ ] macOS
- [ ] Windows

## Flutter Plugin Methods
- `FlutterSbox.startService` start vpn service (prepare -> vpn permission requests -> start vpn service)
- `FlutterSbox.stopService` stop vpn service
- `FlutterSbox.serviceStarted` returns the vpn service started?
- `FlutterSbox.setOptionJson` set vpn service option json
- `FlutterSbox.setConfigJson` set vpn service config json

## Getting Started

### Android setup
- AndroidManifest.xml
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
    
......

    <application

        <service
            android:name="com.billcoding.flutter_sbox.VpnService"
            android:exported="false"
            android:permission="android.permission.BIND_VPN_SERVICE">
            <intent-filter>
                <action android:name="android.net.VpnService" />
            </intent-filter>
        </service>
......
```

- MainActivity.java
```java

import android.os.Bundle;
import com.billcoding.flutter_sbox.Sbox;
import io.flutter.embedding.android.FlutterFragmentActivity;

public class MainActivity extends FlutterFragmentActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Sbox.init(getApplication(), this, "yourapp");
    }
}
```

- MainActivity.kt
```kotlin

import android.os.Bundle
import com.billcoding.flutter_sbox.Sbox
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Sbox.init(application, this, "yourapp")
    }
}
```