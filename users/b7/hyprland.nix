{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = [
    # Script to toggle mirroring of internal monitor eDP-1 if active and external monitors are connected
    (pkgs.writeShellScriptBin "mirror-toggle" ''
      # All monitors including hidden/mirrored
      ALL_MONITORS=$(hyprctl monitors all | grep '^Monitor' | awk '{print $2}')

      # Active/visible monitors (excludes purely mirrored ones)
      ACTIVE_MONITORS=$(hyprctl monitors | grep '^Monitor' | awk '{print $2}')

      # Exit if internal monitor eDP-1 is not active e.g. lid closed
      if ! echo "$ACTIVE_MONITORS" | grep -q '^eDP-1$'; then
          hyprctl notify 1 1000 "rgb(00ff00)" "Internal monitor not active"
          exit 0
      fi

      # Filter all monitors for external monitors
      EXTERNALS=$(echo "$ALL_MONITORS" | grep -E '^(DP-|HDMI-)')

      # Exit if no external monitors exist
      if [ -z "$EXTERNALS" ]; then
          hyprctl notify 1 1000 "rgb(00ff00)" "No external monitors connected"
          exit 0
      fi

      # Check if any external monitor is missing from active-mirrored mode
      # If an external monitor is in the ACTIVE_MONITORS list then it isn't mirrored
      # Mirrored monitors don't appear in the ACTIVE_MONITORS list only extended monitors
      IS_MIRRORED=true
      for mon in $EXTERNALS; do
          if echo "$ACTIVE_MONITORS" | grep -q "^$mon$"; then
              IS_MIRRORED=false
              break  # At least one external monitor is active / extended
          fi
      done

      # Always set eDP-1 for consistency
      hyprctl keyword monitor "eDP-1,preferred,auto,1"


      if $IS_MIRRORED; then
          # Switch to extended: re-enable each external with position
          for mon in $EXTERNALS; do
              hyprctl keyword monitor "$mon,preferred,auto,1"
              hyprctl notify 1 1000 "rgb(00ff00)" "Switching to extended desktops"
          done
      else
          # Switch to mirrored
          for mon in $EXTERNALS; do
              hyprctl keyword monitor "$mon,preferred,auto,1,mirror,eDP-1"
              hyprctl notify 1 1000 "rgb(00ff00)" "Switching to mirrored mode"
          done
      fi
    '')
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null; # Use the package provided in environment packages
    portalPackage = null;
    configType = "lua";
    xwayland.enable = true; # Enables backwards compatibility with X11 based apps
    systemd.enable = false;
  };

}
