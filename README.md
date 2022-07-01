# dotfiles

@AumyF's dotfiles written in Dhall.

## Setup

### Requirements

- multi-user mode installation of Nix
  - single-user mode users may require additional configuration in `~/.zshrc`
- Homebrew (macOS) or Pacman (Arch Linux) to install OS-specific softwares.
  
Windows users can use WSL2, although only single-user mode works on it.
  
### Install Nix

See https://nixos.org/download.html or run

```sh
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### Clone Repository

It is recommended to clone the repo to `~/ghq/github.com/AumyF/dotfiles` to be consistent with ghq.

```sh
git clone https://github.com/AumyF/dotfiles ~/ghq/github.com/AumyF/dotfiles
```

### Naming Conventions

- `*-install.dhall` installs softwares.
- `*-deploy.dhall` creates symlinks which references to the cloned repo's files.
- `tachyon-*` means macOS specific settings (tachyon is the host name of my Mac machines).
- `cafe-*` means Arch Linux specific settings (cafe is the same but of Linux).
- `shared-*` means sharable configs between Nix-installed systems.

### Run Commands

1. `nix-shell` to set up `jq` and `dhall-to-json`.
2. `dhall-to-json --file <file> | jq -r ".commands[]"` to preview commands.
3. `eval $(dhall-to-json --file <file> | jq -r ".commands[]")` to run commands.

