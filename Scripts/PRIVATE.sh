#!/bin/bash
# SPDX-License-Identifier: MIT
# Portable (TravelRouter) defaults for JDCloud RE-SS-01.
# Sourced by Scripts/Packages.sh, so it runs BEFORE Scripts/Settings.sh.
#   - LAN IP: patched into config_generate first; Settings.sh's
#     "192.168.x.x -> WRT_IP" substitution then finds no match and leaves ours.
#   - hostname / SSID / key: applied by a uci-defaults script at first boot,
#     which Settings.sh cannot override.

CFG_FILE="./package/base-files/files/bin/config_generate"
if [ -f "$CFG_FILE" ]; then
	sed -i "s/192\.168\.[0-9]\+\.[0-9]\+/10.10.20.1/g" "$CFG_FILE"
fi

mkdir -p ./package/base-files/files/etc/uci-defaults
cat > ./package/base-files/files/etc/uci-defaults/zzz-travelrouter <<'EOS'
#!/bin/sh
uci -q batch <<'UCI'
set system.@system[0].hostname='TravelRouter'
set system.@system[0].timezone='CST-8'
set system.@system[0].zonename='Asia/Shanghai'
commit system
UCI

uci -q set network.lan.ipaddr='10.10.20.1'
uci -q set network.lan.netmask='255.255.255.0'
uci -q commit network

for r in $(uci -q show wireless | sed -n "s/^wireless\.\([^.]*\)\.ssid=.*/\1/p"); do
	uci -q set wireless.$r.ssid='TravelRouter'
	uci -q set wireless.$r.encryption='psk2'
	uci -q set wireless.$r.key='12345678'
done
uci -q commit wireless

exit 0
EOS
chmod +x ./package/base-files/files/etc/uci-defaults/zzz-travelrouter
