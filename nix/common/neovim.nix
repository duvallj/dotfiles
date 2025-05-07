{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.neovim;
in
{
  options = {
    programs.neovim = {
      serverAliases = lib.mkOption {
        default = true;
        description = "Whether to enable RPC aliases";
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkMerge [
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        withNodeJs = true;

        # Doesn't work, since it needs to go at the end instead
        # extraConfig = builtins.readFile ../../.vimrc;
        extraLuaConfig = builtins.readFile ../../init.lua;
      };

      home.file = {
        ".vimrc".source = ../../.vimrc;
      };

      # TODO: add configuration options for language servers
      home.packages = with pkgs; [
        nixd
        nixfmt-rfc-style
        vscode-langservers-extracted
      ];
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
  ];
}
