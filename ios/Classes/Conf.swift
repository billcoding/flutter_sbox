//
//  Conf.swift
//  flutter_sbox
//
//  Created by local on 2024/9/8.
//

class Conf {
    public static let defaultOptionJson  = """
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
}
