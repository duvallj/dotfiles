{ pkgs, ... }:
{
  home.packages = with pkgs; [
    difftastic
    git
    git-lfs
  ];
}
