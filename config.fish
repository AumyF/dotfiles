if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    zoxide init fish | source

    set -gx MCFLY_FUZZY 2
    set -gx MCFLY_INTERFACE_VIEW BOTTOM
    mcfly init fish | source
end

fish_add_path $HOME/.dotnet/tools
fish_add_path $HOME/.ghcup/bin
fish_add_path $HOME/.cabal/bin
fish_add_path $HOME/.cargo/bin

# fnm, a Node.js version manager
fnm env | source

function chpwd --on-variable PWD --description 'handler of changing $PWD'
    if status --is-command-substitution; or not status --is-interactive
        return 0
    end

    if command -q lsd
        lsd --long --classify --date "+%F %T"
    else
        ls -l --classify --time-style=long-iso
    end
end


set fish_color_normal normal
set fish_color_command magenta
set fish_color_param normal
set fish_color_redirection cyan
set fish_color_comment brblack
set fish_color_error red --bold --underline
# set fish_color_escape 00a6b2
set fish_color_operator red
# set fish_color_end 009900
set fish_color_quote brgreen
set fish_color_autosuggestion brblack
set fish_color_user normal
set fish_color_host normal
set fish_color_host_remote yellow
set fish_color_valid_path --underline
set fish_color_status red
set fish_color_cwd green

# set -g fish_term24bit 0
