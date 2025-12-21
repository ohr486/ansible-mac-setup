# CLAUDE.md

このファイルは、このリポジトリで作業する際にClaude Code (claude.ai/code) にガイダンスを提供します。

## 概要

このリポジトリは、AnsibleベースのmacOS自動セットアップツールです。新しいMacに開発ツール、アプリケーション、dotfile設定を自動的にプロビジョニングします。ワンクリックで開発環境をセットアップできるように設計されています。

## コマンド

### 初回セットアップ
```bash
# 事前準備（セットアップ前の手動作業）
xcode-select --install
sudo xcodebuild --license  # 'agree'と入力
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git
brew install ansible

# クローンして実行
git clone git@github.com:ohr486/ansible-mac-setup.git
cd ansible-mac-setup
./setup.sh
```

### Ansible Playbookの実行
```bash
# 完全セットアップ
ansible-playbook local.yml -i hosts

# チェックモード（ドライラン）
ansible-playbook local.yml -i hosts --check

# 特定のroleのみ実行
ansible-playbook local.yml -i hosts --tags <role_name>
```

### よく使う開発タスク
```bash
# Homebrewパッケージの更新
brew update && brew upgrade

# 古いHomebrewバージョンのクリーンアップ
brew cleanup

# 全asdfプラグインリストの更新
asdf plugin update --all

# 特定のasdfプラグインの更新
asdf plugin add <plugin-name> <git-url>
asdf install <plugin-name> latest
asdf set --home <plugin-name> latest
```

## アーキテクチャ

### Role実行順序
Playbookは以下の順序でroleを実行します（`local.yml`で定義）:
1. **brew-cask** - Homebrew Cask経由でGUIアプリケーションをインストール
2. **brew** - コマンドラインツールのインストールとHomebrewリポジトリのtap
3. **alias** - エイリアスファイルをDropboxにコピーしてシェルエイリアスを設定
4. **dotenv** - `~/Dropbox/common-conf/`からホームディレクトリへdotfileのシンボリックリンクを作成
5. **asdf** - asdfバージョンマネージャと複数の言語ランタイムをインストール・設定
6. **k8s** - Kubernetesツール（kube-ps1プロンプト）の設定
7. **font** - Rictyフォントを~/Library/Fontsにインストール
8. **zsh** - Preztoフレームワークを使ったzshのセットアップ

### 主要な設計パターン

**Dropboxによる設定の一元管理**
- すべてのdotfileは`~/Dropbox/common-conf/`に保存され、ホームディレクトリにシンボリックリンクされる
- これにより、Dropbox同期を通じて複数マシン間で設定を共有できる
- `dotenv` roleは以下のシンボリックリンクを作成: `.bash_profile`, `.bashrc`, `.zshrc`, `.zshenv`, `.vimrc`, `.vim/`, `.config/`, `.kube/`, `.aws/`, `.tool-versions`など

**パッケージ状態管理**
- パッケージは`state: latest`、`state: present`、`state: absent`を指定可能
- `state: absent`はインストール済みパッケージを削除
- 状態指定なしの場合、brewは`latest`、caskは`present`がデフォルト

**asdfプラグインパターン**
asdf roleの各言語/ツールは以下のパターンに従う:
1. プラグインの存在確認（`stat`タスク）
2. 不足している場合はプラグイン追加（`shell: asdf plugin add`）
3. beta/rc/devバージョンを除外するgrepフィルタで最新版をインストール
4. `asdf set --home`でグローバルバージョンを設定

言語ランタイムの例:
- `grep -v`で不要なバージョン（beta、rc、alpha、dev）を除外
- `tail -n 1`で最新の安定版を取得
- `asdf install <plugin> <version>`でインストール
- `asdf set --home <plugin> <version>`でグローバル設定

**シェル設定の注入**
- Roleは`lineinfile`モジュールを使って`.zshrc`や`.bash_profile`に設定行を追加
- 各roleは`# for <role-name> by ansible-mac-setup`のようなコメントを追加の前に付ける
- これにより、どのroleがどの設定を追加したかが明確になる

### 変数構造

すべてのパッケージリストは`local.yml`で変数として定義されている:

- `brew_repos` - 追加するHomebrew tapリポジトリ
- `brew_packs` - name/state/install_optionsを持つHomebrewパッケージのリスト
- `brew_cask_repos` - Homebrew Cask tapリポジトリ（ほとんど無効化済み）
- `brew_cask_packs` - name/stateを持つCaskアプリケーションのリスト

### asdfで管理される言語ランタイム

現在設定されているもの（roles/asdf/tasks/main.ymlに記載）:
- gcloud, awscli, aws-iam-authenticator, terraform
- erlang, rebar, elixir
- ruby
- nodejs, yarn
- python (3.12.x), poetry
- golang
- rust
- java (openjdk)
- gauche（プラグイン追加済みだがインストールはされない）
- kubectx, minikube

### 重要な注意事項

**手動での事前準備**
Playbookを実行する前に以下が必要:
- Apple IDログインとwifi設定
- App StoreからXcodeをインストール
- Command Line Toolsのインストール
- Homebrewのインストール
- Homebrew経由でGitとAnsibleをインストール

**Prezto設定**
zsh roleはPrezto（zshフレームワーク）をクローンし、そのruncomsへのシンボリックリンクを作成:
- `.zlogin`, `.zlogout`, `.zpreztorc`, `.zprofile`
- これらは`~/.zprezto/runcoms/`からシンボリックリンクされる

**フォントインストール**
font roleはRictyフォントのインストール後にフォントキャッシュを再構築するためにハンドラー（`run fc-cache`）を使用

**設定ファイル**
`ansible.cfg`は`ask_sudo_pass = True`に設定されており、実行中にsudoパスワードの入力を求められる
