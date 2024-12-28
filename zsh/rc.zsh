# If there is no zinit installation, install it
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

# Load zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

setopt auto_cd

setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history
SAVEHIST=10000

# Load Nix (single-user installation)
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi

zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

type zoxide &> /dev/null && eval "$(zoxide init zsh)"

export MCFLY_FUZZY=2
export MCFLY_INTERFACE_VIEW=BOTTOM
type mcfly &> /dev/null && eval "$(mcfly init zsh)"

type direnv &> /dev/null && eval "$(direnv hook zsh)"

chpwd() {
    lsd --long --classify --date "+%F %T"
}

zinit light azu/ni.zsh

zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    blockf \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

if (which zprof > /dev/null) ;then
    zprof | less
fi
