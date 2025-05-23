{ config, pkgs, hyprland, ...}:
let
  hypr = hyprland.packages;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = hypr.${pkgs.stdenv.hostPlatform.system}.hyprland;   # Use the most up to date package provided by the flake
    portalPackage = hypr.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;   # Enables backwards compatibility with X11 based apps
    settings = {
      
      # Define some application variables
      "$terminal" = "kitty";
      "$menu" = "wofi --show drun";
      "$fileManager" = "kitty -e yazi";
      "$editor" = "${config.home.sessionVariables.EDITOR}";

      # Define the mod key binding
      "$mainMod" = "SUPER";

      input = {
        kb_layout = "gb";
      };

      decoration = {
        rounding = 10;
      };

      misc = {
        disable_splash_rendering = true;
      };

      # Key bindings
      bind = [
        "$mainMod, Q, exec, uwsm app -- $terminal"
        "$mainMod, M, exit,"
        "$mainMod, R, exec, uwsm app -- $menu"
        "$mainMod, C, killactive,"
	"$mainMod, B, exec, uwsm app -- brave"
	"$mainMod, T, togglefloating,"
	"$mainMod, E, exec, uwsm app -- $fileManager"
	"$mainMod, F, fullscreen, 1"
	"$mainMod, N, exec, uwsm app -- $editor"
	"$mainMod, L, exec, hyprlock"
	"$mainMod SHIFT, F, fullscreen, 0"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
	"$mainMod, 1, workspace, 1"
	"$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
	"$mainMod SHIFT, 1, workspace, 1"
	"$mainMod SHIFT, 2, workspace, 2"
        "$mainMod SHIFT, 3, workspace, 3"
        "$mainMod SHIFT, 4, workspace, 4"
        "$mainMod SHIFT, 5, workspace, 5"
        "$mainMod SHIFT, 6, workspace, 6"
        "$mainMod SHIFT, 7, workspace, 7"
        "$mainMod SHIFT, 8, workspace, 8"
        "$mainMod SHIFT, 9, workspace, 9"
        "$mainMod SHIFT, 0, workspace, 10"
      ];
      
      bindm = [
        "$mainMod, mouse:272, movewindow"
	"$mainMod, mouse:273, resizewindow"
      ];

      # Monitor settings
      monitor = [ ",preferred,auto,1" ];

      exec-once = [
	"hyprlock --immediate"   # Lock screen immediately on startup (getty autologin enabled)
        "uwsm app -- waybar"
      ];

    };
  };

}
