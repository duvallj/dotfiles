{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.neovim;

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    wrapRc = false;
  };

  wrappedNeovim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped neovimConfig;
in
{
  options.programs.neovim = {
    nonManagedEnable = lib.mkEnableOption "Whether to enable my custom non-managed Neovim configuration";
    serverAliases = lib.mkOption {
      default = false;
      description = "Whether to enable RPC aliases";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.nonManagedEnable (
    lib.mkMerge [
      {
        # I don't use this because I want to track these dotfiles directly from git instead.
        # programs.neovim.enable = true;

        home.sessionVariables = {
          EDITOR = "nvim";
        };

        home.shellAliases = {
          vimdiff = "nvim -d";
        };

        home.packages = [
          wrappedNeovim
        ]
        ++
          # TODO: add configuration options for language servers
          (with pkgs; [
            clang-analyzer
            ffmpeg-full
            ghostscript_headless
            imagemagick
            nixd
            nixfmt-rfc-style
            vscode-js-debug
            vscode-langservers-extracted
          ]);
      }
      (lib.mkIf cfg.serverAliases {
        home.shellAliases =
          let
            serverPipe = "\"\${HOME}/.config/nvim/server.pipe\"";
          in
          {
            rvim = "nvim --server ${serverPipe}";
            svim = "nvim --listen ${serverPipe}";
          };
      })
    ]
  );
}
