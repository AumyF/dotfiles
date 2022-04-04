let brew =
      https://raw.githubusercontent.com/AumyF/dotstingray/da9e5afe576096b025e808acf3febd53c51f2b68/dhall-lib/homebrew.dhall

let lib =
      https://raw.githubusercontent.com/AumyF/dotstingray/da9e5afe576096b025e808acf3febd53c51f2b68/dhall-lib/lib.dhall

in    { commands =
        [ brew
            [ "bat"
            , "fd"
            , "fish"
            , "fnm"
            , "fzf"
            , "ghcup"
            , "ghq"
            , "lsd"
            , "mcfly"
            , "neofetch"
            , "neovim"
            , "ripgrep"
            , "rustup"
            , "skhd"
            , "starship"
            , "tealdeer"
            , "yabai"
            , "zoxide"
            , "zsh-syntax-highlighting"
            , "zsh-autosuggestions"
            , "firefox"
            , "flameshot"
            , "iterm2"
            , "visual-studio-code"
            ]
        ]
      }
    : lib.Recipe
