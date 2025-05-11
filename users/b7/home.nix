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

  home.packages = with pkgs; [
    polkit
    waybar
    rofi-wayland
    dunst
    brave
    tmux
    protonmail-desktop
    proton-pass
    protonvpn-gui
    conda
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack
  ];
  
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.stateVersion = "24.11";

}
