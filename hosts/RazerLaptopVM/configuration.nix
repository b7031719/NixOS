{ config, lib, pkgs, ... }:

{

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
  
  networking = {
    networkmanager.enable = true;
  };
  
  time.timeZone = "Europe/London";
  
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
      bolt
    ];
  };

  system.stateVersion = "24.11";
  
}

