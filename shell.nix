{pkgs ? import <nixpkgs> {}}: pkgs.mkShell {
  buildInputs=  with pkgs; [dhall dhall-lsp-server]
;}
