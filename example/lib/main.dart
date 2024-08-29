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

  Future refresh() async {
    started = await FlutterSbox.serviceStarted();
    setState(() {});
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
                  await FlutterSbox.setConfigJson(configJson);
                  await FlutterSbox.start();
                },
              ),
              TextButton(
                child: const Text("Stop"),
                onPressed: () async {
                  await FlutterSbox.stop();
                },
              ),
              Text('Current: ${started ? "started" : "stopped"}'),
              TextButton(
                child: const Text("Refresh"),
                onPressed: () async {
                  await refresh();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const configJson = """
{
    "outbounds": [
      {
        "type": "vless",
        "tag": "vless-in",
        "server": "your.server.com",
        "server_port": 443,
        "uuid": "85c4c766-3021-4e6e-a344-7d94baa391c6",
        "tls": {
          "enabled": true,
          "server_name": "your.server.com",
          "utls": {
            "enabled": true,
            "fingerprint": "chrome"
          }
        },
        "transport": {
          "type": "ws",
          "path": "/aaf18b23f0c3/",
          "early_data_header_name": "Sec-WebSocket-Protocol"
        },
        "packet_encoding": "xudp"
      }
    ]
  }
""";
