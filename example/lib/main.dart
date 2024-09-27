import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_sbox/flutter_sbox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool started = false;
  int upLink = 0;
  int downLink = 0;
  Timer? timer;

  Future refresh() async {
    started = await FlutterSbox.serviceStarted();
    setState(() {});
  }

  Future startTimer() async {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      upLink = await FlutterSbox.upLink();
      downLink = await FlutterSbox.downLink();
      setState(() {});
    });
  }

  Future stopTimer() async {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                child: const Text("Start"),
                onPressed: () async {
                  await FlutterSbox.setOptionJson(optionsJson);
                  await FlutterSbox.setConfigJson(configJson);
                  await FlutterSbox.startService();
                  await startTimer();
                },
              ),
              TextButton(
                child: const Text("Stop"),
                onPressed: () async {
                  await FlutterSbox.stopService();
                  await stopTimer();
                },
              ),
              Text('Current: ${started ? "started" : "stopped"}'),
              TextButton(
                child: const Text("Refresh"),
                onPressed: () async {
                  await refresh();
                },
              ),
              Text('Links: ↑${upLink} B/s ↓${downLink} B/s'),
            ],
          ),
        ),
      ),
    );
  }
}

const optionsJson = """
{
    "region": "cn",
    "block-ads": false,
    "execute-config-as-is": false,
    "log-level": "warn",
    "resolve-destination": false,
    "ipv6-mode": "ipv4_only",
    "remote-dns-address": "udp://1.1.1.1",
    "remote-dns-domain-strategy": "",
    "direct-dns-address": "223.5.5.5",
    "direct-dns-domain-strategy": "",
    "mixed-port": 12334,
    "tproxy-port": 12335,
    "local-dns-port": 16450,
    "tun-implementation": "mixed",
    "mtu": 9000,
    "strict-route": true,
    "connection-test-url": "http://connectivitycheck.gstatic.com/generate_204",
    "url-test-interval": 600,
    "enable-clash-api": true,
    "clash-api-port": 16756,
    "enable-tun": true,
    "enable-tun-service": false,
    "set-system-proxy": false,
    "bypass-lan": false,
    "allow-connection-from-lan": false,
    "enable-fake-dns": false,
    "enable-dns-routing": true,
    "independent-dns-cache": true,
    "rules": [],
    "mux": {
        "enable": false,
        "padding": false,
        "max-streams": 8,
        "protocol": "h2mux"
    },
    "tls-tricks": {
        "enable-fragment": false,
        "fragment-size": "10-30",
        "fragment-sleep": "2-8",
        "mixed-sni-case": false,
        "enable-padding": false,
        "padding-size": "1-1500"
    },
    "warp": {
        "enable": false,
        "mode": "proxy_over_warp",
        "wireguard-config": "",
        "license-key": "",
        "account-id": "",
        "access-token": "",
        "clean-ip": "auto",
        "clean-port": 0,
        "noise": "1-3",
        "noise-size": "10-30",
        "noise-delay": "10-30",
        "noise-mode": "m6"
    },
    "warp2": {
        "enable": false,
        "mode": "proxy_over_warp",
        "wireguard-config": "",
        "license-key": "",
        "account-id": "",
        "access-token": "",
        "clean-ip": "auto",
        "clean-port": 0,
        "noise": "1-3",
        "noise-size": "10-30",
        "noise-delay": "10-30",
        "noise-mode": "m6"
    }
}
""";

const configJson = """
{
    "outbounds": [
      {
        "type": "vless",
        "tag": "vless-in",
        "server": "server.yours.com",
        "server_port": 443,
        "uuid": "e8f0c5a4-2f0e-4a1b-81b4-2f8b9aee7048",
        "tls": {
          "enabled": true,
          "server_name": "server.yours.com",
          "utls": {
            "enabled": true,
            "fingerprint": "chrome"
          }
        },
        "transport": {
          "type": "ws",
          "path": "/b20gc3RyaW5n/",
          "early_data_header_name": "Sec-WebSocket-Protocol"
        },
        "packet_encoding": "xudp"
      }
    ]
  }
""";
