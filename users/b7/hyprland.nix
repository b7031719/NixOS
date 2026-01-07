{ config, pkgs, hyprland, ...}:
let
  hypr = hyprland.packages;
in
{
  # Add a lid toggle switch to configure external displays from the lid switch event
  home.file.".config/hypr/lid-toggle.sh" = {
    text = ''
      #!/usr/bin/env bash

      if [ "$1" = "open" ]; then
        # Lid open: Enable built-in monitor and extend desktop
        hyprctl keyword monitor "eDP-1, preferred, auto-down, 1" 2>/dev/null || true
      else
        # Check if any external monitor (DP- or HDMI-) is connected
        if hyprctl monitors | grep -Eq 'DP-[0-9]+|HDMI-A-[0-9]+'; then
          # Lid closed: Disable built-in monitor, leaving only external active
          hyprctl keyword monitor "eDP-1, disable" 2>/dev/null || true
        fi
      fi
    '';
    executable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;    # Use the package provided in environment packages
    portalPackage = null;
    xwayland.enable = true;   # Enables backwards compatibility with X11 based apps
    systemd.enable = false;
    settings = {
      misc.disable_watchdog_warning = true;
      
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
      bindl = [
        ",switch:on:Lid Switch,exec,~/.config/hypr/lid-toggle.sh close"  # Lid closed (switch on)
        ",switch:off:Lid Switch,exec,~/.config/hypr/lid-toggle.sh open"  # Lid open (switch off)
      ];

      exec-once = [
	      "hyprlock --immediate"   # Lock screen immediately on startup (getty autologin enabled)
        "uwsm app -- waybar"
      ];

    };
  };

}
