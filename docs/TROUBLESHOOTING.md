# 故障排查

## chezmoi

**验证环境**：
```bash
chezmoi doctor
```

**预览变更（不执行）**：
```bash
chezmoi diff
```

**源文件路径**：
```bash
chezmoi source-path ~/.zshrc    # 查找某个文件的 chezmoi 源路径
chezmoi edit ~/.zshrc            # 直接编辑源文件
```

## Powerlevel10k

**instant prompt 警告（console output during zsh initialization）**：
某个工具在 p10k instant prompt 初始化后产生了输出。检查 `.zshrc` 里 instant prompt 之后是否有会输出内容的命令，将其移到 `source ~/.p10k.zsh` 之后，或用 `>/dev/null 2>&1` 抑制输出。

**提示符样式重置**：
```bash
p10k configure   # 重新运行配置向导
```

**手动修改配置后立即生效**：
```bash
source ~/.p10k.zsh
```

## Zsh 启动慢

```bash
# 计时
hyperfine --warmup 3 'zsh -i -c exit'

# 详细分析（找到耗时插件）
zsh -i -c 'zprof; exit'
```

目标：< 250ms。若超时，检查 `plugins.zsh` 里是否有慢插件未走 `kind:defer`（antidote 延迟加载标注）。

## mise 问题

```bash
mise doctor      # 检查环境
mise ls          # 查看已安装版本
mise which node  # 查看当前使用的 node 路径

# 重置某语言
mise uninstall node --all
mise install node@lts
```

**与 nvm / pyenv 冲突**：确保 `.zshrc` 里没有 `nvm` / `pyenv init` 初始化行。mise activate 会接管 shims。

## Git SSH 签名

**签名验证失败**：
```bash
# 检查 allowed_signers 格式（邮箱必须与 user.email 匹配）
cat ~/.config/git/allowed_signers

# 手动验证
echo "test" | ssh-keygen -Y sign -f ~/.ssh/id_ed25519 -n file
```

**GitHub 显示 Unverified**：
1. Settings → SSH and GPG keys → New SSH key
2. Key type 选 **Signing Key**
3. 粘贴 `~/.ssh/id_ed25519.pub` 内容

## Tmux

**颜色异常**：确保 `TERM=xterm-256color`，或在 tmux.conf 确认 `set -ga terminal-overrides ",*256col*:Tc"`。

## Neovim

**LSP 未启动**：
```bash
:LspInfo          # 查看当前 buffer 附加的 LSP
:Mason            # 管理 LSP 服务器
:checkhealth lsp  # 健康检查
```

**启动时间**：
```bash
nvim --startuptime /tmp/nvim-startup.log +qa
sort -k2 -rn /tmp/nvim-startup.log | head -20
```

**插件更新**：
```bash
:Lazy update
:Lazy clean    # 清理未使用插件
```

## Docker / OrbStack

**OrbStack 与 Docker Desktop 冲突**：
```bash
# 确认只有 OrbStack 管理 Docker socket
ls -la /var/run/docker.sock
docker context ls
```
