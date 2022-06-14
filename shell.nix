{pkgs ? import <nixpkgs> {}}: pkgs.mkShell {
  buildInputs=  with pkgs; [ dhall-lsp-server]
;}
