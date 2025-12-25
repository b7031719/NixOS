{ config, lib, pkgs, ... }:

{

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.kernelParams = [ "video=1920x1080" ];   # Set display resolution during boot
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    autoGenerateKeys.enable = true;
    autoEnrollKeys = {
      enable = true;
      autoReboot = true;
    };
  };
  
  networking = {
    networkmanager.enable = true;
  };
  
  users = {
    users.b7 = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "vboxsf" ];
    };
    defaultUserShell = pkgs.zsh;
  };

  hardware.graphics = {   # Enable hardware graphics acceleration
    enable = true;
    enable32Bit = true;
  };

  # Locale settings
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  
  security.rtkit.enable = true;

  services = {
    # Sound configuration
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    # Autologin
    getty = {
      autologinUser = "b7";
      autologinOnce = true;
    };
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;   # For Wayland session management and prevent apps from running as child processes to hyprland
    };
    zsh.enable = true;
  };
  
  environment = {
    pathsToLink = [ "/share/xdg-desktop-portal" "/share/applications" ];   # Create symlinks in the following locations
    shells = with pkgs; [
      zsh
    ];
    systemPackages = with pkgs; [
      sbctl
      bolt
    ];
  };

  virtualisation.virtualbox.guest.enable = true;

  environment.sessionVariables = {   # Disables hardware graphics rendering and forces software rendering. Only required for vbox.
    LIBGL_ALWAYS_SOFTWARE = "1";
    GALLIUM_DRIVER = "llvmpipe";
  };

  system.stateVersion = "24.11";
  
}

