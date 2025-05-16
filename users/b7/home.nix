{ pkgs, ...}:

{
  
  imports = [ ./hyprland.nix ];

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
  };
  
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono Nerd Font";
      font_size = 12;
    };
  };

  programs.vscode = {
    enable = true;
  };

  programs.yazi = {    # Terminal based file manager
    enable = true;
  };

  fonts.fontconfig.enable = true;   # Allows kitty etc. to configure fonts.
  
  programs.git = {
    enable = true;
    userName = "b7";
    userEmail = "danfenton@pm.me";
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

  home.packages = with pkgs; [
    polkit
    brave
    proton-pass
    protonvpn-gui
    protonmail-desktop
    conda
    xdg-utils
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
    vlc
    libreoffice
    librecad
    qelectrotech
    discord
  ];
  
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";   # Try to force electron apps to use Wayland
    EDITOR = "kitty -e nvim";
  };

  home.stateVersion = "24.11";   # Do not change. Required for defining the original home-manager install version

}
