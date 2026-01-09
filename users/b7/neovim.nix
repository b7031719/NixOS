{ config, lib, pkgs, ...}:
let
  nvimConfigPath = "${config.home.homeDirectory}/dotfiles";
  repoUrl = "https://github.com/b7031719/dotfiles.git";
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
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${nvimConfigPath}/Neovim";
  xdg.configFile."nvim".recursive = true;

  # Activation script: Clone the repo if the directory doesn't exist
  home.activation.cloneNvimConfig =
    lib.hm.dag.entryAfter ["linkGeneration"] ''
      if [ ! -d "${nvimConfigPath}/.git" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git \
	clone ${repoUrl} "${nvimConfigPath}"
      fi
    '';
}
