# 安装指南

## 快速开始（新机）

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply shenyuchao
```

首次运行会询问：
| 字段 | 说明 | 示例 |
|---|---|---|
| `name` | 姓名 | `Zhang San` |
| `email` | 邮箱 | `zhangsan@gmail.com` |

## 分步安装

```bash
# 1. 克隆仓库
git clone https://github.com/shenyuchao/dotfiles ~/.dotfiles

# 2. 安装 Homebrew（若未安装）
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. 安装 Homebrew 包（含 chezmoi、mise 等）
brew bundle --file=~/.dotfiles/Brewfile

# 4. 初始化 chezmoi（指向本地仓库）
chezmoi init --source ~/.dotfiles

# 5. 预览变更
chezmoi diff

# 6. 应用
chezmoi apply

# 7. 安装语言运行时
mise install
```

## SSH 签名设置

```bash
# 1. 生成 SSH key（若已有可跳过）
ssh-keygen -t ed25519 -C "your@email.com"

# 2. 把公钥复制到剪贴板
cat ~/.ssh/id_ed25519.pub | pbcopy

# 3. 在 GitHub Settings → SSH keys → New SSH key
#    Key type 选 "Signing Key"（同时作为 Authentication 和 Signing）

# 4. 更新 allowed_signers（把公钥内容替换占位符）
#    文件位于 ~/.config/git/allowed_signers，格式：<email> ssh-ed25519 <pubkey>
chezmoi edit ~/.config/git/allowed_signers

# 5. 验证签名
git -C /tmp commit --allow-empty -m "test" 2>/dev/null || git init /tmp/test-sign
cd /tmp/test-sign && git commit --allow-empty -m "test sign"
git log --show-signature   # 应显示 Good signature
```

## 常见问题

**chezmoi apply 报冲突**：
```bash
chezmoi merge ~/.zshrc   # 交互式三方合并
# 或直接覆盖
chezmoi apply --force
```

**mise 与 nvm/pyenv 冲突**：
```bash
# 从 ~/.zshrc 或 ~/.bashrc 移除 nvm/pyenv 初始化行
# mise 接管后导入旧版本
mise install node@18   # 安装特定版本
```

## AI 编码工具

通过 `chezmoi apply` 自动安装（Brewfile 管理）：Claude Desktop App、Codex CLI、Kiro IDE、Kiro CLI、Cursor IDE。

以下工具需手动安装，各自有自更新机制：

- **Claude Code CLI**：`curl -fsSL https://claude.ai/install.sh | sh`，之后 `claude update` 升级
- **cursor-agent**：打开 Cursor → 命令面板 → `Install cursor-agent`

---

## 验证安装

安装完成后，运行以下命令验证关键组件：

### Powerlevel10k
```bash
# 确认 p10k 已加载
p10k version

# 如需重新配置提示符样式
p10k configure
```

### Shell 性能
```bash
# 冷启动时间（目标 < 500ms）
hyperfine --warmup 3 'zsh -i -c exit'
```

### Neovim 性能
```bash
# 冷启动时间（目标 < 80ms）
hyperfine --warmup 3 'nvim --headless +qa'
```

### 语言运行时
```bash
# 验证 mise 管理的工具版本
mise ls
```

### Git 配置
```bash
# 验证 delta 集成
git log --oneline -5
```
