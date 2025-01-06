{ pkgs ? import <nixpkgs> { } }:

with pkgs;

mkShellNoCC {
  buildInputs = [
    sops
    age
    ssh-to-age
  ];

  shellHook = ''
    echo "You are in SOPS mode"
  '';
}
