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
      cocLite.enable = lib.mkEnableOption "Whether to enable COC (but not as heavyweight as thru Nix)";
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
        ".vim".source = ../../.vim;
        ".vimrc".source = ../../.vimrc;
      };
    }
    (lib.mkIf cfg.cocLite.enable {
      home.packages = with pkgs; [
        nixd
        nixfmt-rfc-style
      ];
      home.sessionVariables = {
        DOTFILES_ENABLE_COC_NVIM = 1;
      };
      home.file = {
        ".config/nvim/coc-settings.json".source = ../../coc-settings.json;
      };
    })
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
