# 50-plugins.zsh — 提示符与插件(顺序敏感)
#
# 跨平台:macOS 插件由 brew 装在 /opt/homebrew/share;Linux(无 brew 的远程机)
# 由 git clone 到 ~/.local/share/zsh/plugins/<name>。下面按候选路径探测,先命中先用。

# 在多个候选目录里找到第一个可读文件并 source(找不到静默跳过)
_zplug_source() {
  local f
  for f in "$@"; do
    [[ -r "$f" ]] && { source "$f"; return 0; }
  done
  return 1
}

# --- 提示符:powerlevel10k ---
_zplug_source \
  /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme \
  "$HOME/.local/share/zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme" \
  /usr/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# --- autosuggestions ---
_zplug_source \
  /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  "$HOME/.local/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- syntax-highlighting(必须在所有 widget 定义之后,放最后一行)---
_zplug_source \
  /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  "$HOME/.local/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
