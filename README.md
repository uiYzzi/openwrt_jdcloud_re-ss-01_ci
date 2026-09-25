# OpenWrt 云编译固件（JDCloud RE-SS-01 / ZN-M2）

基于 [VIKINGYFY/OpenWRT-CI](https://github.com/VIKINGYFY/OpenWRT-CI) 的 CI 框架，源码使用
[VIKINGYFY/immortalwrt](https://github.com/VIKINGYFY/immortalwrt)（`main`），为两台设备分别定制：

| 设备 | 定位 | 默认地址 | Wi-Fi | 主题 | 代理 |
|---|---|---|---|---|---|
| **JDCloud RE-SS-01**（亚瑟 AX1800 Pro） | 便携路由 | `10.10.20.1`（`TravelRouter`） | `TravelRouter` / `12345678` | aurora | **Nikki**（mihomo） |
| **ZN M2**（无 WiFi，NAND） | 家里主路由 | `10.10.10.1`（`ZN-M2`） | 无 | aurora | **Nikki**（mihomo） |

> 初始密码均为空，首次登录后请自行设置。

## 固件差异

**JDCloud RE-SS-01（便携版）**
- 代理：Nikki（mihomo 内核，原生支持 Clash 订阅，无需订阅转换）
- 上联：travelmate（公共 Wi-Fi 中继）、relayd
- 运维：watchcat（断网自愈）、ttyd（网页终端）、zram-swap
- 组网：Tailscale（`tailscale` + `luci-app-tailscale-community` + 中文 i18n）
- 基础：bash / tmux / nano / htop / unzip / zoneinfo-asia 等

**ZN M2（主路由版，无 WiFi）**
- **无 WiFi**：禁用 ath11k 驱动/固件，DTS 使用 nowifi 变体（纯有线路由）
- 只装 **Nikki**（mihomo）+ 多WAN 负载均衡 **mwan3** + 必要依赖

## 如何编译（仅手动）

Actions 里选对应工作流 → **Run workflow**：

- **Build-TravelRouter** → JDCloud RE-SS-01 便携版
- **Build-ZN-M2** → ZN-M2 主路由版

已关闭所有定时自动编译（`Auto-Clean` / `Cache-Clean` 也改为仅手动）。编译完成后在 **Releases** 下载。

## 如何刷入

**JDCloud RE-SS-01（eMMC）**：U-Boot 网页刷 `...-squashfs-factory.bin`

**ZN M2（NAND）**：U-Boot 网页刷 `...-squashfs-factory.ubi`

通用步骤：
1. 路由器断电，按住 `reset` 不放，插电，等指示灯变成稳定蓝灯后松手
2. 电脑网线接 LAN 口，静态 IP 设为 `192.168.1.10`
3. 无痕浏览器打开 `http://192.168.1.1`，上传对应 factory 文件
4. 刷完自动重启，按上面的默认地址访问

> 已在 OpenWrt/ImmortalWrt 上的设备，也可用 `...-squashfs-sysupgrade.bin` 升级。

## 代码结构

```
.github/workflows/
  ├─ Build-TravelRouter.yml   JDCloud RE-SS-01 便携版编译
  ├─ Build-ZN-M2.yml          ZN-M2 主路由版编译
  ├─ WRT-CORE.yml             公用编译核心
  ├─ Auto-Clean.yml           手动清理（已关定时）
  └─ Cache-Clean.yml          手动清缓存（已关定时）
Scripts/
  ├─ Settings.sh       CI 默认调整（主题/主机名/SSID、按机型引入私有配置）
  ├─ Packages.sh       第三方插件拉取（会自动 source PRIVATE.sh）
  ├─ Handles.sh        插件修补
  └─ PRIVATE.sh        按机型定制 LAN IP / 主机名 / SSID
Config/
  ├─ JDCloud-RE-SS-01.txt          设备选择（便携版）
  ├─ ZN-M2-WIFI-NO.txt             设备选择（ZN-M2，无 WiFi）
  ├─ PRIVATE-JDCloud-RE-SS-01.txt  便携版插件定制
  ├─ PRIVATE-ZN-M2-WIFI-NO.txt     主路由版插件定制（只 Nikki）
  └─ GENERAL.txt                   通用插件与内核选项
```

> 说明：`Settings.sh` 会优先读取 `Config/PRIVATE-<配置名>.txt`（按机型），不存在时回退到 `Config/PRIVATE.txt`。

## 致谢

- CI 框架与源码：[VIKINGYFY](https://github.com/VIKINGYFY)
- 上游：[ImmortalWrt](https://github.com/immortalwrt)
