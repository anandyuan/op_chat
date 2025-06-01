#!/bin/bash
# Feeds准备脚本 - 添加第三方软件包源

echo "$(date '+%Y-%m-%d %H:%M:%S') - Preparing third-party feeds..."

# 进入构建目录
cd /home/build/immortalwrt

# 备份原始feeds配置
cp feeds.conf.default feeds.conf.default.bak

# 添加第三方feeds源到feeds.conf.default
echo "# Third-party feeds" >> feeds.conf.default

# 添加常用的第三方软件源
echo "src-git kenzo https://github.com/kenzok8/openwrt-packages" >> feeds.conf.default
echo "src-git small https://github.com/kenzok8/small" >> feeds.conf.default

# 如果有lucky相关包
if [ "$INCLUDE_LUCKY" = "yes" ] && [ -d "/home/build/third-party-packages/luci-app-lucky" ]; then
    echo "Adding Lucky packages to feeds..."
    
    # 创建本地feed目录
    mkdir -p package/custom-feeds
    
    # 复制lucky相关包
    cp -r /home/build/third-party-packages/luci-app-lucky package/custom-feeds/
    
    # 如果有lucky核心程序
    if [ -d "/home/build/third-party-packages/lucky" ]; then
        cp -r /home/build/third-party-packages/lucky package/custom-feeds/
    fi
    
    echo "Lucky packages added to custom feeds"
fi

# 更新feeds
echo "Updating feeds..."
./scripts/feeds update -a

# 安装所有可用的包
echo "Installing feeds packages..."
./scripts/feeds install -a

# 安装lucky相关包（如果存在）
if [ "$INCLUDE_LUCKY" = "yes" ]; then
    echo "Installing Lucky packages..."
    # 尝试从feeds安装
    ./scripts/feeds install luci-app-lucky 2>/dev/null || echo "luci-app-lucky not found in feeds, using local copy"
    ./scripts/feeds install lucky 2>/dev/null || echo "lucky not found in feeds, using local copy"
fi

# 检查可用的包
echo "Available third-party packages:"
./scripts/feeds search luci-app-lucky || echo "luci-app-lucky not found in feeds"
./scripts/feeds search lucky || echo "lucky not found in feeds"

# 列出自定义包
if [ -d "package/custom-feeds" ]; then
    echo "Custom packages added:"
    ls -la package/custom-feeds/
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Feeds preparation completed."
