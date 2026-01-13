{
  description = "NixOS and home-manager flake";

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
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ...}@inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {        # pkgs created to set the allowUnfree config parameter
        inherit system;
        config.allowUnfree = true;
      };
    in {

      # NIXOS SYSTEM CONFIGURATIONS
      nixosConfigurations = {
        RazerLaptopVM = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/RazerLaptopVM/configuration.nix
            ./hosts/RazerLaptopVM/hardware-configuration.nix
            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.sops-nix.nixosModules.sops
          ];
        };

        RazerLaptop = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/RazerLaptop/configuration.nix
            ./hosts/RazerLaptop/hardware-configuration.nix
            ./hosts/RazerLaptop/gpu.nix
            inputs.sops-nix.nixosModules.sops
          ];
        };
      };
      

      # HOME-MANAGER CONFIGURATIONS (STANDALONE)
      homeConfigurations = { 
        b7 = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/b7/home.nix ];
          extraSpecialArgs = {
            inherit inputs;
            username = "b7";
            homeDirectory = "/home/b7";
            dotfilesPath = "/home/b7/dotfiles";
            repoUrl = "https://github.com/b7031719/dotfiles.git";
          };
        };
      };

    };
}
