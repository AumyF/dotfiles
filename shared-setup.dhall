let dot = https://raw.githubusercontent.com/AumyF/dotstingray-libs/fd1443d5087b1522675b2662bfbebf459627ac8a/prelude.dhall

let pm = https://raw.githubusercontent.com/AumyF/dotstingray-libs/a3b3b849c7eb159106f4bee585fb1b9c45c26ae4/presets-package-managers.dhall

in {
  commands = [
    pm.nix-env-iA [
      , "nixpkgs.bat"
      , "nixpkgs.direnv"
      , "nixpkgs.fd"
      , "nixpkgs.fzf"
      , "nixpkgs.gh"
      , "nixpkgs.ghq"
      , "nixpkgs.git"
      , "nixpkgs.httpie"
      , "nixpkgs.lsd"
      , "nixpkgs.mcfly"
      , "nixpkgs.neofetch"
      , "nixpkgs.neovim"
      , "nixpkgs.ripgrep"
      , "nixpkgs.starship"
      , "nixpkgs.tealdeer"
      , "nixpkgs.zellij"
      , "nixpkgs.zoxide"
    ]
  ]
}
