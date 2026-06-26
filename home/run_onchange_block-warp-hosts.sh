#!/bin/sh
# 阻断 Warp 云/遥测域名 app.warp.dev（合规：仅当终端用，物理切断回连）。
# Warp 官方：blocking app.warp.dev 即进入"离线"，核心终端功能不受影响；
# claude code 等 CLI 自己的网络不经此域名，不受影响。
# 幂等（已存在则跳过）；写入需 sudo。
set -eu

if grep -qF "app.warp.dev" /etc/hosts 2>/dev/null; then
    echo "/etc/hosts 已含 app.warp.dev，跳过"
    exit 0
fi

printf '\n# Warp 合规：阻断遥测/云回连（app.warp.dev）\n0.0.0.0 app.warp.dev\n:: app.warp.dev\n' \
    | sudo tee -a /etc/hosts >/dev/null
echo "已写入 /etc/hosts：app.warp.dev → 0.0.0.0 / ::"
