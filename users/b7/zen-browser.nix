{ config, lib, pkgs, inputs, ... }:
{

  imports = [ inputs.zen-browser.homeModules.default ];

  programs.zen-browser = {
    enable = true;
    package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        spacesForce = true;
        settings = {
          "browser.startup.page" = 3;
          "privacy.resistFingerprinting" = true;
          "signon.management.page.override" = true;
          "layout.css.prefers-color-scheme.content-override" = 0;
          "browser.theme.content-theme" = 0;
          "browser.theme.toolbar-theme" = 0;
          "ui.systemUsesDarkTheme" = true;
        };
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          darkreader
          proton-pass
        ];

        spaces = {
          Default = {
            id = "3408cb95-08f7-4808-b2ca-83361670c239";
            position = 1000;
            theme = {
              type = "gradient";
              colors = [
                {
                  red = 248;
                  green = 248;
                  blue = 242;
                  algorithm = "complementary";
                  type = "explicit-lightness";
                }
              ];
              opacity = 0.85;
              texture = 0.5;
            };
          };
        };
      };
    };

    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html"                        = [ "zen-beta.desktop" ];
        "x-scheme-handler/http"            = [ "zen-beta.desktop" ];
        "x-scheme-handler/https"           = [ "zen-beta.desktop" ];
        "x-scheme-handler/about"           = [ "zen-beta.desktop" ];
        "x-scheme-handler/unknown"         = [ "zen-beta.desktop" ];
        "application/xhtml+xml"            = [ "zen-beta.desktop" ];
        "application/x-extension-htm"      = [ "zen-beta.desktop" ];
        "application/x-extension-html"     = [ "zen-beta.desktop" ];
        "application/x-extension-xht"      = [ "zen-beta.desktop" ];
        "application/x-extension-xhtml"    = [ "zen-beta.desktop" ];
        "x-scheme-handler/chrome"          = [ "zen-beta.desktop" ];
      };
    };
  };

}
