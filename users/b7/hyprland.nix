{ config, pkgs, inputs, ...}:
let
  hypr = inputs.hyprland.packages;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = hypr.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = hypr.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      
      # Define some application variables
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";

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
        "$mainMod, Q, exec, $terminal"
        "$mainMod, M, exit,"
        "$mainMod, R, exec, $menu"
        "$mainMod, C, killactive,"
	"$mainMod, B, exec, brave"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
      ];
      
      # Monitor settings
      monitor = [ ",preferred,auto,1" ];

      exec-once = [
        "waybar"
        "dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland"
      ];

    };
  };

}
