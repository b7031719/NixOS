{
  description = "NixOS system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, hyprlock, ...}@inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {        # pkgs created to set the allowUnfree config parameter
        inherit system;
        config.allowUnfree = true;
      };
    in {

      # NIXOS SYSTEM CONFIGURATION
      nixosConfigurations.RazerLaptopVM = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./hosts/RazerLaptopVM/configuration.nix
          ./hosts/RazerLaptopVM/hardware-configuration.nix
          inputs.lanzaboote.nixosModules.lanzaboote
        ];
      };
      

      # HOME-MANAGER CONFIGURATION (STANDALONE)
      homeConfigurations = { 
        b7 = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/b7/home.nix ];
          extraSpecialArgs = {
            inherit hyprland hyprlock;
  	      };
	      };
      };

    };
}
