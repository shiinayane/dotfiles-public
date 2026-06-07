# 40-lang.zsh — 语言运行时 / 版本管理

# --- mise(统一版本管理,取代 pyenv / fnm / nvm / rbenv)---
# 用 shims 模式(把 shims 目录加进 PATH)而非 `mise activate`:后者注册 precmd
# hook,每条命令都跑 → command_lag 实测 +12ms。shims 零每命令开销(zsh-bench 实测
# command_lag 21.9ms→9.6ms)。代价:新装全局工具偶尔需 `mise reshim`(2026.x 多自动);
# 不支持 mise [env] 自动环境变量——但本机 config 只有版本号,不受影响。
# 切换/调试运行时若需即时生效,临时 `eval "$(mise activate zsh)"` 即可。
command -v mise >/dev/null 2>&1 && eval "$(mise activate zsh --shims)"

# --- uv / uvx 补全(动态生成,始终与已装版本同步)---
command -v uv  >/dev/null 2>&1 && eval "$(uv generate-shell-completion zsh)"
command -v uvx >/dev/null 2>&1 && eval "$(uvx --generate-shell-completion zsh)"
