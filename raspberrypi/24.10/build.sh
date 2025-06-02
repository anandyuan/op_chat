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
PACKAGES="$PACKAGES kmod-usb-net-asix-ax88179"
PACKAGES="$PACKAGES kmod-usb-core kmod-usb-ohci kmod-usb-uhci kmod-usb2 kmod-usb3"
PACKAGES="$PACKAGES kmod-usb-net-cdc-ether kmod-usb-net-rndis"
PACKAGES="$PACKAGES kmod-tun"

# 硬件支持
# 无线网卡和USB网卡驱动支持
PACKAGES="$PACKAGES kmod-rtl8187"
PACKAGES="$PACKAGES kmod-rtl8188eu"
PACKAGES="$PACKAGES kmod-rtl8192c-common"
PACKAGES="$PACKAGES kmod-rtl8192cu"
PACKAGES="$PACKAGES kmod-rtl8192du"
PACKAGES="$PACKAGES kmod-rtl8812au-ac"
PACKAGES="$PACKAGES kmod-rtl8821cu"
PACKAGES="$PACKAGES kmod-rtl88x2bu"
PACKAGES="$PACKAGES kmod-rtlwifi"
PACKAGES="$PACKAGES kmod-rtlwifi-usb"
PACKAGES="$PACKAGES kmod-usb-net-rtl8150"
PACKAGES="$PACKAGES kmod-usb-net-rtl8152"

# 增加更多 USB 网卡和网络相关驱动支持
PACKAGES="$PACKAGES kmod-inet-diag"
PACKAGES="$PACKAGES kmod-usb-net-asix"
PACKAGES="$PACKAGES kmod-usb-net-cdc-eem"
PACKAGES="$PACKAGES kmod-usb-net-cdc-mbim"
PACKAGES="$PACKAGES kmod-usb-net-cdc-ncm"
PACKAGES="$PACKAGES kmod-usb-net-cdc-subset"
PACKAGES="$PACKAGES kmod-usb-net-dm9601-ether"
PACKAGES="$PACKAGES kmod-usb-net-hso"
PACKAGES="$PACKAGES kmod-usb-net-huawei-cdc-ncm"
PACKAGES="$PACKAGES kmod-usb-net-ipheth"
PACKAGES="$PACKAGES kmod-usb-net-kalmia"
PACKAGES="$PACKAGES kmod-usb-net-kaweth"
PACKAGES="$PACKAGES kmod-usb-net-mcs7830"
PACKAGES="$PACKAGES kmod-usb-net-pegasus"
PACKAGES="$PACKAGES kmod-usb-net-pl"
PACKAGES="$PACKAGES kmod-usb-net-qmi-wwan"
PACKAGES="$PACKAGES kmod-usb-net-sierrawireless"
PACKAGES="$PACKAGES kmod-usb-net-smsc95xx"
PACKAGES="$PACKAGES kmod-usb-net-sr9700"
PACKAGES="$PACKAGES kmod-usb-net2280"

# USB工具和调试工具
PACKAGES="$PACKAGES usbutils"
PACKAGES="$PACKAGES pciutils"
PACKAGES="$PACKAGES lsblk block-mount"

# 系统工具
PACKAGES="$PACKAGES nano"

# Shell增强
PACKAGES="$PACKAGES zsh"
PACKAGES="$PACKAGES git git-http"

# 网络工具
PACKAGES="$PACKAGES tcpdump"
PACKAGES="$PACKAGES iperf3"
PACKAGES="$PACKAGES mtr"

# VPN和网络服务
PACKAGES="$PACKAGES luci-app-zerotier"

# Web管理界面
PACKAGES="$PACKAGES luci-i18n-filebrowser-go-zh-cn"
PACKAGES="$PACKAGES luci-app-argon-config luci-i18n-argon-config-zh-cn"
PACKAGES="$PACKAGES luci-i18n-diskman-zh-cn"

# 24.10版本特有包
PACKAGES="$PACKAGES luci-i18n-package-manager-zh-cn"
PACKAGES="$PACKAGES luci-i18n-ttyd-zh-cn"
PACKAGES="$PACKAGES luci-app-openclash"
PACKAGES="$PACKAGES luci-i18n-homeproxy-zh-cn"
PACKAGES="$PACKAGES openssh-sftp-server"

# iStore支持
PACKAGES="$PACKAGES fdisk script-utils"
PACKAGES="$PACKAGES luci-i18n-samba4-zh-cn"

# Python支持
PACKAGES="$PACKAGES python3 python3-pip"

# 其他常用工具
PACKAGES="$PACKAGES luci-app-wol"
PACKAGES="$PACKAGES luci-app-alist luci-i18n-alist-zh-cn"
PACKAGES="$PACKAGES luci-app-netdata"



# 新增
PACKAGES="$PACKAGES luci-app-eqos"
PACKAGES="$PACKAGES luci-app-gowebdav"
PACKAGES="$PACKAGES luci-app-openvpn-server"
PACKAGES="$PACKAGES luci-app-samba"

# 判断是否需要编译 Docker 插件
if [ "$INCLUDE_DOCKER" = "yes" ]; then
    PACKAGES="$PACKAGES luci-i18n-dockerman-zh-cn"
    PACKAGES="$PACKAGES docker docker-compose"
    echo "Adding Docker packages"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

make image PROFILE=$PROFILE PACKAGES="$PACKAGES" FILES="/home/build/immortalwrt/files" ROOTFS_PARTSIZE=$ROOTSIZE

if [ $? -ne 0 ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Error: Build failed!"
    exit 1
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."
