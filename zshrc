#### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

### Added by User
#### prompt theme
#zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh' --commented out as I moved to starship
#zinit light sindresorhus/pure --commented out as I moved to starship

#### zsh options
setopt SHARE_HISTORY
setopt Extended_History
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

#### command history press Ctrl+r
zinit load robobenklein/zdharma-history-search-multi-word

#### auto suggest
zinit light zsh-users/zsh-autosuggestions

#### syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting

#### asdf(version control system)
#zinit light asdf-vm/asdf --commented out as I moved to homebrew

### PATH
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/Cellar/git:$PATH"
export PATH="${HOME}/.asdf/shims/python:$PATH"
export PATH="${HOME}/sdk/go1.25.5/bin:$PATH"
export PATH="${HOME}/go/bin:$PATH"
export PATH="${HOME}/.cargo/bin:$PATH"
export PATH="/Applications/WezTerm.app/Contents/MacOS/wezterm:$PATH"
export PATH="/opt/homebrew/opt/mysql-client@8.0/bin:$PATH"
export PATH="/opt/homebrew/opt/mysql-client@5.7/bin:$PATH"
export PATH="${HOME}/.asdf/shims/ruby:$PATH"
export PATH="$HOME/.local/bin:$PATH"

### $HOME 変数の値に応じて $WORK_ENV を設定
case "$HOME" in
  "/Users/takashina.jundai")
    export WORK_ENV="private"
    ;;
  "/Users/takashina")
    export WORK_ENV="work"
    ;;
  *)
    # 上記以外の場合、WORK_ENV は設定しない (または必要に応じてエラーメッセージなどを表示)
    # echo "WORK_ENV could not be determined." >&2
    ;;
esac

### for tmux settings
typeset -U path PATH
[[ $TMUX = "" ]] && export TERM="xterm-256color"
alias tmux='tmux -2'

### direnv
export EDITOR=nvim
eval "$(direnv hook zsh)"

### alias
#### WezTerm
alias wezterm="/Applications/WezTerm.app/Contents/MacOS/wezterm"

#### AWS CLI Docker
# alias aws='docker run --rm -i -v ~/.aws:/root/.aws public.ecr.aws/aws-cli/aws-cli'

#### google/cloud-sdk
# alias gcloud='docker run --rm -it --volumes-from gcloud-config google/cloud-sdk gcloud'
alias gcloud="${HOME}/google-cloud-sdk/bin/gcloud"

#### ls
alias ls='ls -G'

#### vi, vim, nvim
alias vi='nvim'
alias vim='nvim'

#### lazygit
alias lg='lazygit'

#### gh-dash
alias ghd='gh dash'

#### dotfiles
alias dotfiles="cd ${HOME}/ghq/mine/github.com/datahaikuninja/dotfiles"

#### mysql57
alias mysql57='/opt/homebrew/opt/mysql-client@5.7/bin/mysql'

#### mysql80
alias mysql80='/opt/homebrew/opt/mysql-client@8.0/bin/mysql'

#### git-completion
fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit -u

### fzf default 
#export FZF_DEFAULT_COMMAND='fd --type file --color=always'
export FZF_DEFAULT_OPTS='--height 75% --multi --layout=reverse --border --ansi'

### function
#### ghq list -p + fzf
function moveRepo() {
	local selected
	selected=$(ghq list -p | fzf --query="$1" --no-multi --no-select-1 --no-exit-0)
    if [[ -n $selected ]]; then
        cd "$selected"
    fi
}
alias repo='moveRepo'

#### fzf git add
function fzf_git_add() {
    local selected
    selected=$(unbuffer git status -s | fzf -m --ansi --preview="echo {} | awk '{print \$2}' | xargs git diff --color" | awk '{print $2}')
    if [[ -n "$selected" ]]; then
        git add `paste -d " " -s - <<< $selected`
    fi
    git status -s
}
alias fga='fzf_git_add'

#### fzf git switch
function fzf_git_switch() {
    local selected
    selected=$(git branch | fzf +m)
    if [[ -n "$selected" ]]; then
        git switch $(echo $selected)
    fi
}
alias fgs='fzf_git_switch'

#### fzf search file & edit its
function fzf_search_edit() {
    local file 
    file=$(
        fd --type f --color=always --max-depth 2 --follow --hidden --exclude .git | fzf --query="$1" --no-multi --select-1 --exit-0 --preview 'bat --color=always --line-range :500 {}')
    if [[ -n $file ]]; then
        $EDITOR "$file"
    fi
    #file=$(find . -type d -name '.git' -prune -o -type f -print | fzf --preview="head -n 100 {}" )
    #code "$file"
}
alias fse='fzf_search_edit'

#### fzf cd
function fzf_cd() {
    local dir
    dir=$(fd --type d | fzf --query="$1" --no-multi --select-1 --exit-0 --preview 'tree -C {} | head -n 100')
    if [[ -n $dir ]]; then
        cd "$dir"
    fi
}
alias fcd='fzf_cd'

## starship
eval "$(starship init zsh)"

## asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

## terragrunt: eanble tab completion
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terragrunt terragrunt

# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then . "${HOME}/google-cloud-sdk/completion.zsh.inc"; fi

## kubectl completion
source <(kubectl completion zsh)

## aqua
source <(aqua completion zsh)
aqua_root_path=`aqua root-dir`
export PATH="${aqua_root_path}/bin:$PATH"
