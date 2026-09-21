#!/bin/bash
# SPDX-License-Identifier: MIT
# Portable (TravelRouter) defaults for JDCloud RE-SS-01.
# Sourced by Scripts/Packages.sh, so it runs BEFORE Scripts/Settings.sh.

# ---------------------------------------------------------------------------
# 1) Keep the stock OpenWrt "bootstrap" theme.
#    The workflow pins WRT_THEME=aurora, which we cannot change from here
#    (workflow files need the GitHub "workflow" token scope). Patch the CI's
#    Settings.sh so it keeps luci-theme-bootstrap and skips the aurora config app.
# ---------------------------------------------------------------------------
SETTINGS="$GITHUB_WORKSPACE/Scripts/Settings.sh"
if [ -f "$SETTINGS" ]; then
	sed -i 's/luci-theme-\$WRT_THEME/luci-theme-bootstrap/g' "$SETTINGS"
	sed -i '/luci-app-\$WRT_THEME-config/d' "$SETTINGS"
fi

# ---------------------------------------------------------------------------
# 2) Default LAN IP -> 10.10.20.1
#    Patched into config_generate first, so Settings.sh's
#    "192.168.x.x -> WRT_IP" substitution finds no match and leaves ours.
# ---------------------------------------------------------------------------
CFG_FILE="./package/base-files/files/bin/config_generate"
if [ -f "$CFG_FILE" ]; then
	sed -i "s/192\.168\.[0-9]\+\.[0-9]\+/10.10.20.1/g" "$CFG_FILE"
fi

# ---------------------------------------------------------------------------
# 3) Runtime defaults (hostname / SSID / key / theme) via uci-defaults,
#    which Settings.sh cannot override.
# ---------------------------------------------------------------------------
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

uci -q set luci.main.mediaurlbase='/luci-static/bootstrap'
uci -q commit luci

exit 0
EOS
chmod +x ./package/base-files/files/etc/uci-defaults/zzz-travelrouter
