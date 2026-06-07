# 30-functions.zsh — 自定义函数

# --- 重启 GUI LaunchAgent ---
lcrestart() {
  local name="$1"
  local plist="$HOME/Library/LaunchAgents/${name}.plist"
  launchctl bootout    gui/$(id -u) "$plist" 2>/dev/null
  launchctl bootstrap  gui/$(id -u) "$plist"
}

# --- mkdir + cd ---
mkcd() { mkdir -p "$1" && cd "$1"; }

# --- 查看端口占用 ---
port() { lsof -nP -iTCP:"$1" -sTCP:LISTEN; }
