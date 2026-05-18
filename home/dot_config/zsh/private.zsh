# 私有配置（chezmoi 模板渲染；不提交明文敏感数据到 git）

# ── 代理（按需取消注释或修改地址）──────────────────────────
# export PROXY_ADDR="http://127.0.0.1:7897"
# setproxy   # 启动时自动开启代理

# ── GOPROXY（可按网络环境切换）──────────────────────────────
# 全球网络：
# export GOPROXY="https://goproxy.io,direct"
# 中国大陆：
# export GOPROXY="https://goproxy.cn,direct"
export GOPROXY="https://proxy.golang.com.cn,direct"

# ── Go 私有仓库（自建 GitLab 等）───────────────────────────
# export GOPRIVATE="gitlab.company.com,gitee.com/your-org"

# ── AWS 默认 Profile ─────────────────────────────────────────
# export AWS_PROFILE="personal"
# export AWS_DEFAULT_REGION="ap-east-1"

# ── npm Registry ─────────────────────────────────────────────
# export NPM_CONFIG_REGISTRY="https://registry.npmmirror.com"

# ── 其他私有环境变量 ─────────────────────────────────────────
# export MY_API_KEY="..."  # 建议用 aws-vault / 1password-cli 管理
