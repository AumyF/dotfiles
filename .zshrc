autoload -U compinit; compinit

setopt auto_cd

setopt hist_ignore_all_dups
setopt hist_ignore_space

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

export MCFLY_FUZZY=2
export MCFLY_INTERFACE_VIEW=BOTTOM
eval "$(mcfly init zsh)"

chpwd() {
    lsd --long --classify --date "+%F %T"
}

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
