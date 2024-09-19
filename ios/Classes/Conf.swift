//
//  Conf.swift
//  flutter_sbox
//
//  Created by local on 2024/9/10.
//

let defaultOptionJson = """
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
"""

let defaultConfigJson = """
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
"""

let defaultAllJson = """
{
  "log": {
    "level": "warn",
    "output": "box.log",
    "timestamp": true
  },
  "dns": {
    "servers": [
      {
        "tag": "dns-remote",
        "address": "udp://1.1.1.1",
        "address_resolver": "dns-direct"
      },
      {
        "tag": "dns-trick-direct",
        "address": "https://sky.rethinkdns.com/",
        "detour": "direct-fragment"
      },
      {
        "tag": "dns-direct",
        "address": "223.5.5.5",
        "address_resolver": "dns-local",
        "detour": "direct"
      },
      {
        "tag": "dns-local",
        "address": "local",
        "detour": "direct"
      },
      {
        "tag": "dns-block",
        "address": "rcode://success"
      }
    ],
    "rules": [
      {
        "domain": "your.server.com",
        "server": "dns-direct"
      },
      {
        "domain": "connectivitycheck.gstatic.com",
        "server": "dns-remote",
        "rewrite_ttl": 3000
      },
      {
        "domain_suffix": ".cn",
        "server": "dns-direct"
      },
      {
        "rule_set": [
          "geoip-cn",
          "geosite-cn"
        ],
        "server": "dns-direct"
      }
    ],
    "final": "dns-remote",
    "static_ips": {
      "sky.rethinkdns.com": [
        "104.17.148.22",
        "104.17.147.22",
        "104.21.83.62",
        "172.67.214.246",
        "2606:4700:3030::ac43:d6f6",
        "2606:4700:3030::6815:533e"
      ]
    },
    "independent_cache": true
  },
  "inbounds": [
    {
      "type": "tun",
      "tag": "tun-in",
      "mtu": 9000,
      "inet4_address": "172.19.0.1/28",
      "auto_route": true,
      "strict_route": true,
      "endpoint_independent_nat": true,
      "stack": "mixed",
      "sniff": true,
      "sniff_override_destination": true
    },
    {
      "type": "mixed",
      "tag": "mixed-in",
      "listen": "127.0.0.1",
      "listen_port": 12334,
      "sniff": true,
      "sniff_override_destination": true
    },
    {
      "type": "direct",
      "tag": "dns-in",
      "listen": "127.0.0.1",
      "listen_port": 16450
    }
  ],
  "outbounds": [
    {
      "type": "selector",
      "tag": "select",
      "outbounds": [
        "auto",
        "vless-in"
      ],
      "default": "auto"
    },
    {
      "type": "urltest",
      "tag": "auto",
      "outbounds": [
        "vless-in"
      ],
      "url": "http://connectivitycheck.gstatic.com/generate_204",
      "interval": "10m0s",
      "tolerance": 1,
      "idle_timeout": "30m0s"
    },
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
    },
    {
      "type": "dns",
      "tag": "dns-out"
    },
    {
      "type": "direct",
      "tag": "direct"
    },
    {
      "type": "direct",
      "tag": "direct-fragment",
      "tls_fragment": {
        "enabled": true,
        "size": "10-30",
        "sleep": "2-8"
      }
    },
    {
      "type": "direct",
      "tag": "bypass"
    },
    {
      "type": "block",
      "tag": "block"
    }
  ],
  "route": {
    "rules": [
      {
        "inbound": "dns-in",
        "outbound": "dns-out"
      },
      {
        "port": 53,
        "outbound": "dns-out"
      },
      {
        "process_name": [
          "Hiddify",
          "Hiddify.exe",
          "HiddifyCli",
          "HiddifyCli.exe"
        ],
        "outbound": "bypass"
      },
      {
        "domain_suffix": ".cn",
        "outbound": "direct"
      },
      {
        "rule_set": [
          "geoip-cn",
          "geosite-cn"
        ],
        "outbound": "direct"
      }
    ],
    "rule_set": [
      {
        "type": "remote",
        "tag": "geoip-cn",
        "format": "binary",
        "url": "https://raw.githubusercontent.com/hiddify/hiddify-geo/rule-set/country/geoip-cn.srs",
        "update_interval": "120h0m0s"
      },
      {
        "type": "remote",
        "tag": "geosite-cn",
        "format": "binary",
        "url": "https://raw.githubusercontent.com/hiddify/hiddify-geo/rule-set/country/geosite-cn.srs",
        "update_interval": "120h0m0s"
      }
    ],
    "final": "select",
    "auto_detect_interface": true,
    "override_android_vpn": true
  },
  "experimental": {
    "cache_file": {
      "enabled": true,
      "path": "clash.db"
    },
    "clash_api": {
      "external_controller": "127.0.0.1:16756",
      "secret": "cVuzmvdx9UPnzoeo"
    }
  }
}
"""
