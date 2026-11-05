{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.initrd.systemd = {
    tpm2.enable = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];

  sops = {
    age.generateKey = true; # Generates /var/lib/sops-nix/key.txt on first rebuild
    age.keyFile = "/var/lib/sops-nix/key.txt"; # Persistent host key for decryption

    secrets.veracrypt_pass = {
      format = "yaml";
      sopsFile = ../../secrets/veracrypt.yaml;
      key = "veracrypt_password";
      mode = "0400";
    };

    secrets."protonvpn/private-key" = {
      format = "yaml";
      sopsFile = ../../secrets/proton.yaml;
      owner = "root";
      group = "root";
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
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "umask=0022"
      "nofail"
    ];
  };

  networking = {
    networkmanager = {
      enable = true;
      ensureProfiles = {
        profiles.proton = {
          connection = {
            id = "ProtonVPN";
            type = "wireguard";
            interface-name = "proton";
            autoconnect = false;
            permissions = "user:b7";
          };

          ipv4 = {
            method = "manual";
            addresses = "10.2.0.2/32";
            dns = "10.2.0.1";
          };

          ipv6 = {
            method = "manual";
            addresses = "2a07:b944::2:2/128";
            dns = "2a07:b944::2:1";
          };

          wireguard = {
            private-key-flags = 1;
          };

          "wireguard-peer.QV+zjwyGF91xEh+bC1ZJXK1B7K9wGlbsds1bkRidIEA=" = {
            allowed-ips = "0.0.0.0/0;::/0";
            endpoint = "79.127.160.216:51820";
            persistent-keepalive = 25;
          };
        };

        secrets.entries = [
          {
            matchId = "ProtonVPN";
            matchType = "wireguard";
            matchSetting = "wireguard";
            key = "private-key";
            file = config.sops.secrets."protonvpn/private-key".path;
          }
        ];
      };
    };
  };

  users = {
    users.b7 = {
      isNormalUser = true;
      initialPassword = "nix1";
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "vboxusers"
      ];
    };
    defaultUserShell = pkgs.zsh;
  };

  users.users.root.initialPassword = "nix1";

  hardware.bluetooth.enable = true;

  services = {
    hardware = {
      bolt.enable = true;
    };
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
    #logind configuration
    logind = {
      settings.Login = {
        IdleAction = "lock";
        IdleActionSec = 300;
        SleepOperation = [
          "suspend"
          "suspend-then-hibernate"
          "hibernate"
        ];
        HandlePowerKey = "suspend";
        HandlePowerKeyLongPress = "poweroff";
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "ignore";
        HandleLidSwitchDocked = "ignore";
      };
    };
    # Sound configuration
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true; # Provides a legacy API for supporting legacy PulseAudio apps
      jack.enable = true; # Provices a legacy API for supporting legacy JACK apps
    };
    # Autologin
    getty = {
      autologinUser = "b7";
      autologinOnce = true;
    };
    # A daemon for providing a dbus interface for storage devices including usb flash drives
    udisks2 = {
      enable = true;
      settings = {
      };
    };
    # Service for periodic trim of mounted partitions
    fstrim.enable = true;
    # gvfs for Android MTP support
    gvfs.enable = true;
  };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true; # For Wayland session management and prevent apps from running as child processes to hyprland
      xwayland.enable = true;
    };
    zsh.enable = true;
  };

  # Virtualbox
  virtualisation = {
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
    };
  };

  environment = {
    pathsToLink = [
      "/share/xdg-desktop-portal"
      "/share/applications"
      "/share/hypr"
    ]; # Create symlinks in the following locations
    shells = with pkgs; [
      zsh
    ];
    systemPackages = with pkgs; [
      ntfs3g
      veracrypt
      brightnessctl
      playerctl
      wireguard-tools
    ];
  };

  system.stateVersion = "25.11";

}
