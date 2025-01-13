{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Sops
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # flake-utils
    flake-utils.url = "github:numtide/flake-utils";

    # deploy-rs
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    flake-utils,
    deploy-rs,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = import ./shell.nix {inherit pkgs;};

      formatter = pkgs.alejandra;
    })
    // {
      # Available through 'nixos-rebuild --flake .#eversince'
      nixosConfigurations = {
        eversince = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs outputs;};
          modules = [
            ./nixos/eversince/configuration.nix
            sops-nix.nixosModules.sops
          ];
        };

        icedancer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs outputs;};
          modules = [
            ./nixos/icedancer/configuration.nix
            sops-nix.nixosModules.sops
          ];
        };
      };

      deploy.nodes = {
        eversince = {
          hostname = "eversince.viiol.xyz";
          profiles = {
            system = {
              sshUser = "root";
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.eversince;
            };
          };
          remoteBuild = true;
        };

        icedancer = {
          hostname = "188.245.243.221";
          profiles = {
            system = {
              sshUser = "root";
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.icedancer;
            };
          };
          remoteBuild = true;
        };

        checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
      };
    };
}
