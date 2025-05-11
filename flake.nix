{
  description = "NixOS system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ...}@inputs: {
    nixpkgs.config.allowUnfree = true;
    nixosConfigurations.RazerLaptop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      system = "x86_64-linux";
      modules = [ 
        home-manager.nixosModules.home-manager
        ./hosts/RazerLaptop/configuration.nix
	./hosts/RazerLaptop/hardware-configuration.nix
      ];
    };
  };
}
