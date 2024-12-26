{
  description = "A simple NixOS flake";

  inputs = {
    ### nixpkgs and home-manager
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ### third-party flakes
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    zen-browser,
    ...
  } @ inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations = {
      # @nia: roach will be used to build the system: sudos nixos-rebuild --flake .#roach
      roach = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};

        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.nacuna = import ./homemanager.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              system = "x86_64-linux";
            };
          }
        ];
      };
    };
  };
}
