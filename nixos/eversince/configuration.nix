# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  sops,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../hm.nix

    ../shared
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.domain = "europe-west2-a.c.nix-ci-446719.internal";
  networking.hostName = "eversince";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
