# dotfiles

@AumyF's dotfiles for macOS and Linux.

## Setup

note: This section is written in Japanese since it is primarily for me.

### Nixを入れる

- ググれ
  - というかNixOS公式とDeterminate Systemsのインストーラーがあり、Determinate
    SystemsのインストーラーだとmacOSでアプデに巻き込まれて死ににくい、アンインストールしやすいといわれている（要出典）

### リポジトリをcloneする

- 実際どこでもいいけど `ghq` が使うディレクトリ構造に合わせている

```sh
git clone https://github.com/AumyF/dotfiles ~/ghq/github.com/AumyF/dotfiles
```

### 実行

```sh
# 必要なソフトウェア（direnvとかripgrepとか）を入れる
nix run nixpkgs#deno -- run -A dotfiles.ts setup run

# こういう感じでもいい
nix shell nixpkgs#deno
# ↑実行するとDenoのパス通ったシェルが開くので、↓
deno -- run -A dotfiles.ts setup run

# 以降はめんどくさいのでdenoから書く

# 必要なソフトが入ってるか確認する
deno -- run -A dotfiles.ts setup

# 設定ファイル類を各種ロケーションに配置する
# いまのところシンボリックリンクを貼っている
deno -- run -A dotfiles.ts deploy run

# 確認
deno -- run -A dotfiles.ts deploy
```
