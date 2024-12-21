path=(
    ~/.dotnet/tools
    ~/.ghcup/bin
    ~/.cabal/bin
    ~/.cargo/bin
    /usr/local/bin
    ~/.npm/bin
    $path
)

if [ -e /opt/homebrew/bin/brew ]; then eval $(/opt/homebrew/bin/brew shellenv); fi

export EDITOR=nvim
export VISUAL=nvim
