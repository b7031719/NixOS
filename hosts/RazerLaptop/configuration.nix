{ config, lib, pkgs, inputs, ... }:

{

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.initrd.systemd = {
    enable = true;
    tpm2.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];
  
  sops = {
    defaultSopsFile = ../../secrets/veracrypt.yaml;
    age.generateKey = true;  # Generates /var/lib/sops-nix/key.txt on first rebuild
    age.keyFile = "/var/lib/sops-nix/key.txt";  # Persistent host key for decryption

    secrets.veracrypt_pass = {
      format = "yaml";
      sopsFile = ../../secrets/veracrypt.yaml;
      key = "veracrypt_password";
      mode = "0400";
    };
  };

  systemd.services.unlock-veracrypt-data = {
    description = "Unlock VeraCrypt data volume after graphical login";
    wantedBy = [ "graphical.target" ];
    after = [ "graphical.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-cryptsetup attach data /dev/nvme0n1p8 ${config.sops.secrets.veracrypt_pass.path} tcrypt-veracrypt";
      ExecStop = "${pkgs.systemd}/lib/systemd/systemd-cryptsetup detach data";
    };
  };

  fileSystems."/mnt/data" = { 
    device = "/dev/mapper/data";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" "gid=100" "umask=0022" "nofail" ];
  };
  
  networking = {
    networkmanager.enable = true;
  };
  
  users = {
    users.b7 = {
      isNormalUser = true;
      initialPassword = "nix1";
      extraGroups = [ "wheel" "networkmanager" ];
    };
    defaultUserShell = pkgs.zsh;
  };

  users.users.root.initialPassword = "nix1";

  hardware.graphics = {   # Enable hardware graphics acceleration
    enable = true;
    enable32Bit = true;
  };

  # Locale settings
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";
  
  security = {
    rtkit.enable = true;
    polkit.enable = true;
    tpm2.enable = true;
  };

  services = {
    # Sound configuration
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;    # Provides a legacy API for supporting legacy PulseAudio apps
      jack.enable = true;     # Provices a legacy API for supporting legacy JACK apps
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
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;      # Use package provided by flake
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
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
      ntfs3g
      veracrypt
      bolt
    ];
  };

  system.stateVersion = "25.11";
  
}

