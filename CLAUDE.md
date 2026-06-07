# CLAUDE.md — dotfiles 仓库工作约定

这是用 **chezmoi** 管理的跨平台 dotfiles 仓库(macOS 本机 + 无 sudo 的 Linux 远程机)。
管理范围:shell(zsh/p10k)、git、ghostty、nvim(LazyVim)、fastfetch、mise/uv 配置,
以及通过 Brewfile 管理的全部软件(brew / cask / mas)。

## 黄金法则:源是唯一真相

- **本仓库(`~/.local/share/chezmoi`)是源,`~` 下的文件是部署产物。**
- **永远编辑这里的源文件,绝不直接改 `~/.config/...` 等目标**——直接改会和源脱节,且被 `chezmoi apply` 覆盖。
- 目标名 ↔ 源名映射:`~/.foo` ← `dot_foo`;`~/.config/x` ← `dot_config/x`;`private_` 前缀 = 0600。

## 标准工作流

1. 在源仓库编辑文件。
2. 校验(按改动类型):
   - 模板:`chezmoi execute-template < 文件`
   - Brewfile:`chezmoi execute-template < .chezmoitemplates/Brewfile | brew bundle check --file=-`
3. `chezmoi apply` 部署到 `~`。
4. **在登录交互 shell 里验证**:`zsh -lic '...'`,过滤噪音
   `grep -vE 'gitstatus|monitor|exec zsh|zle|Add the following'`(p10k 在非 tty 子 shell 的正常报错)。
5. `git add -A && git commit && git push origin main`(dotfiles 直接提交 main)。
   提交信息用 Conventional Commits,结尾带:
   `Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>`

`chezmoi apply` 是幂等的:文件只在不一致时写;`run_onchange` 脚本仅在内容变化时跑一次。

## 仓库布局

```
CLAUDE.md / README.md                              # 仓库元文档(已在 .chezmoiignore 排除,不部署到 ~)
.chezmoitemplates/Brewfile                         # 软件清单(手动策展的真相)
.chezmoiscripts/run_onchange_after_*-packages.sh   # bootstrap:brew bundle + mise install + corepack
.chezmoiignore                                     # 「什么不是 dotfile」(target 名)
.gitignore                                         # 机密兜底(source 名)
dot_config/zsh/{00..50,36}-*.zsh + dot_zshrc       # 编号模块,顺序敏感(36 = Brewfile 助手)
dot_p10k.zsh dot_gitconfig dot_zshenv ...
private_dot_ssh/private_config.tmpl                # ~/.ssh/config 模板(本 public 仓为占位示例)
```

## 两个 ignore 文件职责分离(别混)

- **`.chezmoiignore`**(target 名):chezmoi 不部署/不管理。垃圾、缓存、history、`*.zwc`、
  karabiner 备份、ssh 密钥、本机 `90-local.zsh`、以及仓库元文档 `/CLAUDE.md`、`/README.md`
  (用前导 `/` 锚定根,避免误伤 nvim 等子目录里被管理的 README)。
- **`.gitignore`**(source 名,带前缀):机密兜底(源目录明文存储,拦截误 add 的密钥)+ Finder 垃圾。
- 垃圾/缓存策略只写在 `.chezmoiignore`,`.gitignore` 不重复。

## Brewfile 工作流(声明式 + 漂移检查)

- Brewfile 是**手动策展**的真相(分区 + 注释),内联进 bootstrap 脚本,`run_onchange` 改了自动重跑。
- 不带 `--cleanup`:只增不删。
- 装了新东西后用 `brewfile-drift`(zsh 函数)看漂移:列出「装了没记 / 记了没装」。
- 不想在新机器自动装的:**注释掉对应行**;`brewfile-drift` 会忽略已注释项。
- **游戏一律放「游戏」分区并默认注释**(本机已装保留,新机器不装)。
- 加 mas 应用:`mas list` 拿 id → `mas "名字", id: NNN`(需登录 App Store)。

## 开发环境哲学(洁癖分层)

- Layer0 = Homebrew(只装 CLI 工具 + GUI cask,**绝不 brew install 语言运行时**)。
- Layer1 = mise(node/python 版本)。Layer2 = uv(python 包)、pnpm(**走 corepack**,随 node 版本)。
- 全局尽量空,项目尽量满。`which python/node` 必须指向 mise,不是 `/usr/bin`。

## 安全

> 本 public 仓**不含任何私钥/密文/真实内网信息**。SSH config、密钥相关均为占位示例;
> 真实凭证只存在私有副本。以下是设计约定。

- **明文密钥/凭证绝不入库**;`.gitignore` 机密兜底拦 `private_id_*`/`*.pem`/`*.key`(放行 `encrypted_*.age`)。
- **SSH 私钥可走 age 加密入库**(chezmoi 原生支持):`encrypted_private_id_*.age`(密文)
  + `key.txt.age`(age 身份,passphrase 加密)。公钥 `*.pub` 可明文;`known_hosts` 不入库(各机自生成)。
- **SSH config 按 OS 输出不同 host**:`github` 全平台;内网/VPS 拓扑仅 mac/windows,Linux 远程跳过
  (避免内网信息落到共享机)。本仓 config 为占位示例。
- **若要启用 age 加密**:`brew install age` → `age-keygen` 生成身份 → 用 passphrase 加密身份为
  `key.txt.age` 提交 → `chezmoi add --encrypt` 加密私钥 → 新机器 `chezmoi init` 提示 passphrase 解密。
  详见 [chezmoi age 文档](https://www.chezmoi.io/user-guide/encryption/age/)。
