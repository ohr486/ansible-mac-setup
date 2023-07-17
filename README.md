
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

## mac setup 手順

- 初回

- AppleIDログイン
- wifi設定
- Xcodeインストール(Storeから)
- ln -s

