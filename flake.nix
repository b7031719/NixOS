{
  description = "NixOS system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";   # pin home-manager package to nixpkgs for consistent versions
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";   # pin hyprland package to nixpkgs for consistent versions
    hyprlock.url = "github:hyprwm/hyprlock";
    hyprlock.inputs.nixpkgs.follows = "nixpkgs";
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
	];
      };
      

      # HOME-MANAGER CONFIGURATION (STANDALONE)
      homeConfigurations = { 
        b7 = home-manager.lib.homeManagerConfiguration {
	  inherit system pkgs;
  	  modules = [ ./users/b7/home.nix ];
  	  extraSpecialArgs = {
  	    inherit hyprland hyprlock;
  	  };
	};
      };

    };
}
