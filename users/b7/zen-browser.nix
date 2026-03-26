{ config, lib, pkgs, inputs, ... }:
{

  imports = [ inputs.zen-browser.homeModules.default ];

  programs.zen-browser = {
    enable = true;
    package = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        spacesForce = true;
        settings = {
          "browser.startup.page" = 3;
          "privacy.resistFingerprinting" = true;
          "signon.management.page.override" = true;
          "layout.css.prefers-color-scheme.content-override" = 2;
          "browser.theme.content-theme" = 0;
          "browser.theme.toolbar-theme" = 0;
          "ui.systemUsesDarkTheme" = 1;
          "zen.widget.linux.transparency" = true;
          "browser.tabs.allow_transparent_browser" = true;
          "zen.view.compact.color-sidebar" = false;
          "zen.view.compact.color-toolbar" = false;
          "widget.transparent-windows" = true;
          "zen.theme.gradient.show-custom-colors" = false;
          "zen.theme.accent-color" = "#272822";
          "zen.view.compact.theme-color-sidebar" = false;
          "zen.theme.acrylic-elements" = true;
        };
        userChrome = ''
          :root, #main-window, html[zen-compact-mode], #navigator-toolbox, .browser-toolbox-background {
            --zen-primary-color: rgb(39, 40, 34) !important;
            --zen-border-radius: 8px !important;
            --zen-element-separation: 8px !important;
            --zen-background-opacity: 0 !important;
            --toolbox-textcolor: rgba(255, 255, 255, 0.8) !important;
            --zen-main-browser-background: rgba(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-old: rgba(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-toolbar: rbga(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-toolbar: rgba(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-toolbar-old: rgba(39, 40, 34, 0.8) !important;
            --tabpanel-background-color: rgba(39, 40, 34, 0.8) !important;
            --sidebar-background-color: rgba(39, 40, 34, 0.8) !important;
            --background-color-canvas: rgba(39, 40, 24, 0.8) !important;
            --toolbar-bg-color: rgba(39, 40, 34, 0.8) !important;
            --tab-hover-background-color: rgba(39, 40, 34, 0.8) !important;
            --zen-sidebar-notification-bg: rgba(39, 40, 34, 0.8) !important;
            --color-accent-primary: rgba(39, 40, 34, 0.8) !important;
            accent-color: rgba(39, 40, 34, 0.8) !important;
            --toolbox-bg-color: rgba(39, 40, 34, 0.8) !important;
          }

          #navigator-toolbox[zen-has-implicit-hover=true], .browser-toolbox-background[zen-has-implicit-hover=true] {
            --zen-main-browser-background: rgba(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-old: rgba(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-toolbar: rbga(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-toolbar: rgba(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-toolbar-old: rgba(39, 40, 34, 0.8) !important;
          }

          #navigator-toolbox[zen-has-hover=true], .browser-toolbox-background[zen-has-hover=true] {
            --zen-main-browser-background: rgba(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-old: rgba(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-toolbar: rbga(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-toolbar: rgba(39, 40, 34, 0.8) !important;
            --zen-main-browser-background-toolbar-old: rgba(39, 40, 34, 0.8) !important;
          }
        '';
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          ublock-origin
          darkreader
          proton-pass
        ];

        # spaces = {
        #   Default = {
        #     id = "3408cb95-08f7-4808-b2ca-83361670c239";
        #     position = 1000;
        #     theme = {
        #       type = "gradient";
        #       colors = [
        #         {
        #           red = 39;
        #           green = 40;
        #           blue = 34;
        #           algorithm = "floating";
        #           type = "explicit-lightness";
        #         }
        #       ];
        #       opacity = null;
        #       texture = null;
        #     };
        #   };
        # };
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
        "text/html"                        = [ "zen-twilight.desktop" ];
        "x-scheme-handler/http"            = [ "zen-twilight.desktop" ];
        "x-scheme-handler/https"           = [ "zen-twilight.desktop" ];
        "x-scheme-handler/about"           = [ "zen-twilight.desktop" ];
        "x-scheme-handler/unknown"         = [ "zen-twilight.desktop" ];
        "application/xhtml+xml"            = [ "zen-twilight.desktop" ];
        "application/x-extension-htm"      = [ "zen-twilight.desktop" ];
        "application/x-extension-html"     = [ "zen-twilight.desktop" ];
        "application/x-extension-xht"      = [ "zen-twilight.desktop" ];
        "application/x-extension-xhtml"    = [ "zen-twilight.desktop" ];
        "x-scheme-handler/chrome"          = [ "zen-twilight.desktop" ];
      };
    };
  };

}
