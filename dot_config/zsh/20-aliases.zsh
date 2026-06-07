# 20-aliases.zsh — 别名

# --- 配置文件快捷编辑 ---
alias zshconf='$EDITOR $ZDOTDIR/.zshrc'
alias aliasconf='$EDITOR $ZDOTDIR/20-aliases.zsh'
alias zshdir='cd $ZDOTDIR'
# 跳到 chezmoi 源仓库(dotfiles 的工作基准)
alias dots='cd "$(chezmoi source-path)"'

# --- 现代化替代(仅在工具存在时生效)---
command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never'
# 不覆盖 grep(rg 与 grep 的 flag / 退出码语义不同),单独提供 rgg
command -v rg  >/dev/null 2>&1 && alias rgg='rg'
# eza 替代 ls / tree
if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --git'
  alias ll='eza -l --icons --git'
  alias la='eza -la --icons --git'
  alias tree='eza --tree --icons'
fi
