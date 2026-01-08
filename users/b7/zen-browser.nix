{ config, pkgs, inputs, ... }:
{
  programs.zen-browser = {
    enable = true;
    package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        settings = {
          "browser.startup.page" = 3;
          "privacy.resistFingerprinting" = true;
          "signon.management.page.override" = true;
        };
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          darkreader
          proton-pass
        ];
      };
    };
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "zen.desktop";
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
      };
    };
  };
}
