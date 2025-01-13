{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    ../hm.nix

    ../shared
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "mc-remote-build";
  # networking.domain = "";
  system.stateVersion = "23.11";

  users.users.root.hashedPasswordFile = config.sops.secrets."rootPassword/icedancer".path;
}
