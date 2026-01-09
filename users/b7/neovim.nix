{ config, pkgs, ...}:
let
  dotfilesPath = "${config.home.homeDirectory}/dotfiles";
in
{
  programs.neovim = {
    enable = true;

    extraPackages = with pkgs; [
      # LSPs
      lua-language-server
      pyright
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      nodePackages.vscode-langservers-extracted
      nixd

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
      python313Packages.flake8         # Python
      statix         # Nix static analysis
    ];
  };

  # Creates a symlink in the nix store to the Neovim configuration directory from the dotfiles directory
  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/Neovim";
    recursive = true;
  };
}
