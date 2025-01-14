# install zinit if not installed
# picked from the zinit official installer, as it overwrites the .zshrc file
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# load zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# this allows `./foobar` instead of `cd ./foobar`
setopt auto_cd

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history
SAVEHIST=10000

# Load Nix (single-user installation)
# this is mainly for wsl, as it doesn't support multi-user installation
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi

# source: https://github.com/sindresorhus/pure?tab=readme-ov-file#zinit
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

type zoxide &> /dev/null && eval "$(zoxide init zsh)"

export MCFLY_FUZZY=2
export MCFLY_INTERFACE_VIEW=BOTTOM
# source: https://github.com/cantino/mcfly?tab=readme-ov-file#install-by-zinit
zinit ice lucid wait"0a" from"gh-r" as"program" atload'eval "$(mcfly init zsh)"'
zinit light cantino/mcfly

type direnv &> /dev/null && eval "$(direnv hook zsh)"

# lsd when cd
chpwd() {
    lsd --long --classify --date "+%F %T"
}

# this script is not loaded lazily to avoid the `zsh: command not found: ni` error
zinit light azu/ni.zsh

# source and explanation: https://zdharma-continuum.github.io/zinit/wiki/Example-Minimal-Setup/
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

# enable `zmodload zsh/zprof` at env.zsh to profile zsh startup
if (which zprof > /dev/null) ;then
    zprof | less
fi
