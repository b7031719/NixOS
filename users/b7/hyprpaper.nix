{ config, lib, pkgs, dotfilesPath, ... }:
{
  services.hyprpaper = {
    enable = true;
  };

  xdg.configFile."hypr/hyprpaper.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Hyprpaper/hyprpaper.conf";
  };
}
