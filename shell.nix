{pkgs ? import <nixpkgs> {}}:
with pkgs;
  mkShell {
    buildInputs = [
      sops
      age
      ssh-to-age
    ];

    shellHook = ''
      echo "You are in SOPS mode"
    '';
  }
