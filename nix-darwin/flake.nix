{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      homebrew.enable = true;
      homebrew.brews = ["terminal-notifier"];
      homebrew.casks = ["1password" "discord" "visual-studio-code" "whisky" "lm-studio" "blackhole-16ch" "raycast" "font-udev-gothic-nf" "font-plemol-jp-nf" "font-moralerspace-nf"];

      programs.zsh.enableGlobalCompInit = false;
      programs.zsh.promptInit = "";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#agoshi
    darwinConfigurations.agoshi = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
