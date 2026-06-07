# 35-tools.zsh — CLI 工具集成

# --- zoxide(智能 cd)---
export _ZO_EXCLUDE_DIRS="/tmp:/var:/proc:/sys:*/node_modules/*:*/.git/*"
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# --- fzf(Ctrl-R 历史搜索 / Ctrl-T 文件 / **<Tab> 补全)---
# 用 fd 作后端:尊重 .gitignore、跳过 .git/node_modules,比系统 find 快得多
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
fi
command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)
