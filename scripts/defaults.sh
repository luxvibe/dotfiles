#!/usr/bin/env bash
# macOS 系统设置一键配置
# 每条均有注释；不需要的项可直接注释掉
[[ "$(uname -s)" == "Darwin" ]] || { echo "仅适用于 macOS"; exit 0; }

set -euo pipefail

echo "应用 macOS 系统设置..."

# ── Dock ────────────────────────────────────────────────────
defaults write com.apple.dock autohide              -bool true
defaults write com.apple.dock autohide-delay        -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock tilesize              -int 42
defaults write com.apple.dock mru-spaces            -bool false   # 不按最近使用排列 Space
defaults write com.apple.dock show-recents          -bool false   # 隐藏最近使用应用区
defaults write com.apple.dock minimize-to-application -bool true  # 最小化到程序坞图标

# ── Finder ──────────────────────────────────────────────────
defaults write com.apple.finder AppleShowAllFiles   -bool true    # 显示隐藏文件
defaults write NSGlobalDomain AppleShowAllExtensions -bool true   # 显示所有扩展名
defaults write com.apple.finder ShowPathbar         -bool true    # 显示路径栏
defaults write com.apple.finder ShowStatusBar       -bool true    # 显示状态栏
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # 列表视图
defaults write com.apple.finder _FXSortFoldersFirst -bool true   # 文件夹排在前面
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # 搜索当前目录
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true # 不在网络盘写 .DS_Store
defaults write com.apple.desktopservices DSDontWriteUSBStores    -bool true # 不在 USB 盘写 .DS_Store

# ── 键盘 ────────────────────────────────────────────────────
defaults write NSGlobalDomain KeyRepeat            -int 2     # 最快按键重复速率
defaults write NSGlobalDomain InitialKeyRepeat     -int 15    # 短延迟后开始重复
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false  # 长按输出重复字符
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled  -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled      -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled    -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled   -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled  -bool false

# ── 触控板 ──────────────────────────────────────────────────
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true  # 轻触点击
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false  # 自然滚动（关）

# ── 截图 ────────────────────────────────────────────────────
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location    -string "$HOME/Screenshots"
defaults write com.apple.screencapture type        -string "png"
defaults write com.apple.screencapture disable-shadow -bool true  # 截图去掉窗口阴影

# ── 安全 / 杂项 ─────────────────────────────────────────────
defaults write com.apple.LaunchServices LSQuarantine -bool false  # 关闭"来自互联网"提示
defaults write -g NSWindowResizeTime              -float 0.001  # 窗口缩放动画加速
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode  -bool true  # 保存面板默认展开
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint     -bool true  # 打印面板默认展开
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2    -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false   # 默认保存到磁盘而非 iCloud

# ── Finder 补充 ──────────────────────────────────────────────
defaults write com.apple.finder QuitMenuItem -bool true                    # 允许 ⌘+Q 退出 Finder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false # 修改扩展名不弹警告
chflags nohidden ~/Library                                                  # 显示 ~/Library 文件夹

# ── 软件更新 ─────────────────────────────────────────────────
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true   # 启用自动检查
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1           # 每天检查（默认每周）

# ── 外设 ─────────────────────────────────────────────────────
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true  # 插入设备不自动打开 Photos

# ── Chrome ───────────────────────────────────────────────────
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false  # 禁用触控板后退手势（防误触）

# ── Rectangle（窗口管理）────────────────────────────────────
defaults write com.knollsoft.Rectangle launchOnLogin        -bool true   # 登录时自动启动
defaults write com.knollsoft.Rectangle hideMenubarIcon      -bool false  # 显示菜单栏图标
defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 2    # 重复快捷键循环尺寸
defaults write com.knollsoft.Rectangle gapSize              -float 0     # 窗口间距（0 = 无间距）
defaults write com.knollsoft.Rectangle snapEdgeMarginTop    -int 5       # 拖拽吸附边距
defaults write com.knollsoft.Rectangle snapEdgeMarginBottom -int 5
defaults write com.knollsoft.Rectangle snapEdgeMarginLeft   -int 5
defaults write com.knollsoft.Rectangle snapEdgeMarginRight  -int 5

# ── 重启受影响进程 ──────────────────────────────────────────
for app in Dock Finder SystemUIServer; do
    killall "$app" 2>/dev/null || true
done

echo "macOS 系统设置应用完成 ✓"
