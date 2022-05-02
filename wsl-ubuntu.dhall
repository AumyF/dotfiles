let lib =
      https://raw.githubusercontent.com/AumyF/dotstingray-libs/b1d80c66bc194031bd056d7f3a8f0e24651122aa/dot.dhall

let copy = lib.useCmd "cp"

in    { commands =
        [ copy.starship "./starship.toml"
        , copy.zshrc "./nix-single-user/.zshrc"
        , copy.zshenv "./.zshenv"
        , copy.git "./nogpgsign/.gitconfig"
        ]
      }
    : lib.Recipe
