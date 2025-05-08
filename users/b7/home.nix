{ config, pkgs, inputs, ...}:

{
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
  };
  
  programs.kitty.enable = true;
  
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    settings = { "$mod" = "SUPER"; };
    extraConfig = ''
      monitor=,preferred,auto,auto

      $terminal = kitty

      exec-once = waybar
      exec-once = dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland

      input = {
        kb_layout = uk
      }

      $mainMod = SUPER

      bind = $mainMod, Q, exec, $terminal
      bind = $mainMod, M, exit,
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
    brave
    tmux
    protonmail-desktop
    proton-pass
    protonvpn-gui
    conda
  ];
  
  home.sessionVariables.NIXOS_OZONE_WL = "1";

  home.stateVersion = "24.11";

}
