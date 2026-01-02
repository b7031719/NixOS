{ pkgs, ...}:
{
  
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./neovim.nix
  ];
  
  home.username = "b7";
  home.homeDirectory = "/home/b7";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
  };

  home.file.".zprofile".text = ''
    if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
      uwsm start default
    fi
  '';
  
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

  services.dunst = {   # Notification daemon
    enable = true;
  };

  services.ssh-agent = {
    enable = true;
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
