{ config, lib, pkgs, dotfilesPath, ... }:
{
  programs.hyprlock = {
    enable = true;
  };

  # Symlink the config file from the dotfiles repo
  xdg.configFile."hypr/hyprlock.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Hyprlock/hyprlock.conf";
  };

}
