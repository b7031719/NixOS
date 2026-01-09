{ config, lib, pkgs, ...}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
  repoUrl = "https://github.com/b7031719/dotfiles.git";
in
{
  
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./neovim.nix
    ./zen-browser.nix
  ];
  
  home.username = "b7";
  home.homeDirectory = "/home/b7";

  programs.home-manager.enable = true;

  # Activation script to clone the dotfiles repo
  home.activation.cloneNvimConfig =
    lib.hm.dag.entryAfter ["linkGeneration"] ''
      if [ ! -d "${dotfilesPath}/.git" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git \
        clone ${repoUrl} "${dotfilesPath}"
      fi
    '';

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

  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Caskaydia Cove Nerd Font";
      font_size = 12;
    };
  };

  programs.yazi = {    # Terminal based file manager
    enable = true;
  };

  fonts.fontconfig.enable = true;   # Allows kitty etc. to configure fonts.
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "b7";
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

  services.ssh-agent = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    polkit
    brave
    proton-pass
    protonvpn-gui
    protonmail-desktop
    conda
    xdg-utils
    nerd-fonts.caskaydia-cove
    vlc
    libreoffice
    librecad
    qelectrotech
    discord
    gcc
  ];
  
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";   # Try to force electron apps to use Wayland
    EDITOR = "kitty -e nvim";
  };

  home.stateVersion = "24.11";   # Do not change. Required for defining the original home-manager install version

}
