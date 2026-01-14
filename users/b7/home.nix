{ config, lib, pkgs, username, homeDirectory, dotfilesPath, repoUrl, ... }:
{
  
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./neovim.nix
    ./zen-browser.nix
  ];
  
  home.username = "${username}";
  home.homeDirectory = "${homeDirectory}";

  programs.home-manager.enable = true;

  # Activation script to clone the dotfiles repo
  home.activation.cloneDofiles =
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -d "${dotfilesPath}/.git" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git \
        clone ${repoUrl} "${dotfilesPath}"
      fi
    '';

  # Create a symlink from the dotfiles repo folder to the user .config folder
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
      recursive = true;
    };
    "hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/hypr";
      recursive = true;
    };
    "kitty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/kitty";
      recursive = true;
    };
    "starship.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/starship.toml";
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    loginExtra = ''
      if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop > /dev/null 2>&1
      fi
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.yazi = {    # Terminal based file manager
    enable = true;
  };

  fonts.fontconfig.enable = true;   # Allows kitty etc. to configure fonts.
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "${username}";
        email = "danfenton@pm.me";
      };
    };
  };

  programs.waybar = {
    enable = true;
  };

  programs.wofi = {   # Application launcher
    enable = true;
  };

  programs.tmux = {
    enable = true;
  };

  programs.kodi = {
    enable = true;
    package = pkgs.kodi-wayland;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      identitiesOnly = true;
      identityFile = "~/.ssh/id_ed25519";
    };
  };

  services.dunst = {   # Notification daemon
    enable = true;
  };

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };

  services.ssh-agent = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    kitty
    polkit
    brave
    proton-pass
    protonvpn-gui
    protonmail-desktop
    conda
    xdg-utils
    nerd-fonts.caskaydia-cove
    libreoffice
    librecad
    qelectrotech
    discord
    usbutils
    udisks2
    udiskie
  ];
  
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";   # Try to force electron apps to use Wayland
    EDITOR = "kitty -e nvim";
  };

  home.stateVersion = "24.11";   # Do not change. Required for defining the original home-manager install version

}
