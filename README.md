# ansible-mac-setup

one click setup script for MacOS

## usage

install homebrew

```bash
$ xcode-select --install

$ sudo xcodebuild --license
> agree

$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

$ touch .zshrc

$ vi .zprofile
> edit export settings

$ brew install git
$ brew install ansible
```

run setup script

```bash
$ git clone git@github.com:ohr486/ansible-mac-setup.git
$ cd ansible-mac-setup
$ ./setup.sh
```

Docker Desktop など、Homebrew Cask の更新中に `/usr/local` 配下の root 所有ファイルを更新するアプリは sudo パスワードが必要です。
実行中に `Homebrew Cask の操作に sudo パスワードが必要です（スキップする場合は Enter）` と表示されたら、macOS のログインパスワードを入力してください。
非対話で実行する場合は、`brew_cask_sudo_password` を Ansible Vault などで渡してください。

## mac setup 手順

- 初回

- AppleIDログイン
- wifi設定
- Xcodeインストール(Storeから)
- ln -s
