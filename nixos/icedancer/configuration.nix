{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    ../hm.nix

    ../shared
  ];


  users.users.root.hashedPasswordFile = config.sops.secrets."icedancer/rootPassword".path;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "mc-remote-build";
  # networking.domain = "";
  system.stateVersion = "23.11";

}
