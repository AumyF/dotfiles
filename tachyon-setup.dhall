let dot = https://raw.githubusercontent.com/AumyF/dotstingray-libs/fd1443d5087b1522675b2662bfbebf459627ac8a/prelude.dhall

let pm = https://raw.githubusercontent.com/AumyF/dotstingray-libs/fd1443d5087b1522675b2662bfbebf459627ac8a/presets-package-managers.dhall

in    { commands =
        [ brew [
            , "skhd"
            , "yabai"
            , "firefox"
            , "flameshot"
            , "google-chrome"
            , "iterm2"
            , "visual-studio-code"
            ]
        ]
      }
    : dot.Recipe
