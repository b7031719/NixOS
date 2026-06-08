{ config, lib, pkgs, ... }: 
{
  home.packages = [
    # Script to enable/disable internal monitor eDP-1 based on lid switch
    (pkgs.writeShellScriptBin "lid-toggle" ''

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
    '')

    # Script to toggle mirroring of internal monitor eDP-1 if active and external monitors are connected
    (pkgs.writeShellScriptBin "mirror-toggle" ''

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
    '')
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;    # Use the package provided in environment packages
    portalPackage = null;
    xwayland.enable = true;   # Enables backwards compatibility with X11 based apps
    systemd.enable = false;
  };

}
