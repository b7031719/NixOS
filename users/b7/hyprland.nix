{ config, pkgs, hyprland, ...}:
let
  hypr = hyprland.packages;
in
{
  # Script to enable/disable internal monitor eDP-1 based on lid switch
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

  # Script to toggle mirroring of internal monitor eDP-1 if active and external monitors are connected
  home.file.".config/hypr/mirror-toggle.sh" = {
    text = ''
      #!/usr/bin/env bash

      # All monitors including hidden/mirrored
      ALL_MONITORS=$(hyprctl monitors all | grep '^Monitor' | awk '{print $2}')

      # Active/visible monitors (excludes purely mirrored ones)
      ACTIVE_MONITORS=$(hyprctl monitors | grep '^Monitor' | awk '{print $2}')

      # Check if eDP-1 is active
      if ! echo "$ACTIVE_MONITORS" | grep -q '^eDP-1$'; then
          exit 0
      fi

      hyprctl notify 1 1000 "rgb(00ff00)" "Toggling mirror mode"

      # Potential externals
      POTENTIAL_EXTERNALS=$(echo "$ALL_MONITORS" | grep -E '^(DP-|HDMI-)')

      if [ -z "$POTENTIAL_EXTERNALS" ]; then
          exit 0
      fi

      # Check if any potential external is missing from active → mirrored mode
      IS_MIRRORED=true
      for mon in $POTENTIAL_EXTERNALS; do
          if echo "$ACTIVE_MONITORS" | grep -q "^$mon$"; then
              IS_MIRRORED=false
              break  # At least one external is visible → extended
          fi
      done

      # Always set eDP-1 for consistency
      hyprctl keyword monitor "eDP-1,preferred,auto,1"

      if $IS_MIRRORED; then
          # Switch to extended: re-enable each external with position
          for mon in $POTENTIAL_EXTERNALS; do
              hyprctl keyword monitor "$mon,preferred,auto,1"
          done
      else
          # Switch to mirrored
          for mon in $POTENTIAL_EXTERNALS; do
              hyprctl keyword monitor "$mon,preferred,auto,1,mirror,eDP-1"
          done
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

      dwindle = {
        preserve_split      = true;
        force_split         = 0;          # 0 = smart based on mouse pos
        default_split_ratio = 1;
        smart_split         = true;
        smart_resizing      = true;
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
        "$mainMod, P, exec, ${config.xdg.configHome}/hypr/mirror-toggle.sh"
        "$mainMod, S, togglesplit,"
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
	      "$mainMod SHIFT, 1, movetoworkspace, 1"
	      "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Brightness controls
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"

        # Volume controls
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"

        # Media controls
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
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
