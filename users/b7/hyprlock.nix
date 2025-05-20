{ pkgs, hyprlock, ...}:
let
  hyprl = hyprlock.packages;
in
{

programs.hyprlock = {

  enable = true;

  package = hyprl.${pkgs.stdenv.hostPlatform.system}.hyprlock;   # Use the most up to date package provided by the flake

  settings = {

    general = {
      hide_cursor = true;
      no_fade_in = false;
    };

    animations = {
      enabled = true;
      bezier = "linear, 1, 1, 0, 0";
      animation =  [
        "fadeIn, 1, 5, linear"
        "fadeOut, 1, 5, linear"
        "inputFieldDots, 1, 2, linear"
      ];
    };

    background = {
      monitor = [ "" ];
#      path = "screenshot";
      blur_passes = 3;
    };

    input-field = {
      monitor = [ "" ];
      size = "20%, 5%";
      outline_thickness = 3;
      inner_color = "rgba(0, 0, 0, 0.0)"; # no fill
      outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
      fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";
      font_color = "rgb(143, 143, 143)";
      fade_on_empty = false;
      rounding = 15;
      font_family = "JetBrainsMono Nerd Font";
      placeholder_text = "something dicked";
      dots_spacing = 0.3;
      position = "0, -20";
      halign = "center";
      valign = "center";
    };

    label = {
      monitor = [ "" ];
      text = ''
        cmd[update:60000] date +"%A, %d %B %Y"
      ''; # update every 60 seconds
      font_size = 25;
      font_family = "JetBrainsMono Nerd Font";
      position = "-30, -150";
      halign = "right";
      valign = "top";
    };

  };
};

}
