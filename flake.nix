{
  description = "NixOS system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ...}@inputs: 
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.RazerLaptop = nixpkgs.lib.nixosSystem {
        modules = [ 
          ./hosts/RazerLaptop/configuration.nix
          ./hosts/RazerLaptop/hardware-configuration.nix
          home-manager.nixosModules.home-manager {
	    home-manager.extraSpecialArgs = { 
	      inherit hyprland;
	    };
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.b7 = ./users/b7/home.nix;
  	  }
        ];
      };
    };
}
