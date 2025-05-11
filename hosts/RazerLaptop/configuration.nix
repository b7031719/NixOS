{ inputs, pkgs, lib, config, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.kernelParams = [ "video=1920x1080" ];

  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;
    };
    grub = { 
      enable = true;
      device = "nodev";
      efiSupport = true;
    };
  };
  
  networking.hostName = "RazerLaptop"; 
  networking.networkmanager.enable = true;
  
  time.timeZone = "Europe/London";
  
  users.users.b7 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "vboxsf" ];
  };

  home-manager.users.b7 = import ../../users/b7/home.nix;
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
 
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  
  # Sound configuration
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;

  console.keyMap = "uk";
  
  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    bolt
  ];

  environment.sessionVariables = {
    LIBGL_ALWAYS_SOFTWARE = "1";
    GALLIUM_DRIVER = "llvmpipe";
  };
  
  system.stateVersion = "24.11";
  
}

