{ config, lib, pkgs, inputs, ... }:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
in 
{
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper;
  };

  xdg.configFile."hypr/hyprpaper.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Hyprpaper/hyprpaper.conf";
  };
}
