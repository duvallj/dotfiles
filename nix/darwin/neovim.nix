{ pkgs, ... }: {
  home.packages = [ pkgs.neovim ];
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
