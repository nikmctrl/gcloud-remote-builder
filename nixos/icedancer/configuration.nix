{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    ../hm.nix

    ../shared
  ];

  services.github-runners = {
    nix-gh-ci = {
      enable = true;
      name = "icedancer";
      token = config.sops.secrets."github-runners/nix-gh-ci".path;
      url = "https://github.com/nikmctrl/nix-gh-ci";
      workDir = "/var/lib/github-runners";
      extraLabels = [
        "icedancer"
        "8GB RAM"
        "4 CPU"
      ];
    };
  };

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "mc-remote-build";
  # networking.domain = "";
  system.stateVersion = "23.11";
}
