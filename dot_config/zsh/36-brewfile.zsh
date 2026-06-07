# 36-brewfile.zsh — Brewfile 漂移检查(保持手动策展,消除"装完忘了加")
#
# 工作流:随便 brew install → 偶尔 `brewfile-drift` 看漂移
#         → `brewfile-edit` 把要留的补进对应分区 → chezmoi cd && git commit
# Brewfile 是 chezmoi 模板,位于源目录 .chezmoitemplates/Brewfile。

# 源 Brewfile 的绝对路径(延迟解析,不在 shell 启动时调用 chezmoi)
_brewfile_path() {
  local src
  src=$(command chezmoi source-path 2>/dev/null) || src="$HOME/.local/share/chezmoi"
  print -r -- "$src/.chezmoitemplates/Brewfile"
}

# 渲染 Brewfile(它是模板)到 stdout
_brewfile_render() {
  if command -v chezmoi >/dev/null 2>&1; then
    chezmoi execute-template < "$1"
  else
    cat "$1"
  fi
}

# 单行 → 规范化 key(跨"系统现状 dump"与"Brewfile"比较时对齐差异)
_brewfile_key() {
  emulate -L zsh
  local line="${1%%#*}"                          # 去行内注释
  line="${line#"${line%%[![:space:]]*}"}"        # 去前导空白
  case "$line" in
    mas*)             [[ $line =~ 'id:[[:space:]]*([0-9]+)' ]] && print -r -- "mas:${match[1]}" ;;
    brew*|cask*|tap*) [[ $line =~ '"([^"]+)"' ]]               && print -r -- "${line%% *}:${match[1]}" ;;
  esac
}

# 显示系统与 Brewfile 的漂移
brewfile-drift() {
  emulate -L zsh
  command -v brew >/dev/null 2>&1 || { print -u2 "✗ 未找到 brew"; return 1; }
  local bf; bf=$(_brewfile_path)
  [[ -r $bf ]] || { print -u2 "✗ 找不到 Brewfile: $bf"; return 1; }

  typeset -A sys bfk ign        # ign:被显式注释掉的包(故意不管,不报漂移)
  local line key trimmed
  while IFS= read -r line; do
    key=$(_brewfile_key "$line"); [[ -n $key ]] && sys[$key]="$line"
  done < <(brew bundle dump --file=- --no-vscode 2>/dev/null)
  while IFS= read -r line; do
    trimmed="${line#"${line%%[![:space:]]*}"}"     # 去前导空白
    if [[ $trimmed == '#'* ]]; then
      # 被注释掉的包行 → 计入忽略集
      trimmed="${trimmed#\#}"
      key=$(_brewfile_key "${trimmed#"${trimmed%%[![:space:]]*}"}")
      [[ -n $key ]] && ign[$key]=1
    else
      key=$(_brewfile_key "$line"); [[ -n $key ]] && bfk[$key]="$line"
    fi
  done < <(_brewfile_render "$bf")

  local found
  print "── 装了但不在 Brewfile(可复制进去)──"
  found=0
  for key in ${(ko)sys}; do
    (( ${+bfk[$key]} )) && continue          # 已声明
    (( ${+ign[$key]} )) && continue          # 已显式注释,故意忽略
    print "  + ${sys[$key]}"; found=1
  done
  (( found )) || print "  ✓ 无(系统都已记录)"
  (( ${#ign} )) && print "  (${#ign} 个已注释项被忽略)"

  print ""
  print "── 在 Brewfile 但没装(缺失)──"
  found=0
  for key in ${(ko)bfk}; do
    (( ${+sys[$key]} )) || { print "  - ${bfk[$key]}"; found=1; }
  done
  (( found )) || print "  ✓ 无(声明的都装了)"
}

# 打开 Brewfile 编辑(补漂移项时用)
brewfile-edit() { ${EDITOR:-nvim} "$(_brewfile_path)"; }
