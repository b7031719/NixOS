{ config, pkgs, inputs, ...}:

{
  
  imports = [ ./hyprland.nix ];

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    loginExtra = ''
      [[ "$(tty)" == "/dev/tty1" ]] && exec Hyprland
    '';
  };
  
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrains Mono Nerd Font";
      font_size = 12;
    };
  };

  programs.yazi = {
    enable = true;
  };

  fonts.fontconfig.enable = true;
  
  programs.git = {
    enable = true;
    userName = "b7";
    userEmail = "danfenton@pm.me";
  };

  programs.waybar = {
    enable = true;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  programs.tmux = {
    enable = true;
  };

  home.packages = with pkgs; [
    polkit
    dunst
    brave
    proton-pass
    protonvpn-gui
    protonmail-desktop
    conda
    xdg-utils
    gtk3
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];
  
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };

  home.stateVersion = "24.11";

}
