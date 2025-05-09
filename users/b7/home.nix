{ config, pkgs, inputs, ...}:

{
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

  fonts.fontconfig.enable = true;
  
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      "$mod" = "SUPER";
      input = {
        kb_layout = "gb";
      };
      decoration = {
        rounding = 10;
      };
      misc = {
        disable_splash_rendering = true;
      };
    };
    extraConfig = ''
      monitor=,preferred,auto,1

      $terminal = kitty
      $menu = rofi -show drun

      exec-once = waybar
      exec-once = dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland

      $mainMod = SUPER

      bind = $mainMod, Q, exec, $terminal
      bind = $mainMod, M, exit,
      bind = $mainMod, R, exec, $menu
      bind = $mainMod, C, killactive,

      # Move focus binds
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d
      '';
  };

  programs.git = {
    enable = true;
    userName = "b7";
    userEmail = "danfenton@pm.me";
  };

  home.packages = with pkgs; [
    polkit
    waybar
    rofi-wayland
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
