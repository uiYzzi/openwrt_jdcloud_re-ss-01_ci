#!/bin/bash
# SPDX-License-Identifier: MIT
# 通用运行时默认值（设备无关）。
# LAN IP / 主机名 / SSID / WiFi 密码统一由 Scripts/Settings.sh 依据 workflow 里的
# WRT_IP / WRT_NAME / WRT_SSID / WRT_WORD 写入，这里只补一个默认时区。
# 说明：本脚本由 Scripts/Packages.sh `source` 调用，务必要用 return 而不是 exit。

# 清理历史遗留的便携版 uci-defaults（早期版本创建，现已不用）
rm -f ./package/base-files/files/etc/uci-defaults/zzz-travelrouter

mkdir -p ./package/base-files/files/etc/uci-defaults
cat > ./package/base-files/files/etc/uci-defaults/zzz-custom <<'EOS'
#!/bin/sh
uci -q batch <<'UCI'
set system.@system[0].timezone='CST-8'
set system.@system[0].zonename='Asia/Shanghai'
commit system
UCI
exit 0
EOS
chmod +x ./package/base-files/files/etc/uci-defaults/zzz-custom
