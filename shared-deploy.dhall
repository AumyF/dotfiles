let dot = https://raw.githubusercontent.com/AumyF/dotstingray-libs/fd1443d5087b1522675b2662bfbebf459627ac8a/prelude.dhall

let configs = https://raw.githubusercontent.com/AumyF/dotstingray-libs/fd1443d5087b1522675b2662bfbebf459627ac8a/presets-configs.dhall

in

{
  commands = [
    configs.symlink.starship "./starship/starship.toml",
    configs.symlink.git "./git/config",
    configs.symlink.neovim-init-lua "./neovim/init.lua",
  ]
}: dot.Recipe
