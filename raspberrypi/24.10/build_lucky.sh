#!/bin/bash
# build_lucky.sh

set -e
mkdir lucky
echo "✅ 克隆 lucky 仓库..."
git clone https://github.com/gdy666/luci-app-lucky.git luci-app-lucky

echo "✅ 复制 luci-app-lucky 和 lucky 到 package/..."
cp -r luci-app-lucky/lucky package/lucky
cp -r luci-app-lucky/luci-app-lucky package/luci-app-lucky

echo "✅ 添加 luci-app-lucky 到默认编译配置..."
echo "CONFIG_PACKAGE_lucky=y" >> .config
echo "CONFIG_PACKAGE_luci-app-lucky=y" >> .config

echo "✅ 更新 feeds 并安装..."
./scripts/feeds update -a
./scripts/feeds install -a

echo "✅ 重新生成 .config..."
make defconfig

echo "✅ build_lucky.sh 执行完成！"
