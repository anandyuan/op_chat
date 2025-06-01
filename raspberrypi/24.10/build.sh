#!/bin/bash
# yml 传入的路由器型号 PROFILE
echo "Building for profile: $PROFILE"
echo "Include Docker: $INCLUDE_DOCKER"
# yml 传入的固件大小 ROOTFS_PARTSIZE
echo "Building for ROOTFS_PARTSIZE: $ROOTSIZE"

# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting build process..."

# 定义所需安装的包列表
PACKAGES=""

# 基础网络工具
PACKAGES="$PACKAGES curl wget"
PACKAGES="$PACKAGES luci-i18n-firewall-zh-cn"

# USB转RJ45网卡支持 (AX88179B)
# AX88179B芯片驱动支持
PACKAGES="$PACKAGES kmod-usb-net kmod-usb-net-asix-ax88179"
PACKAGES="$PACKAGES kmod-usb-core kmod-usb-ohci kmod-usb-uhci kmod-usb2 kmod-usb3"
# 网络相关内核模块
PACKAGES="$PACKAGES kmod-usb-net-cdc-ether kmod-usb-net-rndis"
PACKAGES="$PACKAGES kmod-tun"

# USB工具和调试工具
PACKAGES="$PACKAGES usbutils"  # 包含lsusb命令
PACKAGES="$PACKAGES pciutils"  # 包含lspci命令
PACKAGES="$PACKAGES lsblk block-mount"  # 磁盘管理工具

# 系统工具
PACKAGES="$PACKAGES htop iftop iotop"  # 系统监控工具
PACKAGES="$PACKAGES nano"  # 编辑器

# Shell增强
PACKAGES="$PACKAGES zsh"  # zsh shell
PACKAGES="$PACKAGES git git-http"  # Git工具 (oh-my-zsh需要)

# 网络工具
PACKAGES="$PACKAGES tcpdump "  # 网络调试工具
PACKAGES="$PACKAGES iperf3"  # 网络性能测试
PACKAGES="$PACKAGES mtr"  # 网络诊断工具

# VPN和网络服务
PACKAGES="$PACKAGES luci-app-zerotier"  # ZeroTier网络

# Web管理界面
PACKAGES="$PACKAGES luci-i18n-filebrowser-go-zh-cn"  # 文件浏览器
PACKAGES="$PACKAGES luci-app-argon-config luci-i18n-argon-config-zh-cn"  # Argon主题
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"  # 磁盘管理

# 24.10版本特有包
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"  # Web终端
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"

# iStore支持
PACKAGES="$PACKAGES fdisk script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"

# Python支持 (一些脚本可能需要)
PACKAGES="$PACKAGES python3 python3-pip"



# 其他常用工具
PACKAGES="$PACKAGES luci-app-wol"  # 网络唤醒
PACKAGES="$PACKAGES luci-app-alist luci-i18n-alist-zh-cn" # Alist文件管理
PACKAGES="$PACKAGES luci-app-lucky" # Lucky插件
PACKAGES="$PACKAGES luci-app-netdata" # Netdata监控

# PACKAGES="$PACKAGES luci-app-wrtbwmon" # 带宽监控
# PACKAGES="$PACKAGES luci-app-onliner" # 在线设备监控
#PACKAGES="$PACKAGES luci-app-store" # iStore应用商店




# 判断是否需要编译 Docker 插件
if [ "$INCLUDE_DOCKER" = "yes" ]; then
    PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
    PACKAGES="$PACKAGES docker docker-compose"
    echo "Adding Docker packages"
fi

# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTSIZE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
