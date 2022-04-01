let Recipe = { commands : List Text }

let copy = \(arg : { from : Text, dest : Text }) -> "cp ${arg.from} ${arg.dest}"

let cp-fish =
      \(from : Text) -> copy { from, dest = "~/.config/fish/config.fish" }

let cp-starship =
      \(from : Text) -> copy { from, dest = "~/.config/starship.toml" }

let cp-gitconfig = \(from : Text) -> copy { from, dest = "~/.gitconfig" }

in    { commands =
        [ cp-starship "./starship.toml"
        , cp-fish "./config.fish"
        , cp-gitconfig "./.gitconfig"
        ]
      }
    : Recipe
