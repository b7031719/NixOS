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
#      nixosConfigurations.RazerLaptop = nixpkgs.lib.nixosSystem {
#        modules = [ 
#          ./hosts/RazerLaptop/configuration.nix
#          ./hosts/RazerLaptop/hardware-configuration.nix
#          home-manager.nixosModules.home-manager {
#	    home-manager.extraSpecialArgs = {     # Inherit some outputs for use in home-manager modules
#	      inherit hyprland;
#	      inherit pkgs;
#	      inherit system;
#	      inherit hyprlock;
#	    };
#	    home-manager.useGlobalPkgs = true;
#	    home-manager.useUserPackages = true;
#	    home-manager.users.b7 = ./users/b7/home.nix;
#  	  }
#        ];
#      };

      # NIXOS SYSTEM CONFIGURATION
      nixosConfigurations.RazerLaptop = nixpkgs.lib.nixosSystem {
        modules = [
	  ./hosts/RazerLaptop/configuration.nix
	  ./hosts/RazerLaptop/hardware-configuration.nix
	];
	specialArgs = { inherit pkgs; };
      };
      

      # HOME-MANAGER CONFIGURATION (STANDALONE)
      homeManagerConfigurations = { 
        b7 = home-manager.lib.homeManagerConfiguration {
          home.username = "b7";
  	  home.homeDirectory = "/home/b7";
  	  modules = [ ./users/b7/home.nix ];
  	  extraSpecialArgs = {
  	    inherit pkgs;
  	    inherit hyprland;
  	    inherit hyprlock;
  	  };
	};
      };

    };
}
