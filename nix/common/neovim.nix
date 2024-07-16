{ ... }: {
  programs.neovim = {
    enable = true;
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
    ".config/nvim/coc-settings.json".source = ../../coc-settings.json;
  };
}
