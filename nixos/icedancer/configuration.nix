{config, pkgs, inputs, ...}: {
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
      tokenFile = config.sops.secrets."github-runners/nix-gh-ci".path;
      url = "https://github.com/nikmctrl/nix-gh-ci";
      extraLabels = [
        "icedancer"
        "8GB RAM"
        "4 CPU"
      ];
      user = "builder";
      group = "builder";
      replace = true;
      extraPackages = [
        pkgs.cachix
        inputs.omnix.packages.aarch64-linux.default
      ];
    };
  };

  boot.tmp.cleanOnBoot = true;
  # zramSwap.enable = true;
  networking.hostName = "mc-remote-build";
  networking.domain = "";
  system.stateVersion = "23.11";
  nixpkgs.hostPlatform = "aarch64-linux";
}
