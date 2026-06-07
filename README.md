# dotfiles

**English** | [简体中文](README.zh.md) | [日本語](README.ja.md)

Cross-platform development environment managed with [chezmoi](https://www.chezmoi.io). **One config, two platforms:**

- **macOS** (local): full environment, software managed via Homebrew (Brewfile).
- **Linux** (no-sudo remotes, e.g. GPU servers): auto-bootstrapped — CLI tools installed as prebuilt binaries via [mise](https://mise.jdx.dev), zsh via [zsh-bin](https://github.com/romkatv/zsh-bin) — entirely sudo-free.

Covers zsh ([powerlevel10k](https://github.com/romkatv/powerlevel10k)), git, Neovim (LazyVim),
[ghostty](https://ghostty.org) (mac only), mise / [uv](https://docs.astral.sh/uv), modern CLIs (bat / eza / fzf / ripgrep),
plus an SSH config and [age](https://github.com/FiloSottile/age)-encrypted SSH keys (one passphrase restores everything).

## New machine setup

### macOS

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

Bootstrap then: install Homebrew → `brew bundle` (CLI/GUI/App Store) → `mise install` (runtimes) → `corepack enable`.
`chezmoi init` prompts for the **age passphrase** to decrypt SSH keys (see "SSH keys"). Prerequisite: signed into the App Store.

### Linux remote (no sudo)

```sh
# 1. install the chezmoi binary
sh -c "$(curl -fsSL get.chezmoi.io)" -- -b ~/.local/bin
# 2. init + apply (triggers the Linux bootstrap)
~/.local/bin/chezmoi init --apply git@github.com:YOUR_GITHUB_USERNAME/dotfiles.git
```

The Linux bootstrap script (`run_onchange`) idempotently:

1. installs **zsh-bin** (static zsh → `~/.local`)
2. installs **mise** (`~/.local/bin`)
3. git-clones the 4 zsh plugins (p10k / autosuggestions / syntax-highlighting / completions) → `~/.local/share/zsh/plugins`
4. `mise install` — CLI tools declared in `config.toml` (prebuilt binaries, incl. aarch64)
5. appends a guarded `exec zsh` to `~/.bashrc` (a no-sudo substitute for changing the login shell; interactive-only)
6. configures the VSCode Remote integrated terminal to use zsh (keyed merge, won't clobber GUI settings)

Afterwards `ssh <host>` and the VSCode terminal both drop into p10k zsh. Machine/project-specific config goes in each host's `~/.config/zsh/90-local.zsh` (not tracked).

## Daily use

```sh
chezmoi edit <file>      # edit source
chezmoi apply            # deploy to ~
chezmoi cd               # cd into the source repo
```

macOS software lives in `.chezmoitemplates/Brewfile`; `chezmoi apply` re-runs `brew bundle` automatically.
`brewfile-drift` (a zsh function) reports "installed-but-untracked / tracked-but-missing". Linux CLI tools live in the `[tools]` section of `dot_config/mise/config.toml.tmpl`.

## SSH keys (optional: age encryption)

> This public repo contains **no private keys**. The following is how I do it personally, for reference — actual keys/ciphertext live only in a private copy.

chezmoi can store private keys in the repo [encrypted with age](https://www.chezmoi.io/user-guide/encryption/age/); a new machine restores them with one passphrase:

- `key.txt.age` — the age identity, passphrase-encrypted (the single bootstrap secret; lose it and you're locked out).
- `encrypted_private_id_*.age` — key ciphertext. Add one with `chezmoi add --encrypt ~/.ssh/id_xxx`.
- `*.pub` — public keys may be committed in plaintext; plaintext private keys are **never** committed (`.gitignore` safety net).

The SSH config is a template: the `github` host on all platforms; internal/VPS topology only on mac/windows (skipped on Linux remotes to keep internal info off shared boxes). The `private_dot_ssh/private_config.tmpl` here is a **placeholder example** showing the template structure.

## Design principles

- **Source is the single truth**: edit the source repo, never the deployed files under `~`.
- **Clean layering**: Homebrew installs tools, not language runtimes; mise manages runtimes (+ CLI tools on Linux); uv / pnpm manage project deps; keep the global env empty.
- **Cross-platform via OS conditionals**: `{{` `if ne .chezmoi.os "darwin"` `}}` templates + `.chezmoiignore` let Linux skip macOS-only config (ghostty / fastfetch) and enable Linux-only logic (TERM fallback, CLI-tool declarations, age installed via mise). The SSH config emits different hosts per OS (rather than being skipped wholesale).
- **Idempotent**: `chezmoi apply` is re-runnable; scripts re-run only when their content changes.

See [CLAUDE.md](./CLAUDE.md) for detailed working conventions.
