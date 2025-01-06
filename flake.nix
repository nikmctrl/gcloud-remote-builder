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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    sops-nix,
    flake-utils,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in
    flake-utils.lib.eachDefaultSystem (system: {
      devShell = import ./shell.nix;

      formatter = nixpkgs.legacyPackages.${system}.alejandra;
    })
    // {
      # Available through 'nixos-rebuild --flake .#instance-20250106-172607'
      nixosConfigurations = {
        instance-20250106-172607 = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs;};
          homeManager.extraSpecialArgs = {inherit inputs outputs;};
          modules = [
            ./nixos/configuration.nix

            home-manager.nixosModules.home-manager
            ./home-manager/home.nix

            sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
