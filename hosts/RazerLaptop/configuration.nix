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
    age.sshKeyPaths = [ "/home/b7/.ssh/id_ed25519_sops" ]; # Used for bootstrapping only

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

    templates."proton.conf" = {
      content = ''
        [Interface]
        PrivateKey = ${config.sops.placeholder."protonvpn/private-key"}
        Address = 10.2.0.2/32, 2a07:b944::2:2/128
        DNS = 10.2.0.1, 2a07:b944::2:1

        [Peer]
        PublicKey = QV+zjwyGF91xEh+bC1ZJXK1B7K9wGlbsds1bkRidIEA=
        Endpoint = 79.127.160.216:51820
        AllowedIPs = 0.0.0.0/0, ::/0
        PersistentKeepalive = 25
      '';
      path = "/run/secrets/ProtonVPN.conf";
      mode = "0400";
      owner = "root";
    };
  };

  systemd.services = {
    unlock-veracrypt-data = {
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

    import-proton-vpn = {
      description = "Import ProtonVPN WireGuard profile into NetworkManager";
      after = [ "NetworkManager.service" ];
      wants = [ "NetworkManager.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "import-proton" ''
          # Delete any previous profile with the same name so re-imports stay clean
          ${pkgs.networkmanager}/bin/nmcli connection delete ProtonVPN 2>/dev/null || true
          ${pkgs.networkmanager}/bin/nmcli connection import type wireguard file /run/secrets/ProtonVPN.conf
          ${pkgs.networkmanager}/bin/nmcli connection modify ProtonVPN \
          connection.id ProtonVPN \
          connection.autoconnect no \
          connection.autoconnect-priority 0
          ${pkgs.networkmanager}/bin/nmcli connection down ProtonVPN || true
          ${pkgs.networkmanager}/bin/nmcli connection reload
        '';
      };
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

  networking.networkmanager.enable = true;

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
    sessionVariables = {
      SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
    };
  };

  system.stateVersion = "25.11";

}
