#!/bin/bash
# build_lucky.sh

set -e

echo "✅ 拉取 luci-app-lucky 源码..."
git clone https://github.com/gdy666/luci-app-lucky.git package/luci-app-lucky

echo "✅ 添加 luci-app-lucky 到默认编译配置..."
# 这里在 .config 里追加 CONFIG_PACKAGE_luci-app-lucky=y
# 如果有 feeds/packages 依赖，也可以在这里添加
echo "CONFIG_PACKAGE_luci-app-lucky=y" >> .config

echo "✅ 更新 feeds 并安装..."
./scripts/feeds update -a
./scripts/feeds install -a

echo "✅ 重新生成 .config..."
make defconfig

echo "✅ build_lucky.sh 完成，luci-app-lucky 会在固件里集成！"
