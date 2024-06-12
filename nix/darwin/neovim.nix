{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Doesn't work, since it needs to go at the end instead
    # extraConfig = builtins.readFile ./dotfiles/.vimrc;
    extraLuaConfig = builtins.readFile ./dotfiles/init.lua;
  };

  home.file = {
    ".vim".source = ./dotfiles/.vim;
    ".vimrc".source = ./dotfiles/.vimrc;
    ".config/nvim/coc-settings.json".source = ./dotfiles/coc-settings.json;
  };
}
