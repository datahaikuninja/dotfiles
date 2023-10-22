## Homebrew
Homebrewが使えないと何もできない。CUI/GUIアプリケーションの管理はHomebrewに寄せている。

1. Homebrewをインストールする。
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

```
2. 1でxcodeもインストールされるが、もしされなかったらインストールする。
```shell
xcode-select --install

```
3. Homebrewでgoogle日本語入力をインストールする前に、rosettaをインストールする。
```shel
sudo softwareupdate --install-rosetta

```
4. 本リポジトリのBrewfileをホームディレクトリに配置して、CUI/GUIアプリケーションを一括インストールする。
```shell
touch ~/.Brewfile
brew bundle --global

```
## chshell
Homebrewでインストールしたzshを使用する
```shell
sudo /usr/bin/vim /etc/shells
chsh -s /opt/homebrew/bin/zsh

```

## ghq
gitリポジトリを管理するghqをセットアップする。
本リポジトリのgitconfigをホームディレクトリに配置する。
```shell
touch ~/.gitconfig
ghq install https://github.com/datahaikuninja/dotfiles.git

```
## symlink
gitが使えるようになったので、各種configファイルのシンボリックリンクを作成する。

```shell
# hammerspoon
cd ~/.hammerspoon/
ln -snvf ~/ghq/mine/github.com/datahaikuninja/dotfiles/hammerspoon.lua init.lua

# Neovim
cd ~/.config/
mkdir nvim
ln -snvf ~/ghq/mine/github.com/datahaikuninja/dotfiles/init.lua

# Karabiner-elements
cd ~/.config/karabiner/assets/complex_modifications/
ln -snvf ~/ghq/mine/github.com/datahaikuninja/dotfiles/right_opt_to_esc_for_vi.json right_opt_to_esc_for_vi.json
ln -snvf ~/ghq/mine/github.com/datahaikuninja/dotfiles/left_ctrl_and_hjkl_to_arrow_keys_unless_wezterm.json left_ctrl_and_hjkl_to_arrow_keys_unless_wezterm.json

# zshrc
cd ~/
ln -snvf ~/ghq/mine/github.com/datahaikuninja/dotfiles/zshrc .zshrc
source ~/.zshrc

```

## asdf
本リポジトリのzshrcを使用することで、asdfを使う準備はできているはずだが、もしできていなかったら以下に従ってインストールする。

https://asdf-vm.com/guide/getting-started.html

nodejs, pyhon, terraformをインストールする。
```shell
# nodejs
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs 18.18.2
asdf global nodejs 18.18.2

# python
asdf plugin-add python
asdf install python 3.11.6
asdf global python 3.11.6

# terraform
asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git
asdf list all terraform
asdf install terraform ${version}

```

## pip
Neovimでpython-lspを使うために、pynvimをインストールする。

```shell
python3 -m pip install --upgrade pip
python3 -m pip instal pynvim

```
