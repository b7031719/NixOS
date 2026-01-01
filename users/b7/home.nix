{ pkgs, ...}:
let
  nvimConfigPath = "${config.home.homeDirectory}/dotfiles/Neovim";
  repoUrl = "git@github.com:b7031719/Neovim.git";
in
{
  
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
  ];
  
  home.username = "b7";
  home.homeDirectory = "/home/b7";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
  };

  programs.neovim = {
    enable = true;

    extraPackages = with pkgs; [
      # LSPs
      sumneko-lua-language-server
      pyright
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      nodePackages.vscode-langservers-extracted

      # Formatters
      black          # Python
      isort          # Python import sorter and formatter
      prettier       # JS/TS/HTML/CSS
      stylua         # Lua
      shfmt          # Bash/shell
      alejandra      # Nix

      # Linters/diagnostics
      shellcheck     # Bash
      eslint         # JS/TS
      flake8         # Python
      statix         # Nix static analysis
    ];
  };

  # Creates a symlink in the nix store to the Neovim configuration directory from the dotfiles directory
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink nvimConfigPath;
  xdg.configFile."nvim".recursive = true;

  # Activation script: Clone the repo if the directory doesn't exist
  home.activation.cloneNvimConfig =
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD [ -d "${nvimConfigPath}/.git" ] || \
        ${pkgs.git}/bin/git clone ${repoUrl} "${nvimConfigPath}"
    '';
  
  home.file.".zprofile".text = ''
    if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
      uwsm start default
    fi
  '';
  
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Caskaydia Cove Nerd Font";
      font_size = 12;
    };
  };

  programs.yazi = {    # Terminal based file manager
    enable = true;
  };

  fonts.fontconfig.enable = true;   # Allows kitty etc. to configure fonts.
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "b7";
        email = "danfenton@pm.me";
      };
    };
  };

  programs.waybar = {
    enable = true;
  };

  programs.wofi = {   # Application launcher
    enable = true;
  };

  programs.tmux = {
    enable = true;
  };

  programs.kodi = {
    enable = true;
    package = pkgs.kodi-wayland;
  };

  services.dunst = {   # Notification daemon
    enable = true;
  };

  services.ssh-agent = {
    enable = true;
  };

  home.packages = with pkgs; [
    polkit
    brave
    proton-pass
    protonvpn-gui
    protonmail-desktop
    conda
    xdg-utils
    nerd-fonts.caskaydia-cove
    vlc
    libreoffice
    librecad
    qelectrotech
    discord
  ];
  
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";   # Try to force electron apps to use Wayland
    EDITOR = "kitty -e nvim";
  };

  home.stateVersion = "24.11";   # Do not change. Required for defining the original home-manager install version

}
