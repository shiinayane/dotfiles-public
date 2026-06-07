# dotfiles

[English](README.md) | [简体中文](README.zh.md) | **日本語**

[chezmoi](https://www.chezmoi.io) で管理するクロスプラットフォームな開発環境。**1つの設定で2つのプラットフォーム**:

- **macOS**(ローカル):フル環境。ソフトウェアは Homebrew(Brewfile)で管理。
- **Linux**(sudo なしのリモート、GPU サーバーなど):自動ブートストラップ。CLI ツールは [mise](https://mise.jdx.dev) でプリビルドバイナリを導入、zsh は [zsh-bin](https://github.com/romkatv/zsh-bin) を使用——すべて sudo 不要。

カバー範囲:zsh([powerlevel10k](https://github.com/romkatv/powerlevel10k))、git、Neovim(LazyVim)、
[ghostty](https://ghostty.org)(mac のみ)、mise / [uv](https://docs.astral.sh/uv)、モダン CLI(bat / eza / fzf / ripgrep)、
さらに SSH config と [age](https://github.com/FiloSottile/age) 暗号化された SSH 鍵(パスフレーズ1つで全復元)。

## 新しいマシンのセットアップ

### macOS

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply YOUR_GITHUB_USERNAME
```

その後ブートストラップ:Homebrew を導入 → `brew bundle`(CLI/GUI/App Store)→ `mise install`(ランタイム)→ `corepack enable`。
`chezmoi init` 時に SSH 鍵を復号するための **age パスフレーズ**を尋ねられます(「SSH 鍵」参照)。前提:App Store にサインイン済み。

### Linux リモート(sudo なし)

```sh
# 1. chezmoi バイナリを導入
sh -c "$(curl -fsSL get.chezmoi.io)" -- -b ~/.local/bin
# 2. init + apply(Linux ブートストラップが走る)
~/.local/bin/chezmoi init --apply git@github.com:YOUR_GITHUB_USERNAME/dotfiles.git
```

Linux ブートストラップスクリプト(`run_onchange`)は冪等に:

1. **zsh-bin** を導入(静的 zsh → `~/.local`)
2. **mise** を導入(`~/.local/bin`)
3. zsh プラグイン4つ(p10k / autosuggestions / syntax-highlighting / completions)を git clone → `~/.local/share/zsh/plugins`
4. `mise install` — `config.toml` で宣言した CLI ツール(プリビルドバイナリ、aarch64 含む)
5. `~/.bashrc` にガード付き `exec zsh` を追記(ログインシェル変更の sudo 不要な代替、対話時のみ)
6. VSCode Remote の統合ターミナルを zsh に設定(キーマージ、GUI 設定を上書きしない)

以降、`ssh <host>` でも VSCode ターミナルでも p10k zsh に入ります。マシン/プロジェクト固有の設定は各ホストの `~/.config/zsh/90-local.zsh` へ(追跡対象外)。

## 日常運用

```sh
chezmoi edit <file>      # ソースを編集
chezmoi apply            # ~ へ反映
chezmoi cd               # ソースリポジトリへ移動
```

macOS のソフトは `.chezmoitemplates/Brewfile` に記載。`chezmoi apply` で `brew bundle` を自動再実行。
`brewfile-drift`(zsh 関数)が「導入済みだが未記載 / 記載済みだが未導入」を検出。Linux の CLI ツールは `dot_config/mise/config.toml.tmpl` の `[tools]` セクションに記載。

## SSH 鍵(任意:age 暗号化)

> この public リポジトリには**秘密鍵は一切含まれません**。以下は私個人のやり方の参考です——実際の鍵/暗号文はプライベートな複製にのみ存在します。

chezmoi は秘密鍵を [age で暗号化](https://www.chezmoi.io/user-guide/encryption/age/)してリポジトリに保存でき、新しいマシンはパスフレーズ1つで復元できます:

- `key.txt.age` — age アイデンティティ。パスフレーズで暗号化(唯一のブートストラップ秘密。失うとロックアウト)。
- `encrypted_private_id_*.age` — 鍵の暗号文。追加は `chezmoi add --encrypt ~/.ssh/id_xxx`。
- `*.pub` — 公開鍵は平文でコミット可;平文の秘密鍵は**決してコミットしない**(`.gitignore` のセーフティネット)。

SSH config はテンプレート:`github` ホストは全プラットフォーム、内部/VPS のトポロジは mac/windows のみ(Linux リモートではスキップし、内部情報を共有マシンに残さない)。本リポジトリの `private_dot_ssh/private_config.tmpl` はテンプレート構造を示す**プレースホルダ例**です。

## 設計原則

- **ソースが唯一の真実**:ソースリポジトリを編集し、`~` 配下の生成物を直接いじらない。
- **クリーンなレイヤリング**:Homebrew はツールのみ(言語ランタイムは入れない);mise がランタイム(+ Linux では CLI ツール)を管理;uv / pnpm がプロジェクト依存を管理;グローバルは極力空に。
- **OS 条件分岐でクロスプラットフォーム**:`{{` `if ne .chezmoi.os "darwin"` `}}` テンプレート + `.chezmoiignore` で、Linux は macOS 専用設定(ghostty / fastfetch)をスキップし、Linux 専用ロジック(TERM フォールバック、CLI ツール宣言、mise 経由の age 導入)を有効化。SSH config は OS ごとに異なるホストを出力(丸ごとスキップではない)。
- **冪等**:`chezmoi apply` は再実行可能;スクリプトは内容が変わった時のみ再実行。

詳細な運用規約は [CLAUDE.md](./CLAUDE.md) を参照。
