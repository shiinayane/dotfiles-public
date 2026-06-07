# dotfiles

跨平台开发环境配置,用 [chezmoi](https://www.chezmoi.io) 管理。**一套配置,两个平台**:

- **macOS**(本机):完整环境,软件由 Homebrew(Brewfile)管理。
- **Linux**(无 sudo 的远程机,如 GPU 服务器):自动 bootstrap,工具由 [mise](https://mise.jdx.dev) 装预编译二进制,zsh 用 [zsh-bin](https://github.com/romkatv/zsh-bin)——全程零 sudo。

涵盖 zsh([powerlevel10k](https://github.com/romkatv/powerlevel10k))、git、Neovim(LazyVim)、
[ghostty](https://ghostty.org)(仅 mac)、mise / [uv](https://docs.astral.sh/uv)、bat / eza / fzf / ripgrep 等现代 CLI,
以及 SSH config + [age](https://github.com/FiloSottile/age) 加密的 SSH 私钥(一个 passphrase 恢复全套)。

## 新机器安装

### macOS

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

bootstrap 随后:装 Homebrew → `brew bundle` 装齐 CLI/GUI/App Store → `mise install` 装运行时 → `corepack enable`。
`chezmoi init` 时会提示输入 **age passphrase** 解密 SSH 私钥(见下「SSH 密钥」)。前提:已登录 App Store。

### Linux 远程机(无 sudo)

```sh
# 1. 装 chezmoi 单二进制
sh -c "$(curl -fsSL get.chezmoi.io)" -- -b ~/.local/bin
# 2. init + apply(自动触发 Linux bootstrap)
~/.local/bin/chezmoi init --apply git@github.com:YOUR_GITHUB_USERNAME/dotfiles.git
```

Linux bootstrap 脚本(`run_onchange`)幂等地:

1. 装 **zsh-bin**(静态 zsh → `~/.local`)
2. 装 **mise**(`~/.local/bin`)
3. git clone 4 个 zsh 插件(p10k / autosuggestions / syntax-highlighting / completions)→ `~/.local/share/zsh/plugins`
4. `mise install` 装 `config.toml` 声明的 CLI 工具(预编译二进制,含 aarch64)
5. 给 `~/.bashrc` 追加守卫式 `exec zsh`(无 sudo 改登录 shell 的替代,仅交互生效)
6. 配 VSCode Remote 集成终端用 zsh(键合并,不覆盖 GUI 设置)

之后 `ssh <host>` 或 VSCode 集成终端都进入 p10k zsh。机器/项目特有配置放各机的 `~/.config/zsh/90-local.zsh`(不入库)。

## 日常

```sh
chezmoi edit <文件>      # 编辑源
chezmoi apply            # 部署到 ~
chezmoi cd               # 进源仓库
```

macOS 软件增删改 `.chezmoitemplates/Brewfile`,`chezmoi apply` 自动重 `brew bundle`;
`brewfile-drift`(zsh 函数)检查「装了没记 / 记了没装」。Linux CLI 工具增删改 `dot_config/mise/config.toml.tmpl` 的 `[tools]`。

## SSH 密钥(可选:age 加密)

> 本 public 仓**不含任何私钥**。下面是我自用的做法,供参考——具体密钥/密文只存在私有副本里。

chezmoi 支持把私钥 [age 加密](https://www.chezmoi.io/user-guide/encryption/age/)后入库,新机器靠一个 passphrase 恢复:

- `key.txt.age` — age 身份,用 passphrase 加密(引导唯一秘密,丢了全锁死)。
- `encrypted_private_id_*.age` — 私钥密文。新增:`chezmoi add --encrypt ~/.ssh/id_xxx`。
- `*.pub` — 公钥可明文入库;明文私钥**绝不入库**(`.gitignore` 兜底)。

SSH config 是模板:`github` host 全平台,内网/VPS 拓扑仅 mac/windows(Linux 远程跳过,避免内网信息外泄)。
本仓 `private_dot_ssh/private_config.tmpl` 是**占位示例**,展示模板结构。

## 设计原则

- **源是唯一真相**:编辑源仓库,不直接改 `~` 下的部署产物。
- **洁癖分层**:Homebrew 只装工具不装语言;mise 管运行时(+ Linux 上的 CLI 工具);uv / pnpm 管项目依赖;全局尽量空。
- **跨平台靠 OS 条件**:`{{` `if ne .chezmoi.os "darwin"` `}}` 模板 + `.chezmoiignore` 让 Linux 跳过 macOS 专属配置(ghostty / fastfetch),并启用 Linux 专属逻辑(TERM 兜底、CLI 工具声明、age 装入 mise)。SSH config 则按 OS 输出不同 host(非整体跳过)。
- **幂等**:`chezmoi apply` 可反复执行;脚本仅在内容变化时重跑。

详细工作约定见 [CLAUDE.md](./CLAUDE.md)。
