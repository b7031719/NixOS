{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.kernelParams = [ "video=1920x1080" ];   # Set display resolution during boot

  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = true;   # Allows the bootloader to modify efi variables e.g. add boot entry into NVRAM
    };
    grub = { 
      enable = true;
      device = "nodev";   # nodev required for UEFI booting
      efiSupport = true;
    };
  };
  
  networking.hostName = "RazerLaptopVM";
  networking.networkmanager.enable = true;
  
  time.timeZone = "Europe/London";
  
  users.users.b7 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "vboxsf" ];
  };

  services.getty = {   # autologin as b7
    autologinUser = "b7";
    autologinOnce = true;
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
    withUWSM = true;   # For Wayland session management and prevent apps from running as child processes to hyprland
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;

  console.keyMap = "uk";
  
  environment.pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];   # Create symlinks in the following locations

  environment.systemPackages = with pkgs; [
    git
    wget
    bolt
  ];

  environment.sessionVariables = {   # Disables hardware graphics rendering and forces software rendering. Only required for vbox.
    LIBGL_ALWAYS_SOFTWARE = "1";
    GALLIUM_DRIVER = "llvmpipe";
  };
  
  system.stateVersion = "24.11";
  
}

