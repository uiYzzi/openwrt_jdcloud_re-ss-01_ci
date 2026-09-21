# JDCloud RE-SS-01 便携路由固件（云编译）

京东云 RE-SS-01（亚瑟 AX1800 Pro，IPQ6000 / qualcommax / ipq60xx）专用 OpenWrt 固件的云编译仓库。

基于 [VIKINGYFY/OpenWRT-CI](https://github.com/VIKINGYFY/OpenWRT-CI) 的 CI 框架，源码使用
[VIKINGYFY/immortalwrt](https://github.com/VIKINGYFY/immortalwrt)（`main`），**只编译本机型**
（`jdcloud_re-ss-01`）一个配置。

## 固件特性

| 项目 | 说明 |
|---|---|
| 设备 | JDCloud RE-SS-01 / 亚瑟 AX1800 Pro |
| 平台 | qualcommax / ipq60xx |
| 主题 | luci-theme-aurora |
| 代理 | **HomeProxy**（底层 sing-box，**内置 Tailscale endpoint**） |
| 上联 | travelmate（公共 Wi-Fi 中继）、relayd |
| 运维 | watchcat（断网自愈）、ttyd（网页终端）、zram-swap |
| 其他 | bash / tmux / nano / htop / unzip / zoneinfo-asia 等基础工具 |

> 不再单独安装 `tailscale` 包：HomeProxy 的 sing-box 已内置 Tailscale（`with_tailscale`），
> 可在 HomeProxy 里配置，兼顾代理与内网组网。

## 默认参数

| 项目 | 值 |
|---|---|
| 管理地址 | `http://10.10.20.1`（主机名 `TravelRouter`） |
| Wi-Fi 名称 | `TravelRouter` |
| Wi-Fi 密码 | `12345678` |
| 初始密码 | 无（首次登录后请自行设置） |

## 如何编译

- **仅手动**：Actions → **JDCloud-RE-SS-01** → Run workflow
- 不设任何定时自动编译（`Auto-Clean` / `Cache-Clean` 也已改为仅手动）
- 编译完成后在 **Releases** 里下载对应固件包

## 如何刷入

本机型推荐用 **U-Boot 网页刷机**：

1. 路由器断电，按住 `reset` 不放，插电，等指示灯变成**稳定蓝灯**后松手
2. 电脑网线接 LAN 口，静态 IP 设为 `192.168.1.10`
3. 无痕浏览器打开 `http://192.168.1.1`，上传
   `...-squashfs-factory.bin`
4. 等待刷写完成自动重启，之后访问 `http://10.10.20.1`

> 若当前已在 OpenWrt/ImmortalWrt 上，也可用 `...-squashfs-sysupgrade.bin` 升级；
> 跨固件体系（如 iStoreOS/QWRT）时请用 U-Boot 刷 `factory.bin`。

## 目录结构

```
.github/workflows/   自定义 CI
  ├─ JDCloud-RE-SS-01 (QCA-ALL.yml)   本机型编译流程
  ├─ WRT-CORE.yml                     公用编译核心
  ├─ Auto-Clean.yml                   每月清理并触发编译
  └─ Cache-Clean.yml                  每周清理缓存
Scripts/             自定义脚本
  ├─ Settings.sh       CI 默认调整（主题/主机名/SSID 等）
  ├─ Packages.sh       第三方插件拉取
  ├─ Handles.sh        插件修补
  └─ PRIVATE.sh        本机型定制（LAN IP / 主机名 / SSID）
Config/              自定义配置
  ├─ JDCloud-RE-SS-01.txt   目标平台与设备
  ├─ GENERAL.txt            通用插件与内核选项
  └─ PRIVATE.txt            便携路由定制插件
```

## 致谢

- CI 框架与源码：[VIKINGYFY](https://github.com/VIKINGYFY)
- 上游：[ImmortalWrt](https://github.com/immortalwrt)
