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
      # Available through 'nixos-rebuild --flake .#instance-20250106-172607'
      nixosConfigurations = {
        instance-20250106-172607 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs outputs;};
          modules = [
            ./nixos/configuration.nix
            sops-nix.nixosModules.sops
          ];
        };
      };

      deploy.nodes = {
        instance-20250106-172607 = {
          hostname = "instance-20250106-172607";
          profiles = {
            system = {
            user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.instance-20250106-172607;
            };
            home = {
              user = "nikolai";
              path = deploy-rs.lib.x86_64-linux.activate.home-manager self.homeManagerConfigurations.nikolai;
            };
          };
        };

        checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;


      };
    };
}
