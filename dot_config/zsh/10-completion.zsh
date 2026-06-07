# 10-completion.zsh — 补全系统初始化

autoload -Uz compinit
_compdump="${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump-${ZSH_VERSION}"

# dump 超过 24h 才做完整安全检查;否则用 -C 跳过,启动快几百毫秒
if [[ -n "$_compdump"(#qN.mh+24) ]]; then
  compinit -d "$_compdump"
else
  compinit -C -d "$_compdump"
fi
