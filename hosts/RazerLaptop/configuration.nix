{ config, lib, pkgs, ... }:
let
  sddmTheme = import ./sddm-theme.nix { inherit pkgs; };
in
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.kernelParams = [ "video=1920x1080" ];   # Set display resolution during boot

  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;   # Allows the bootloader to modify efi variables
    };
    grub = { 
      enable = true;
      device = "nodev";   # nodev required for UEFI booting
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

  hardware.graphics = {   # Enable hardware graphics acceleration
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

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;

  services.displayManager = {
    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;   # required to prevent version error
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs.kdePackages; [
        qtsvg
	qtmultimedia
	qtvirtualkeyboard
      ];
    };
  };

  console.keyMap = "uk";
  
  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];   # Create symlinks in the following locations

  environment.systemPackages = [
    pkgs.neovim
    pkgs.git
    pkgs.wget
    pkgs.bolt
    sddmTheme
  ];

  environment.sessionVariables = {   # Disables hardware graphics rendering and forces software rendering. Only required for vbox.
    LIBGL_ALWAYS_SOFTWARE = "1";
    GALLIUM_DRIVER = "llvmpipe";
  };
  
  system.stateVersion = "24.11";
  
}

