let lib =
      https://raw.githubusercontent.com/AumyF/dotstingray-libs/376f973a0476c5e7aaa98d7a05f9a677ba5ac1e6/dot.dhall

let copy = lib.useCmd "cp"

in    { commands =
        [ copy.starship "./starship.toml"
        , copy.fish "./config.fish"
        , copy.git "./nogpgsign/.gitconfig"
        ]
      }
    : lib.Recipe
